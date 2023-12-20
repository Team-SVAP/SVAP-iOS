import Foundation
import RxSwift
import RxCocoa

class UserPetitionViewModel: ViewModelType {
    
    private let disposeBag = DisposeBag()
    
    struct Input {
        let viewAppear: Signal<Void>
    }
    
    struct Output {
        let userPetition: BehaviorRelay<[PetitionModel]>
    }
    
    func transform(_ input: Input) -> Output {
        let api = AuthService()
        let userPetition = BehaviorRelay<[PetitionModel]>(value: [])
        
        input.viewAppear.asObservable()
            .flatMap{ api.loadUserPetition() }
            .subscribe(onNext: { data, res in
                switch res {
                    case .ok:
                        userPetition.accept(data!)
                    default:
                        return
                }
            }).disposed(by: disposeBag)
        return Output(userPetition: userPetition)
    }
}
