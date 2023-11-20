import Foundation
import RxSwift
import RxCocoa

class PetitionEditViewModel: ViewModelType {
    
    private let disposeBag = DisposeBag()
    
    struct Input {
        let petitionId: Int
        let title: Driver<String>
        let types: String
        let location: Driver<String>
        let content: Driver<String>
        let doneTap: Signal<Void>
    }
    
    struct Output {
        let result: PublishRelay<Bool>
    }
    
    func transform(_ input: Input) -> Output {
        
        let api = PetitionService()
        let info = Driver.combineLatest(input.title, input.location, input.content)
        let result = PublishRelay<Bool>()
        
        input.doneTap.asObservable()
            .withLatestFrom(info)
            .flatMap { title, location, content in
                api.editPetition(title, content, location, input.types, input.petitionId)
            }
            .subscribe(onNext: { res in
                switch res {
                    case .ok:
                        result.accept(true)
                    default:
                        result.accept(false)
                }
            }).disposed(by: disposeBag)
        return Output(result: result)
    }
    
}
