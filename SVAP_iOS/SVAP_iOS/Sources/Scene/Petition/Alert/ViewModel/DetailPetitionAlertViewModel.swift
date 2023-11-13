import Foundation
import RxSwift
import RxCocoa

class DetailPetitionAlertViewModel: ViewModelType {
    
    private let disposeBag = DisposeBag()
    
    struct Input {
        let petitionId: Int
        let deleteTap: Signal<Void>
        let modifyTap: Signal<Void>
    }
    
    struct Output {
        let deleteResult: PublishRelay<Bool>
    }
    
    func transform(_ input: Input) -> Output {
        let api = PetitionService()
        let deleteResult = PublishRelay<Bool>()
        
        input.deleteTap.asObservable()
            .flatMap { api.deletePetition(input.petitionId) }
            .subscribe(onNext: { res in
                switch res {
                    case .deleteOk:
                        deleteResult.accept(true)
                    default:
                        deleteResult.accept(false)
                }
            }).disposed(by: disposeBag)
        return Output(deleteResult: deleteResult)
    }
    
}
