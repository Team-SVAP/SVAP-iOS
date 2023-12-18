import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class ApprovedCell: UICollectionViewCell {
    
    private let disposeBag = DisposeBag()
    
    static let id = "ApprovedCell"
    
    let cellImage = UIImageView(image: UIImage(named: "approvedCell"))
    let moveButton = UIButton(type: .system).then {
        $0.setTitle("바로가기", for: .normal)
        $0.setImage(UIImage(named: "rightArrow"), for: .normal)
        $0.titleLabel?.font = UIFont(name: "IBMPlexSansKR-SemiBold", size: 16)
        $0.setTitleColor(UIColor(named: "gray-700"), for: .normal)
        $0.semanticContentAttribute = .forceRightToLeft
        $0.tintColor = UIColor(named: "gray-700")
    }
 
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        [
            cellImage,
            moveButton
        ].forEach({ contentView.addSubview($0) })
        cellImage.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        moveButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(77)
            $0.left.equalToSuperview().inset(52)
        }
    }
    
}
