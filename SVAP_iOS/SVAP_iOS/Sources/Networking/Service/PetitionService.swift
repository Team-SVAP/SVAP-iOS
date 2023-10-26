import Foundation
import RxSwift
import Moya

final class PetitionService {
    
//case createPetition(content: [String?], image: Data)
//case modifyPetition(title: String, content: String, location: String, types: String, petitionId: Int)
//case deletePetition(petitionId: Int)
//case loadDetailPetition(petitionId: Int)
//case searchPetition(title: String)
//case loadPopularPetition
//case loadRecentPetition(type: String)
//case loadAllRecentPetitoin
//case loadPetitionVote(type: Int)
//case loadAllPetitionVote
//case loadAccessPetition(type: Int)
//case loadAllAccessPetition
    let provider = MoyaProvider<PetitionAPI>(plugins: [MoyaLoggerPlugin()])
    
    func createPetition(_ content: [String?], _ image: Data) {
        
    }
    
    func modifyPetition(_ title: String, _ contnet: String, _ location: String, _ types: String, _ petitionId: Int) {
        
    }
    
    func deletePetition(_ petitionId: Int) {
        
    }
    
    func loadDetailPetition(_ petitionId: Int) -> Single<(DetailPetitionModel?, networkingResult)> {
        return provider.rx.request(.loadDetailPetition(petitionId: petitionId))
            .filterSuccessfulStatusCodes()
            .map(DetailPetitionModel.self)
            .map{ return ($0, .ok) }
            .catch{ error in
                print(error)
                return .just((nil, .fault))
            }
    }
    
    func searchPetition(_ title: String) -> Single<(PetitionResponse?, networkingResult)> {
        return provider.rx.request(.searchPetition(title: title))
            .filterSuccessfulStatusCodes()
            .map(PetitionResponse.self)
            .map{ return ($0, .ok) }
            .catch{ error in
                print(error)
                return .just((nil, .fault))
            }
    }
    
    func loadPopularPetition() -> Single<(PetitionResponse?, networkingResult)> {
        return provider.rx.request(.loadPopularPetition)
            .filterSuccessfulStatusCodes()
            .map(PetitionResponse.self)
            .map{ return ($0, .ok) }
            .catch{ error in
                print(error)
                return .just((nil, .fault))
            }
    }
    
    func loadRecentPetition(_ type: String) -> Single<(PetitionModel?, networkingResult)> {
        return provider.rx.request(.loadRecentPetition(type: type))
            .filterSuccessfulStatusCodes()
            .map(PetitionModel.self)
            .map{ return ($0, .ok)}
            .catch{ error in
                print(error)
                return .just((nil, .fault))
            }
    }
//    
//    func loadAllRecentPetitoin()  -> Single<(PetitionModel?, networkingResult)> {
//        return provider.rx.request(.loadAllRecentPetitoin)
//            .filterSuccessfulStatusCodes()
//            .map(PetitionModel.self)
//            .map{ return ($0, .ok) }
//            .catch{ error in
//                print(error)
//                return .just((nil, .fault))
//            }
//    }
//    
//    func loadPetitionVote(_ type: String) -> Single<(PetitionModel?, networkingResult)> {
//        return provider.rx.request(.loadPetitionVote(type: type))
//            .filterSuccessfulStatusCodes()
//            .map(PetitionModel.self)
//            .map{ return ($0, .ok) }
//            .catch{ error in
//                print(error)
//                return .just((nil, .fault))
//            }
//    }
//    
//    func loadAllPetitionVote() -> Single<(PetitionModel?, networkingResult)> {
//        return provider.rx.request(.loadAllPetitionVote)
//        .filterSuccessfulStatusCodes()
//        .map(PetitionModel.self)
//        .map{ return ($0, .ok) }
//        .catch{ error in
//            print(error)
//            return .just((nil, .fault))
//        }
//    }
//    
//    func loadAccessPetition(_ type: String) -> Single<(PetitionModel?, networkingResult)> {
//        return provider.rx.request(.loadAccessPetition(type: type))
//        .filterSuccessfulStatusCodes()
//        .map(PetitionModel.self)
//        .map{ return ($0, .ok) }
//        .catch{ error in
//            print(error)
//            return .just((nil, .fault))
//        }
//    }
//    
//    func loadAllAccessPetition() -> Single<(PetitionModel?, networkingResult)> {
//        return provider.rx.request(.loadAllAccessPetition)
//        .filterSuccessfulStatusCodes()
//        .map(PetitionModel.self)
//        .map{ return ($0, .ok) }
//        .catch{ error in
//            print(error)
//            return .just((nil, .fault))
//        }
//    }
//    
//    func loadWaitPetition(_ type: String) -> Single<(PetitionModel?, networkingResult)> {
//        return provider.rx.request(.loadWaitPetition(type: type))
//        .filterSuccessfulStatusCodes()
//        .map(PetitionModel.self)
//        .map{ return ($0, .ok) }
//        .catch{ error in
//            print(error)
//            return .just((nil, .fault))
//        }
//    }
//    
//    func loadAllWaitPetition() -> Single<(PetitionModel?, networkingResult)> {
//        return provider.rx.request(.loadAllWaitPetiton)
//        .filterSuccessfulStatusCodes()
//        .map(PetitionModel.self)
//        .map{ return ($0, .ok) }
//        .catch{ error in
//            print(error)
//            return .just((nil, .fault))
//        }
//    }
    
    func setNetworkError(_ error: Error) -> networkingResult {
           print(error)
           print(error.localizedDescription)
           guard let status = (error as? MoyaError)?.response?.statusCode else { return (.fault) }
           return (networkingResult(rawValue: status) ?? .fault)
   }
    
}
