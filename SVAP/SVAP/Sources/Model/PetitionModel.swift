import Foundation

struct PetitionModel: Codable {
    let id: Int
    let title: String
    let content: String
    let dateTime: String
    let types: String
    let location: String
}
