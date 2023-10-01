import Foundation



struct AuthResponse: Codable {
    let petitionArray: [PetitionResponse]
}

struct PetitionResponse: Codable {
    let id: Int
    let title: String
    let dateTime: String
    let types: String
    let location: String
}
