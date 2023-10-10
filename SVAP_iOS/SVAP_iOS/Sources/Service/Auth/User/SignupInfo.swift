import Foundation

class SignupInfo {
    
    static let shared = SignupInfo()
    
    var userName: String?
    var accountId: String?
    var password: String?
    
    private init() { }
}
