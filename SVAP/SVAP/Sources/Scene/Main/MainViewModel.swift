import Foundation
import RxSwift
import RxCocoa

class MainViewModel: ViewModelType {
    
    private let disposeBag = DisposeBag()
    
    struct Input {
        let viewAppear: Signal<Void>
        let refreshToken: Signal<Void>
    }
    
    struct Output {
        let popularPetition: PublishRelay<PetitionModel>
        let result: PublishRelay<Bool>
    }
    
    func transform(_ input: Input) -> Output {
        let petitionAPI = PetitionService()
        let authAPI = AuthService()
        let popularPetition = PublishRelay<PetitionModel>()
        let result = PublishRelay<Bool>()
        
        input.viewAppear.asObservable()
            .flatMap{ petitionAPI.loadPopularPetition() }
            .subscribe(onNext: { data, res in
                switch res {
                    case .ok:
                        popularPetition.accept(data!)
                    default:
                        return
                }
            }).disposed(by: disposeBag)
        
        input.refreshToken.asObservable()
            .flatMap {
                authAPI.refreshToken()
            }.subscribe(onNext: { res in
                switch res {
                    case .ok:
                        result.accept(true)
                    default:
                        result.accept(false)
                }
            }).disposed(by: disposeBag)
        return Output(popularPetition: popularPetition, result: result)
    }
}
