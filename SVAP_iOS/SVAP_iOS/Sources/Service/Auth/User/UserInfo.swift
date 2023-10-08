import Foundation

class UserInfo {
    
    static let shared = UserInfo()
    
    var userName: String?
    var accountId: String?
    var password: String?
    
    private init() { }
}
