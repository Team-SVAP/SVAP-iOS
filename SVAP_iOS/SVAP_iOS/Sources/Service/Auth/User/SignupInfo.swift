import Foundation
import RxSwift
import RxCocoa

class SignupInfo {
    
    static let shared = SignupInfo()
    
    var userName: PublishRelay<String>?
    var accountId: PublishRelay<String>?
    var password: PublishRelay<String>?
    
    private init() { }
}
