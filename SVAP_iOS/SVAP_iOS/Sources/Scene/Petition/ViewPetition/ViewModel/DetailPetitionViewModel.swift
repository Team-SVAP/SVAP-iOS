import Foundation
import RxSwift
import RxCocoa

class DetailPetitionViewModel: ViewModelType {
    
    private let disposeBag = DisposeBag()
    
    struct Input {
        let id: Int
        let viewAppear: Signal<Void>
    }
    
    struct Output {
        let detailPetition: PublishRelay<DetailPetitionModel>
    }
    
    func transform(_ input: Input) -> Output {
        let api = PetitionService()
        let detailPetition = PublishRelay<DetailPetitionModel>()
        
        input.viewAppear.asObservable()
            .flatMap { id in
                api.loadDetailPetition(input.id)
            }.subscribe(onNext: { data, res in
                switch res {
                    case .ok:
                        detailPetition.accept(data!)
                    default:
                        return
                }
            }).disposed(by: disposeBag)
        return Output(detailPetition: detailPetition)
    }
    
}
