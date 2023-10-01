import Foundation
import SwiftKeychainWrapper

//리프레시 토큰 로직 혼자 짜보자 ㅅㅂ
struct Token {
    static var localAccessToken: String?
//    static var refrash: String? {
//
//    }
    static var accessToken: String? {
        get {
            localAccessToken = KeychainWrapper.standard.string(forKey: "acccess-token")
            //오류터지면 언더바로 바꾸자...
            return localAccessToken
        }
        set(newToken) {
            KeychainWrapper.standard.set(newToken ?? "nil", forKey: "acccess-token")
            localAccessToken = newToken
        }
    }
    static func removeToken() {
        self.accessToken = nil
    }
}

enum Header {
    case refrashToken, accessToken, tokenIsEmpty
    func header() -> [String: String]? {
        guard let token = Token.accessToken,
              token != "nil" else {
            return ["Content-Type": "application/json"]
        }
        switch self {
            case .refrashToken:
                return ["Authorization": "Bearer " + token, "Content-Type": "application/json"]
            case .accessToken:
                return ["Authorization": "Bearer " + token, "Content-Type": "application/json"]
            case .tokenIsEmpty:
                return ["Content-Type": "application/json"]
        }
    }
}
