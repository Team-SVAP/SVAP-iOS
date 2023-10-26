import Foundation
import Moya

enum PetitionAPI {
    case createPetition(content: [String?], image: Data)
    case modifyPetition(title: String, content: String, location: String, types: String, petitionId: Int)
    case deletePetition(petitionId: Int)
    case loadDetailPetition(petitionId: Int)
    case searchPetition(title: String)
    case loadPopularPetition
    case loadRecentPetition(type: String)
    case loadAllRecentPetitoin
    case loadPetitionVote(type: String)
    case loadAllPetitionVote
    case loadAccessPetition(type: String)
    case loadAllAccessPetition
    case loadWaitPetition(type: String)
    case loadAllWaitPetiton
}

extension PetitionAPI: TargetType {
    var baseURL: URL {
        return URL(string: "http://15.164.62.45:8080")!
    }
    
    var path: String {
        switch self {
            case .createPetition:
                return "/petition"
            case .modifyPetition(let petitionId):
                return "/petition/\(petitionId)"
            case .deletePetition(let petitionId):
                return "petition/\(petitionId)"
            case .loadDetailPetition(let petitionId):
                return "/user/\(petitionId)"
            case .searchPetition:
                return "/petition/search"
            case .loadPopularPetition:
                return "/petition/popular"
            case .loadRecentPetition(let type):
                return "/petition/recent/\(type)"
            case .loadAllRecentPetitoin:
                return "/petition/recent-all"
            case .loadPetitionVote(let type):
                return "/vote/\(type)"
            case .loadAllPetitionVote:
                return "/vote-all"
            case .loadAccessPetition(let type):
                return "/access/\(type)"
            case .loadAllAccessPetition:
                return "/access-all"
            case .loadWaitPetition(let type):
                return "/wait\(type)"
            case .loadAllWaitPetiton:
                return "/wait-all"
        }
    }
    
    var method: Moya.Method {
        switch self {
            case .createPetition:
                return .post
            case .searchPetition:
                return .post
            case .modifyPetition:
                return .patch
            case .deletePetition:
                return .delete
            default:
                return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
            case .createPetition(let content, let image):
                var multipart: [MultipartFormData] = []
                
//                multipart.append(MultipartFormData(provider: .data(content.data(using: .utf8)!), name: "{title, content, types, location"))
                multipart.append(.init(provider: .data(content.description.data(using: .utf8)!), name: "{title, content, types, location}"))
//                multipart.append(MultipartFormData(provider: .data(content.data(using: .utf8)!), name: "content"))
//                multipart.append(MultipartFormData(provider: .data(types.data(using: .utf8)!), name: "types"))
//                multipart.append(MultipartFormData(provider: .data(location.data(using: .utf8)!), name: "location"))
                image.forEach({_ in 
                    multipart.append(
                        .init(
                            provider: .data(image),
                            name: "image",
                            fileName: "image.jpg",
                            mimeType: "image/jpg"
                        ))
                })
                return .uploadMultipart(multipart)
            case .searchPetition(let title):
                return .requestParameters(
                    parameters: [
                        "title": title
                    ], encoding: JSONEncoding.default)
            case .modifyPetition(let title, let content, let location, let types, _):
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
            case .createPetition, .modifyPetition, .deletePetition:
                return Header.accessToken.header()
            default:
                return Header.tokenIsEmpty.header()
        }
    }
    
    
}
