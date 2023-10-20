import Foundation

struct UserPetitionModel: Codable {
    let userPetitionList: [UserPetitionResponse]
}
struct UserPetitionResponse: Codable {
    let id: Int?
    let title: String?
    let content: String?
    let dateTime: String?
    let types: String?
    let location: String?
}

