import Foundation

struct DetailPetitionModel: Codable {
    let id: Int
    let title: String
    let content: String
    let voteCounts: Int
    let accessTypes: String
    //승인 여부
    let types: String
    let location: String
    let viewCounts: Int
    let accountId: String
    let dateTime: String
    let imgUrl: [String]?
}
