import Foundation
import UIKit
import Moya

enum PetitionAPI {
    case sendImage(images: [Data])
    case createPetition(title: String, content: String, types: String, location: String, images: [String?])
    case deletePetition(petitionId: Int)
    case loadDetailPetition(petitionId: Int)
    case searchPetition(title: String)
    case loadPopularPetition
    case sortPetition(type: String, accessTypes: String)
    case votePetition(petitionId: Int)
    case reportPetition(petitionId: Int)
}

extension PetitionAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://prod-server.xquare.app/svap")!
    }
    
    var path: String {
        switch self {
            case .sendImage:
                return "/petition/image"
            case .createPetition:
                return "/petition"
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
            case .votePetition(let petitionId):
                return "/vote/\(petitionId)"
            case .reportPetition(let petitionId):
                return "/report/\(petitionId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
            case .sendImage, .createPetition, .searchPetition, .reportPetition:
                return .post
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
            case .sendImage(let images):
                var multiformData = [MultipartFormData]()
                
                for image in images {
                    multiformData.append(.init(
                        provider: .data(image),
                        name: "image",
                        fileName: "image.jpg",
                        mimeType: "image/jpg"
                    ))
                }

                return .uploadMultipart(multiformData)
            case .createPetition(let title, let content, let types, let location, let images):
                return .requestParameters(parameters: [
                    "title" : title,
                    "content" : content,
                    "types" : types,
                    "location" : location,
                    "imageUrl": images as Any
                ], encoding: JSONEncoding.default)
            case .searchPetition(let title):
                return .requestParameters(
                    parameters: [
                        "title": title
                    ], encoding: JSONEncoding.default)
            default:
                return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
            case .sendImage, .createPetition, .deletePetition, .votePetition, .reportPetition, .loadDetailPetition:
                return Header.accessToken.header()
            default:
                return Header.tokenIsEmpty.header()
        }
    }
    
    
}
