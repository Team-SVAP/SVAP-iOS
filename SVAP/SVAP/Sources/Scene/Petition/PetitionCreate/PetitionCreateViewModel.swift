import Foundation
import UIKit
import RxSwift
import RxCocoa

class PetitionCreateViewModel: ViewModelType {
    
    private let disposeBag = DisposeBag()
    
    struct Input {
        let title: Driver<String>
        let types: String
//        let types: Driver<String>
        let location: Driver<String>
        let content: Driver<String>
        let images: Driver<[Data]>
        let imageURL: Driver<[String?]>
        let imageSendSignal: Signal<Void>
        let petitionCreateSignal: Signal<Void>
    }
    
    struct Output {
        let imageResult: PublishRelay<ImageModel>
        let petitionResult: PublishRelay<Bool>
    }
    
    func transform(_ input: Input) -> Output {
        
        let api = PetitionService()
        let info = Driver.combineLatest(input.title, input.location, input.content, input.imageURL)
//        let info = Driver.combineLatest(input.title, input.types, input.location, input.content, input.imageURL)
        let imageResult = PublishRelay<ImageModel>()
        let petitionResult = PublishRelay<Bool>()

        
        input.imageSendSignal.asObservable()
            .withLatestFrom(input.images)
            .flatMap { api.sendImage($0) }
            .subscribe(onNext: { data, res in
                switch res {
                    case .createOk:
                        imageResult.accept(data!)
                    default:
                        return
                }
            }).disposed(by: disposeBag)
        
        input.petitionCreateSignal.asObservable()
            .withLatestFrom(info)
//            .flatMap { title, types, location, content, imageURL in
            .flatMap { title, location, content, imageURL in
                api.createPetition(
                    title,
                    content,
                    location,
                    input.types,
                    imageURL
                ) }
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
