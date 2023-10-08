import Foundation



struct AuthResponse: Codable {
    let accessToken: String?
    let refreshToken: String?
    let role: String?
    let userName: String?
}


