import Foundation
import UIKit
import RxSwift
import RxMoya
import Moya

final class AuthService {
//case signup(SignupInfo)
//case login(id: String, password: String)
//case loadUserInfo
//case loadUserPetition
//case idDuplication(accountId: String)
    
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
            .map{ _ -> networkingResult in return .createOk}
            .catch{[unowned self] in return .just(setNetworkError($0))}
    }
    
    func signup(_ id: String, _ password: String, _ name: String) -> Single<networkingResult> {
        return provider.rx.request(.signup(id: id, password: password, name: name))
            .filterSuccessfulStatusCodes()
            .map{ _ -> networkingResult in return .createOk }
            .catch{[unowned self] in return .just(setNetworkError($0))}
    }
    
    func idDuplication(_ id: String) -> Any {
        return provider.request(.idDuplication(accountId: id)) { res in
            switch res {
                case .success(let result):
                    switch result.statusCode {
                        case 200:
                            print("Success")
                        default:
                            print("Fail: \(result.statusCode)")
                    }
                case .failure(let err):
                    print("Request Fail: \(err.localizedDescription)")
            }
        }
    }
    
    func loadUserInfo(_ label: UILabel) {
        provider.request(.loadUserInfo) { res in
            switch res {
                case .success(let result):
                    switch result.statusCode {
                        case 200:
                            if let data = try? JSONDecoder().decode(UserInfoResponse.self, from: result.data) {
                                DispatchQueue.main.async {
                                    print("Success")
                                    label.text = data.userName
                                }
                            }
                        default:
                            print("Fail: \(result.statusCode)")
                    }
                case .failure(let err):
                    print("Request Error: \(err.localizedDescription)")
            }
        }
    }
    
    func loadUserPetition() {
        provider.request(.loadUserPetition) { res in
            switch res {
                case .success(let result):
                    switch result.statusCode {
                        case 200:
                            print("Success")
                        default:
                            print("Fail: \(result.statusCode)")
                    }
                case .failure(let err):
                    print("Request Fail: \(err.localizedDescription)")
            }
        }
    }
    
    func setNetworkError(_ error: Error) -> networkingResult {
           print(error)
           print(error.localizedDescription)
           guard let status = (error as? MoyaError)?.response?.statusCode else { return (.fault) }
           return (networkingResult(rawValue: status) ?? .fault)
   }
    
}
