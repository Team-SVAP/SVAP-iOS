import Foundation
import Moya

enum AuthAPI {
    case signup(name: String, id: String, password: String)
    case login(id: String, password: String)
    case loadUserPetition
}

extension AuthAPI: TargetType {
    var baseURL: URL {
//        return URL(string: <#T##String#>)
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
            case .signup(let name, let id, let password):
                return .requestParameters(
                    parameters: [
                        "userName": name,
                        "accountId": id,
                        "password": password
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
