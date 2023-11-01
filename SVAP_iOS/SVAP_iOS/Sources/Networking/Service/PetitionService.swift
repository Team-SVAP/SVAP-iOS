import Foundation
import RxSwift
import RxCocoa
import RxMoya
import Moya

final class PetitionService {
    
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
    
    func searchPetition(_ title: String) -> Single<([PetitionModel]?, networkingResult)> {
        return provider.rx.request(.searchPetition(title: title))
            .filterSuccessfulStatusCodes()
            .map([PetitionModel].self)
            .map{ return ($0, .ok) }
            .catch{ error in
                print(error)
                return .just((nil, .fault))
            }
    }
    
    func loadPopularPetition() -> Single<(PetitionModel?, networkingResult)> {
        return provider.rx.request(.loadPopularPetition)
            .filterSuccessfulStatusCodes()
            .map(PetitionModel.self)
            .map{ return ($0, .ok) }
            .catch{ error in
                print(error)
                return .just((nil, .fault))
            }
    }
    
    func loadRecentPetition(_ type: String) -> Single<([PetitionModel]?, networkingResult)> {
        return provider.rx.request(.loadRecentPetition(type: type))
            .filterSuccessfulStatusCodes()
            .map([PetitionModel].self)
            .map{ return ($0, .ok)}
            .catch{ error in
                print(error)
                return .just((nil, .fault))
            }
    }
    
    func loadAllRecentPetitoin()  -> Single<([PetitionModel]?, networkingResult)> {
        return provider.rx.request(.loadAllRecentPetitoin)
            .filterSuccessfulStatusCodes()
            .map([PetitionModel].self)
            .map{ return ($0, .ok) }
            .catch{ error in
                print(error)
                return .just((nil, .fault))
            }
    }
    
    func loadPetitionVote(_ type: String) -> Single<([PetitionModel]?, networkingResult)> {
        return provider.rx.request(.loadPetitionVote(type: type))
            .filterSuccessfulStatusCodes()
            .map([PetitionModel].self)
            .map{ return ($0, .ok) }
            .catch{ error in
                print(error)
                return .just((nil, .fault))
            }
    }
    
    func loadAllPetitionVote() -> Single<([PetitionModel]?, networkingResult)> {
        return provider.rx.request(.loadAllPetitionVote)
        .filterSuccessfulStatusCodes()
        .map([PetitionModel].self)
        .map{ return ($0, .ok) }
        .catch{ error in
            print(error)
            return .just((nil, .fault))
        }
    }
    
    func loadAccessPetition(_ type: String) -> Single<([PetitionModel]?, networkingResult)> {
        return provider.rx.request(.loadAccessPetition(type: type))
        .filterSuccessfulStatusCodes()
        .map([PetitionModel].self)
        .map{ return ($0, .ok) }
        .catch{ error in
            print(error)
            return .just((nil, .fault))
        }
    }
    
    func loadAllAccessPetition() -> Single<([PetitionModel]?, networkingResult)> {
        return provider.rx.request(.loadAllAccessPetition)
        .filterSuccessfulStatusCodes()
        .map([PetitionModel].self)
        .map{ return ($0, .ok) }
        .catch{ error in
            print(error)
            return .just((nil, .fault))
        }
    }
    
    func loadWaitPetition(_ type: String) -> Single<([PetitionModel]?, networkingResult)> {
        return provider.rx.request(.loadWaitPetition(type: type))
        .filterSuccessfulStatusCodes()
        .map([PetitionModel].self)
        .map{ return ($0, .ok) }
        .catch{ error in
            print(error)
            return .just((nil, .fault))
        }
    }
    
    func loadAllWaitPetition() -> Single<([PetitionModel]?, networkingResult)> {
        return provider.rx.request(.loadAllWaitPetiton)
        .filterSuccessfulStatusCodes()
        .map([PetitionModel].self)
        .map{ return ($0, .ok) }
        .catch{ error in
            print(error)
            return .just((nil, .fault))
        }
    }
    
    func setNetworkError(_ error: Error) -> networkingResult {
           print(error)
           print(error.localizedDescription)
           guard let status = (error as? MoyaError)?.response?.statusCode else { return (.fault) }
           return (networkingResult(rawValue: status) ?? .fault)
   }
    
}
