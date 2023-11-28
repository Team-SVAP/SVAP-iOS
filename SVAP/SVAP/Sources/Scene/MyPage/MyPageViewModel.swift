import Foundation
import RxSwift
import RxCocoa

class MyPageViewModel: ViewModelType {
    
    private let disposeBag = DisposeBag()
    
    struct Input {
        let viewAppear: Signal<Void>
    }
    struct Output {
        let userName: PublishRelay<UserInfoModel>
    }
    func transform(_ input: Input) -> Output {
        
        let api = AuthService()
        let userInfo = PublishRelay<UserInfoModel>()
        
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
        return Output(userName: userInfo)
    }
}
