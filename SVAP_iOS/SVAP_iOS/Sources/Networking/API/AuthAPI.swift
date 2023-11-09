import Foundation
import RxSwift
import RxCocoa
import Moya

enum AuthAPI {
    case signup(SignupInfo)
    case login(id: String, password: String)
    case refreshToken
    case loadUserInfo
    case loadUserPetition
    case idCheck(accountId: String)
    case nameCheck(userName: String)
    case passwordCheck(password: String)
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
            case .refreshToken:
                return "/user/reissue"
            case .loadUserInfo:
                return "/user/my-info"
            case .loadUserPetition:
                return "/user"
            case .idCheck:
                return "/user/ck-account-id"
            case .nameCheck:
                return "/user/ck-username"
            case .passwordCheck:
                return "/user/ck-password"
        }
    }
    
    var method: Moya.Method {
        switch self {
            case .loadUserPetition, .loadUserInfo:
                return .get
            default:
                return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
            case .signup:
                return .requestParameters(
                    parameters: [
                        "userName": SignupInfo.shared.userName.value!,
                        "accountId": SignupInfo.shared.accountId.value!,
                        "password": SignupInfo.shared.password.value!
                    ], encoding: JSONEncoding.default)
            case .login(let id, let password):
                return .requestParameters(
                    parameters: [
                        "accountId": id,
                        "password": password
                    ], encoding: JSONEncoding.default)
            case .idCheck(let accountId):
                return .requestParameters(
                    parameters: [
                        "accountId": accountId
                    ], encoding: JSONEncoding.default)
            case .nameCheck(let userName):
                return .requestParameters(
                    parameters: [
                        "username": userName
                    ], encoding: JSONEncoding.default)
            case .passwordCheck(let password):
                return .requestParameters(
                    parameters: [
                        "password": password
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
