import Foundation
import Moya

enum AuthAPI {
    case signup(UserInfo)
    case login(id: String, password: String)
    case loadUserPetition
}

extension AuthAPI: TargetType {
    var baseURL: URL {
        return URL(string: "15.164.62.45:8080")!
    }
    
    var path: String {
        switch self {
            case .signup:
                return "/user/signup"
            case .login:
                return "/user/login"
            case .loadUserPetition:
                return "/user"
        }
    }
    
    var method: Moya.Method {
        switch self {
            case .signup:
                return .post
            case .login:
                return .post
            case .loadUserPetition:
                return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
            case .signup:
                return .requestParameters(
                    parameters: [
                        "userName": UserInfo.shared.userName,
                        "accountId": UserInfo.shared.accountId,
                        "password": UserInfo.shared.password
                    ],
                    encoding: JSONEncoding.default)
            case .login(let id, let password):
                return .requestParameters(
                    parameters: [
                        "accountId": id,
                        "password": password
                    ],
                    encoding: JSONEncoding.default)
            case .loadUserPetition:
                return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
            case .loadUserPetition:
                return Header.accessToken.header()
            default:
                return Header.tokenIsEmpty.header()
        }
    }
}
