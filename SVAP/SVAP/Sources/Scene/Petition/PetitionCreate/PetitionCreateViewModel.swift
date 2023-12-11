import Foundation
import UIKit
import RxSwift
import RxCocoa

class PetitionCreateViewModel: ViewModelType {
    
    private let disposeBag = DisposeBag()
    
    struct Input {
        let title: Driver<String>
        let types: String
        let location: Driver<String>
        let content: Driver<String>
        let images: [Data]
        let imageURL: [String?]
        let doneTap: Signal<Void>
        let successSignal: Signal<Void>
    }
    
    struct Output {
        let imageResult: PublishRelay<ImageModel>
        let petitionResult: PublishRelay<Bool>
    }
    
    func transform(_ input: Input) -> Output {
        
        let api = PetitionService()
        let info = Driver.combineLatest(input.title, input.location, input.content)
        let imageResult = PublishRelay<ImageModel>()
        let petitionResult = PublishRelay<Bool>()
        
        input.doneTap.asObservable()
            .flatMap { api.sendImage(input.images) }
            .subscribe(onNext: { data, res in
                switch res {
                    case .createOk:
                        imageResult.accept(data!)
                    default:
                        return
                }
            }).disposed(by: disposeBag)
        
        input.successSignal.asObservable()
            .withLatestFrom(info)
            .flatMap { title, location, content in
                api.createPetition(title, content, location, input.types, input.imageURL) }
            .subscribe(onNext: { res in
                switch res {
                    case .createOk:
                        petitionResult.accept(true)
                    default:
                        petitionResult.accept(false)
                }
            }).disposed(by: disposeBag)
        return Output(imageResult: imageResult, petitionResult: petitionResult)
    }
    
}
