//import Foundation
//import RxSwift
//import RxCocoa
//
//class ReportPetitionAlertViewModel: ViewModelType {
//    
//    private let disposeBag = DisposeBag()
//    
//    struct Input {
//        let petitionId: Int
//        let reportTap: Signal<Void>
//    }
//    
//    struct Output {
//        let result: PublishRelay<Bool>
//    }
//    
//    func transform(_ input: Input) -> Output {
//        let api = PetitionService()
//        let result = PublishRelay<Bool>()
////        
////        input.reportTap.asObservable()
////            .flatMap { api.reportPetition(input.petitionId) }
////            .subscribe(onNext: {
////                
////            })
//    }
//    
//}
