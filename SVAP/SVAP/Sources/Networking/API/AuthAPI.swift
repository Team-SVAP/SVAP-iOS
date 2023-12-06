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
    case passwordCheck(password: String)
    case userWithdrawal
}

extension AuthAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://prod-server.xquare.app/svap")!
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
            case .passwordCheck:
                return "/user/ck-password"
            case .userWithdrawal:
                return"/user"
        }
    }
    
    var method: Moya.Method {
        switch self {
            case .loadUserPetition, .loadUserInfo:
                return .get
            case .userWithdrawal:
                return .delete
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
            case .loadUserPetition, .loadUserInfo, .userWithdrawal:
                return Header.accessToken.header()
            case .refreshToken:
                return Header.refreshToken.header()
            default:
                return Header.tokenIsEmpty.header()
        }
    }
}
