import Foundation
import RxSwift
import RxCocoa

class PetitionViewModel: ViewModelType {
    
    private let disposeBag = DisposeBag()
    
    struct Input {
        
        //MARK: 청원 검색
        let petitonTitle: Driver<String>
        let doneTap: Signal<Void>
        
        //MARK: 최신순으로 보기
        let allRecentPetition: Signal<Void>
        let schoolRecentPetiton: Signal<Void>
        let dormRecentPetition: Signal<Void>
        //MARK: 투표순으로 보기
        
        let allVotePetition: Signal<Void>
        let schoolVotePetition: Signal<Void>
        let dormVotePetition: Signal<Void>
        
        //MARK: 승인된 청원 보기
        let allAccessPetition: Signal<Void>
        let schoolAccessPetition: Signal<Void>
        let dormAccessPetition: Signal<Void>
        
        //MARK: 검토중인 청원 보기
        let allWaitPetition: Signal<Void>
        let schoolWaitPetition: Signal<Void>
        let dormWaitPetition: Signal<Void>
        
    }
    
    struct Output {
        let petition: BehaviorRelay<[PetitionModel]>
    }
    
    func transform(_ input: Input) -> Output {
        let api = PetitionService()
        let petition = BehaviorRelay<[PetitionModel]>(value: [])
        
        //MARK: 청원 검색
        input.doneTap.asObservable()
            .withLatestFrom(input.petitonTitle)
            .flatMap { data in
                api.searchPetition(data)
            }
            .subscribe(onNext: { data, res in
                switch res {
                    case .ok:
                        petition.accept(data!)
                    default:
                        return
                }
            }).disposed(by: disposeBag)
        
        //MARK: 최신순으로 보기
        input.allRecentPetition.asObservable()
            .flatMap { api.loadAllRecentPetitoin() }
            .subscribe(onNext: { data, res in
                switch res {
                    case .ok:
                        petition.accept(data!)
                    default:
                        return
                }
            }).disposed(by: disposeBag)
        
        input.schoolRecentPetiton.asObservable()
            .flatMap { api.loadRecentPetition("SCHOOL") }
            .subscribe(onNext: { data, res in
                switch res {
                    case .ok:
                        petition.accept(data!)
                    default:
                        return
                }
            }).disposed(by: disposeBag)
        
        input.dormRecentPetition.asObservable()
            .flatMap { api.loadRecentPetition("DORMITORY") }
            .subscribe(onNext: { data, res in
                switch res {
                    case .ok:
                        petition.accept(data!)
                    default:
                        return
                }
            }).disposed(by: disposeBag)
        
        //MARK: 승인된 청원 보기
        input.allAccessPetition.asObservable()
            .flatMap { api.loadAllAccessPetition() }
            .subscribe(onNext: { data, res in
                switch res {
                    case .ok:
                        petition.accept(data!)
                    default:
                        return
                }
            }).disposed(by: disposeBag)
        
        input.schoolAccessPetition.asObservable()
            .flatMap{ api.loadAccessPetition("SCHOOL")}
            .subscribe(onNext: { data, res in
                switch res {
                    case .ok:
                        petition.accept(data!)
                    default:
                        return
                }
            }).disposed(by: disposeBag)
        
        input.dormAccessPetition.asObservable()
            .flatMap{ api.loadAccessPetition("DORMITORY") }
            .subscribe(onNext: { data, res in
                switch res {
                    case .ok:
                        petition.accept(data!)
                    default:
                        return
                }
            }).disposed(by: disposeBag)
        
        //MARK: 투표순으로 보기
        input.allVotePetition.asObservable()
            .flatMap{ api.loadAllPetitionVote() }
            .subscribe(onNext: { data, res in
                switch res {
                    case .ok:
                        petition.accept(data!)
                    default:
                        return
                }
            }).disposed(by: disposeBag)
        input.schoolVotePetition.asObservable()
            .flatMap{ api.loadPetitionVote("SCHOOL") }
            .subscribe(onNext: { data, res in
                switch res {
                    case .ok:
                        petition.accept(data!)
                    default:
                        return
                }
            }).disposed(by: disposeBag)
        input.dormVotePetition.asObservable()
            .flatMap{ api.loadPetitionVote("DORMITORY") }
            .subscribe(onNext: { data, res in
                switch res {
                    case .ok:
                        petition.accept(data!)
                    default:
                        return
                }
            }).disposed(by: disposeBag)
        
        //MARK: 검토중인 청원 보기
        input.allWaitPetition.asObservable()
            .flatMap{ api.loadAllWaitPetition() }
            .subscribe(onNext: { data, res in
                switch res {
                    case .ok:
                        petition.accept(data!)
                    default:
                        return
                }
            }).disposed(by: disposeBag)
        input.schoolWaitPetition.asObservable()
            .flatMap{ api.loadWaitPetition("SCHOOL") }
            .subscribe(onNext: { data, res in
                switch res {
                    case .ok:
                        petition.accept(data!)
                    default:
                        return
                }
            }).disposed(by: disposeBag)
        input.dormWaitPetition.asObservable()
            .flatMap{ api.loadWaitPetition("DORMITORY") }
            .subscribe(onNext: { data, res in
                switch res {
                    case .ok:
                        petition.accept(data!)
                    default:
                        return
                }
            }).disposed(by: disposeBag)
        
        return Output(
            petition: petition
        )
    }
}
