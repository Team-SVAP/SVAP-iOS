import UIKit
import RxSwift
import RxCocoa
import Moya

class UserSignupViewModel: ViewModelType {
    
    private let disposeBag = DisposeBag()
    
    struct Input {
        let id: Driver<String>
        let password: Driver<String>
        let name: Driver<String>
        let doneTap: Signal<Void>
    }
    
    struct Output {
        let result: PublishRelay<Bool>
    }
    
    func transform(_ input: Input) -> Output {
        let api = AuthService()
        let info = Driver.combineLatest(input.id, input.password, input.name)
        let result = PublishRelay<Bool>()
        
        input.doneTap
            .asObservable()
            .withLatestFrom(info)
            .flatMap{ id, password, name in
                api.signup(id, password, name)
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
