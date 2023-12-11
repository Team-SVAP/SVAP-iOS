import Foundation

class UserIdData {
    static let shared = UserIdData()
    
    var userId: String?
    
    private init() { }
}
