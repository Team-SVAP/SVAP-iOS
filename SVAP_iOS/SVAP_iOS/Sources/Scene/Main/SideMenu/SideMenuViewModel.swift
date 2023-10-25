import Foundation
import RxSwift
import RxCocoa

class SideMenuViewModel {
    
    private let disposeBag = DisposeBag()
    
    struct Input {
        let viewAppear: Signal<Void>
    }
    struct Output {
        let userName: PublishRelay<UserInfoResponse>
    }
    func transform(_ input: Input) -> Output {
        
        let api = AuthService()
        let userInfo = PublishRelay<UserInfoResponse>()
        
        input.viewAppear.asObservable()
            .flatMap { api.loadUserInfo() }
            .subscribe(onNext: { data, res in
                switch res {
                    case .ok:
                        userInfo.accept(data!)
                    default:
                        return
                }
            }).disposed(by: disposeBag)
        return Output(userName: userInfo)
    }
}
