import Foundation
import Moya

enum PetitionAPI {
    case createPetition(title: String, content: String, types: String, location: String, images: [String]?)
    case editPetition(title: String, content: String, location: String, types: String, petitionId: Int)
    case deletePetition(petitionId: Int)
    case loadDetailPetition(petitionId: Int)
    case searchPetition(title: String)
    case loadPopularPetition
    case sortPetition(type: String, accessTypes: String)
    case sortAllPetition(accessType: String)
    case loadPetitionVote(type: String)
    case loadAllPetitionVote
    case votePetition(petitionId: Int)
    case reportPetition(petitionId: Int)
}

extension PetitionAPI: TargetType {
    var baseURL: URL {
        return URL(string: "http://15.164.62.45:8080")!
    }
    
    var path: String {
        switch self {
            case .createPetition:
                return "/petition"
            case .editPetition(let petitionId):
                return "/petition/\(petitionId)"
            case .deletePetition(let petitionId):
                return "petition/\(petitionId)"
            case .loadDetailPetition(let petitionId):
                return "/petition/\(petitionId)"
            case .searchPetition:
                return "/petition/search"
            case .loadPopularPetition:
                return "/petition/popular"
            case .sortPetition(let type, let accessTypes):
                return "/petition/sort/\(type)/\(accessTypes)"
            case .sortAllPetition(accessType: let accessType):
                return "/petition/sort-all/\(accessType)"
            case .loadPetitionVote(let type):
                return "/petition/vote/\(type)"
            case .loadAllPetitionVote:
                return "/petition/vote-all"
            case .votePetition(let petitionId):
                return "/vote/\(petitionId)"
            case .reportPetition(let petitionId):
                return "/report/\(petitionId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
            case .createPetition, .searchPetition, .reportPetition:
                return .post
            case .editPetition:
                return .patch
            case .deletePetition:
                return .delete
            case .votePetition:
                return .patch
            default:
                return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
            case .createPetition(let title, let content, let types, let location, let images):
//                var imageArray: [String] = []
//                for image in images! {
////                    let imageString = image.base64EncodedString()
//                    imageArray.append(image)
//                }
                return .requestParameters(parameters: [
                    "title" : title,
                    "content" : content,
                    "types" : types,
                    "location" : location,
                    "imageUrlList": images!
                ], encoding: JSONEncoding.default)
            case .searchPetition(let title):
                return .requestParameters(
                    parameters: [
                        "title": title
                    ], encoding: JSONEncoding.default)
            case .editPetition(let title, let content, let location, let types, _):
                return .requestParameters(
                    parameters: [
                        "title": title,
                        "content": content,
                        "location": location,
                        "types": types
                    ], encoding: JSONEncoding.default)
            default:
                return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
            case .createPetition, .editPetition, .deletePetition, .votePetition, .reportPetition:
                return Header.accessToken.header()
            default:
                return Header.tokenIsEmpty.header()
        }
    }
    
    
}
