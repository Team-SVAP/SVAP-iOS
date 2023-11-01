import Foundation
import RxSwift
import RxCocoa

class PetitionViewModel: ViewModelType {
    
    private let disposeBag = DisposeBag()
    
    struct Input {
        let viewAppear: Signal<Void>
    }
    
    struct Output {
        let petition: BehaviorRelay<[PetitionModel]>
    }
    
    func transform(_ input: Input) -> Output {
        let api = PetitionService()
        let petition = BehaviorRelay<[PetitionModel]>(value: [])

        input.viewAppear.asObservable()
            .flatMap { api.loadAllRecentPetitoin() }
            .subscribe(onNext: { data, res in
                switch res {
                    case .ok:
                        petition.accept(data!)
                    default:
                        return
                }
            }).disposed(by: disposeBag)
        
        return Output(petition: petition)
    }
}
