import Foundation
import RxSwift
import RxCocoa
import Moya

enum AuthAPI {
    case signup(id: String, password: String, name: String)
    case login(id: String, password: String)
    case loadUserInfo
    case loadUserPetition
    case idDuplication(accountId: String)
}

extension AuthAPI: TargetType {
    var baseURL: URL {
        return URL(string: "http://15.164.62.45:8080")!
    }
    
    var path: String {
        switch self {
            case .signup:
                return "/user/signup"
            case .login:
                return "/user/login"
            case .loadUserInfo:
                return "/user/my-info"
            case .loadUserPetition:
                return "/user"
            case .idDuplication:
                return "/user/duplication"
        }
    }
    
    var method: Moya.Method {
        switch self {
            case .signup:
                return .post
            case .login:
                return .post
            case .loadUserPetition, .loadUserInfo:
                return .get
            case .idDuplication:
                return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
            case .signup:
                return .requestParameters(
                    parameters: [
                        "userName": SignupInfo.shared.userName,
                        "accountId": SignupInfo.shared.accountId,
                        "password": SignupInfo.shared.password
                    ],
                    encoding: JSONEncoding.default)
            case .login(let id, let password):
                return .requestParameters(
                    parameters: [
                        "accountId": id,
                        "password": password
                    ],
                    encoding: JSONEncoding.default)
            case .idDuplication(let accountId):
                return .requestParameters(
                    parameters: [
                        "accountId": accountId
                    ], encoding: JSONEncoding.default)
            default:
                return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
            case .loadUserPetition, .loadUserInfo:
                return Header.accessToken.header()
            default:
                return Header.tokenIsEmpty.header()
        }
    }
}
