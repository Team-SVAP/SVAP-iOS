import Foundation
import RxSwift
import RxCocoa

class DetailPetitionViewModel: ViewModelType {
    
    private let disposeBag = DisposeBag()
    
    struct Input {
        let id: Int
        let viewAppear: Signal<Void>
        let voteButtonTap: Signal<Void>
    }
    
    struct Output {
        let detailPetition: PublishRelay<DetailPetitionModel>
        let voteResult: PublishRelay<Bool>
    }
    
    func transform(_ input: Input) -> Output {
        let api = PetitionService()
        let detailPetition = PublishRelay<DetailPetitionModel>()
        let voteResult = PublishRelay<Bool>()
        
        input.viewAppear.asObservable()
            .flatMap {
                api.loadDetailPetition(input.id)
            }.subscribe(onNext: { data, res in
                switch res {
                    case .ok:
                        detailPetition.accept(data!)
                    default:
                        return
                }
            }).disposed(by: disposeBag)
        
        input.voteButtonTap.asObservable()
            .flatMap {
                api.votePetition(input.id)
            }.subscribe(onNext: { res in
                switch res {
                    case .ok:
                        voteResult.accept(true)
                    default:
                        voteResult.accept(false)
                }
            }).disposed(by: disposeBag)
        
        return Output(detailPetition: detailPetition, voteResult: voteResult)
    }
    
}
