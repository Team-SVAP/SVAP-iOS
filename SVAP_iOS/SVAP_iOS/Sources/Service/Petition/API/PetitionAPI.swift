import Foundation
import Moya

enum PetitionAPI {
//    case createPetition(title: String, content: String, types: String, location: String, image: Data)
    case modifyPetition(title: String, content: String, location: String, types: String,
                        petitionId: Int)
    case deletePetition(petitionId: Int)
    case loadDetailPetition(petitionId: Int)
//    case searchPetition()
    case loadPopularPetition
    case loadRecentPetition(type: String)
    case loadAllRecentPetitoin
}

extension PetitionAPI: TargetType {
    var baseURL: URL {
        return URL(string: "http://15.164.62.45:8080 ")!
    }
    
    var path: String {
        switch self {
//            case .createPetition:
//                return "/petition"
            case .modifyPetition(let petitionId):
                return "/petition/\(petitionId)"
            case .deletePetition(let petitionId):
                return "petition/\(petitionId)"
            case .loadDetailPetition(let petitionId):
                return "/user/\(petitionId)"
            case .loadPopularPetition:
                return "/petition/popular"
            case .loadRecentPetition(let type):
                return "/petition/recent/\(type)"
            case .loadAllRecentPetitoin:
                return "/recent/all"
                
        }
    }
    
    var method: Moya.Method {
        switch self {
//            case .createPetition:
//                return .post
            case .modifyPetition:
                return .patch
            case .deletePetition:
                return .delete
            case .loadDetailPetition, .loadPopularPetition, .loadRecentPetition, .loadAllRecentPetitoin:
                return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
//            case .createPetition(title: let title, content: let content, types: let types, location: let location, image: let image):
//                <#code#>
            case .modifyPetition(let title, let content, let location, let types, _):
                return .requestParameters(
                    parameters: [
                        "title": title,
                        "content": content,
                        "location": location,
                        "types": types
                    ], encoding: JSONEncoding.default)
            case .deletePetition, .loadDetailPetition, .loadPopularPetition, .loadRecentPetition, .loadAllRecentPetitoin:
                return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
//            case .createPetition:
            case .modifyPetition, .deletePetition:
                return Header.accessToken.header()
            default:
                return Header.tokenIsEmpty.header()
        }
    }
    
    
}
