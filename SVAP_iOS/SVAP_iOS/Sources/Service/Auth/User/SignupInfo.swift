import Foundation
import RxSwift
import RxCocoa

class SignupInfo {
    
    static let shared = SignupInfo()
    
    var userName: Driver<String>?
    var accountId: Driver<String>?
    var password: Driver<String>?
    
    private init() { }
}
