//import Foundation
//import Moya
//
//enum PetitionAPI {
//    case createPetition(title: String, content: String, types: String, location: String, image: Data)
//}
//
//extension PetitionAPI: TargetType {
//    var baseURL: URL {
//        return URL(string: "15.164.62.45:8080 ")!
//    }
//    
//    var path: String {
//        switch self {
//            case .createPetition:
//                return "/petition"
//        }
//    }
//    
//    var method: Moya.Method {
//        switch self {
//            case .createPetition:
//                return .post
//        }
//    }
//    
//    var task: Moya.Task {
//        switch self {
//            case .createPetition(title: let title, content: let content, types: let types, location: let location, image: let image):
//                <#code#>
//        }
//    }
//    
//    var headers: [String : String]? {
//        switch self {
//            default:
//                return Header.tokenIsEmpty.header()
//        }
//    }
//    
//    
//}
