import Foundation
import RxSwift
import RxCocoa
import RxMoya
import Moya

final class PetitionService {
    
    let provider = MoyaProvider<PetitionAPI>(plugins: [MoyaLoggerPlugin()])
    
    func sendImage(_ image1: Data?, _ image2: Data?, _ image3: Data?) {
        
    }
    
    func createPetition(_ title: String, _ contnet: String, _ location: String, _ types: String, _ image: [Data?]) {
        
    }
    
    func modifyPetition(_ title: String, _ contnet: String, _ location: String, _ types: String, _ petitionId: Int) {
        
    }
    
    func deletePetition(_ petitionId: Int) -> Single<networkingResult> {
        return provider.rx.request(.deletePetition(petitionId: petitionId))
            .filterSuccessfulStatusCodes()
            .map{ _ -> networkingResult in
                print("Success")
                return .deleteOk
            }
            .catch{[unowned self] in return .just(setNetworkError($0))}
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
    
    func sortPetition(_ type: String, accessTypes: String) -> Single<([PetitionModel]?, networkingResult)> {
        return provider.rx.request(.sortPetition(type: type, accessTypes: accessTypes))
            .filterSuccessfulStatusCodes()
            .map([PetitionModel].self)
            .map{ return ($0, .ok) }
            .catch{ error in
                print(error)
                return .just((nil, .fault))
            }
    }
    
    func sortAllPetition(_ accessType: String) -> Single<([PetitionModel]?, networkingResult)>  {
        return provider.rx.request(.sortAllPetition(accessType: accessType))
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
    
    func votePetition(_ petitionId: Int) -> Single<networkingResult> {
        return provider.rx.request(.votePetition(petitionId: petitionId))
            .filterSuccessfulStatusCodes()
            .map{ _ -> networkingResult in
                print("Success")
                return .ok
            }
            .catch{[unowned self] in return .just(setNetworkError($0))}
    }
    
    func reportPetition(_ petitionId: Int) -> Single<networkingResult> {
        return provider.rx.request(.reportPetition(petitionId: petitionId))
            .filterSuccessfulStatusCodes()
            .map{ _ -> networkingResult in
                print("Success")
                return .ok
            }
            .catch{[unowned self] in return .just(setNetworkError($0))}
    }
    
    func setNetworkError(_ error: Error) -> networkingResult {
           print(error)
           print(error.localizedDescription)
           guard let status = (error as? MoyaError)?.response?.statusCode else { return (.fault) }
           return (networkingResult(rawValue: status) ?? .fault)
   }
    
}
