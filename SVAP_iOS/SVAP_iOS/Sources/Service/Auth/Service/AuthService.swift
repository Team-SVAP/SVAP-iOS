import Foundation
import UIKit
import RxSwift
import RxMoya
import Moya

final class AuthService {
    
    let provider = MoyaProvider<AuthAPI>(plugins: [MoyaLoggerPlugin()])
    
    func login(_ id: String, _ password: String) -> Single<networkingResult> {
        return provider.rx.request(.login(id: id, password: password))
            .filterSuccessfulStatusCodes()
            .map(AuthResponse.self)
            .map{ response -> networkingResult in
                Token.accessToken = response.accessToken
                return .ok
            }
            .catch{[unowned self] in return .just(setNetworkError($0))}
    }
    
    func idDuplication(_ id: String) -> Single<networkingResult> {
        return provider.rx.request(.idDuplication(accountId: id))
            .filterSuccessfulStatusCodes()
            .map{ _ -> networkingResult in
                print("Success")
                return .ok
            }
            .catch{[unowned self] in return .just(setNetworkError($0))}
    }
    
    func signup(_ signup: SignupInfo) -> Single<networkingResult> {
        return provider.rx.request(.signup(signup))
            .filterSuccessfulStatusCodes()
            .map{ _ -> networkingResult in return .createOk }
            .catch{[unowned self] in return .just(setNetworkError($0))}
    }
    
    func loadUserInfo() -> Single<(UserInfoResponse?, networkingResult)> {
        return provider.rx.request(.loadUserInfo)
            .filterSuccessfulStatusCodes()
            .map(UserInfoResponse.self)
            .map{return ($0, .ok)}
            .catch { error in
                print(error)
                return .just((nil, .fault))
            }
    }
    
    func loadUserPetition() -> Single<(UserPetitionModel?, networkingResult)> {
        return provider.rx.request(.loadUserPetition)
            .filterSuccessfulStatusCodes()
            .map(UserPetitionModel.self)
            .map{return ($0, .ok)}
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
