import UIKit
import SnapKit
import Then

class MainCell: UICollectionViewCell {
    let sloganLabel = UILabel().then {
        $0.text = "한 명 한 명의 소리로 더 좋은 학교 만들기"
        $0.textColor = UIColor(named: "gray-700")
        $0.font = UIFont(name: "IBMPlexSansKR-SemiBold", size: 12)
    }
    let titleLabel = UILabel().then {
        $0.text = "SVAP"
        $0.textColor = UIColor(named: "main-1")
        $0.font = UIFont(name: "IBMPlexSansKR-Bold", size: 28)
    }
    let cellImage = UIImageView(image: UIImage(named: "cellImage"))
    static let id = "CellID"
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        configureUI()
        setConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setup() {
        self.backgroundColor = UIColor(named: "main-8")
    }
    func configureUI() {
        
        [
            sloganLabel,
            titleLabel,
            cellImage
        ].forEach({ contentView.addSubview($0) })
        
    }
    func setConstraints() {
        sloganLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.left.equalToSuperview().inset(20)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(sloganLabel.snp.bottom).offset(12)
            $0.left.equalToSuperview().inset(20)
        }
        cellImage.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.right.equalToSuperview()
        }
    }
    
}
