import UIKit
import RxSwift
import RxCocoa
import Moya

class UserSignupViewModel: ViewModelType {
    
    private let disposeBag = DisposeBag()
    
    struct Input {
//        let id: PublishRelay<String>
//        let password: PublishRelay<String>
//        let name: PublishRelay<String>
        let signup: SignupInfo
        let doneTap: Signal<Void>
    }
    
    struct Output {
        let result: PublishRelay<Bool>
    }
    
    func transform(_ input: Input) -> Output {
        let api = AuthService()
        let result = PublishRelay<Bool>()
        
        input.doneTap
            .asObservable()
            .flatMap{
                api.signup(input.signup)
            }.subscribe(onNext: { res in
                switch res {
                    case .createOk:
                        result .accept(true)
                    default:
                        result .accept(false)
                }
            }).disposed(by: disposeBag)
        return Output(result: result)
    }
    
}
