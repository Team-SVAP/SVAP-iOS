import UIKit
import RxSwift
import RxCocoa
import Moya

class UserSignupViewModel: ViewModelType {
    
    private let disposeBag = DisposeBag()
    
    struct Input {
        let id: BehaviorRelay<String>
        let password: BehaviorRelay<String>
        let name: BehaviorRelay<String>
        let doneTap: BehaviorRelay<Void>
    }
    
    struct Output {
        let result: PublishRelay<Bool>
    }
    
    func transform(_ input: Input) -> Output {
        let api = AuthService()
        let info = BehaviorRelay.combineLatest(input.id, input.password, input.name)
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
