import Foundation
import Moya

enum PetitionAPI {
    case createPetition(title: String, content: String, types: String, location: String, image: Data)
}

extension PetitionAPI: TargetType {
    var baseURL: URL {
//        return URL(string: <#T##String#>)
    }
    
    var path: String {
        switch self {
            case .createPetition:
                return "/petition"
        }
    }
    
    var method: Moya.Method {
        switch self {
            case .createPetition:
                return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
            case .createPetition(let title, let content, let types, let location, let image):
                var multipart: [MultipartFormData] = []
                multipart.append(
                    .init(
                        provider: .data(image),
                        name: "image",
                        fileName: "image.jpg",
                        mimeType: "image.jpg"
                    )
                )
        }
    }
    
    var headers: [String : String]? {
        switch self {
            default:
                return Header.tokenIsEmpty.header()
        }
    }
    
    
}
