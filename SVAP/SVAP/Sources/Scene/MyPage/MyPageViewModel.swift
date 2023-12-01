import Foundation
import RxSwift
import RxCocoa

class MyPageViewModel: ViewModelType {
    
    private let disposeBag = DisposeBag()
    
    struct Input {
        let viewAppear: Signal<Void>
        let deleteTap: Signal<Void>
    }
    struct Output {
        let userName: PublishRelay<UserInfoModel>
        let deleteResult: PublishRelay<Bool>
    }
    func transform(_ input: Input) -> Output {
        
        let api = AuthService()
        let userInfo = PublishRelay<UserInfoModel>()
        let deleteResult = PublishRelay<Bool>()
        
        input.viewAppear.asObservable()
            .flatMap{ api.loadUserInfo() }
            .subscribe(onNext: { data, res in
                switch res {
                    case .ok:
                        userInfo.accept(data!)
                    case .expiredToken:
                        print("fdjksl")
                    default:
                        return
                }
            }).disposed(by: disposeBag)
        
        input.deleteTap.asObservable()
            .flatMap { api.userWithdrawal() }
            .subscribe(onNext: { res in
                switch res {
                    case .ok:
                        deleteResult.accept(true)
                    default:
                        deleteResult.accept(false)
                }
            }).disposed(by: disposeBag)
        
        return Output(userName: userInfo, deleteResult: deleteResult)
    }
}
