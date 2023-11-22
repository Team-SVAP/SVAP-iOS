import Foundation
import RxSwift
import RxCocoa

class MainViewModel: ViewModelType {
    
    private let disposeBag = DisposeBag()
    
    struct Input {
        let viewAppear: Signal<Void>
    }
    
    struct Output {
        let popularPetition: PublishRelay<PetitionModel>
    }
    
    func transform(_ input: Input) -> Output {
        let api = PetitionService()
        let popularPetition = PublishRelay<PetitionModel>()
        
        input.viewAppear.asObservable()
            .flatMap{ api.loadPopularPetition() }
            .subscribe(onNext: { data, res in
                switch res {
                    case .ok:
                        popularPetition.accept(data!)
                    default:
                        return
                }
            }).disposed(by: disposeBag)
        return Output(popularPetition: popularPetition)
    }
}
