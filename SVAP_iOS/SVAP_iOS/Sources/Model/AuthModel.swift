import Foundation

struct AuthModel: Codable {
    let accessToken: String?
    let refreshToken: String?
    let role: String?
    let userName: String?
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case role, userName
    }
}


