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
}
