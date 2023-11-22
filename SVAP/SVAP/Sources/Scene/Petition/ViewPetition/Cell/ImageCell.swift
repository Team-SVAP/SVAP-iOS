import UIKit
import SnapKit
import Then

class ImageCell: UICollectionViewCell {
    
    static let id = "ImageCellId"
    
    let rightButton = UIButton(type: .system).then {
        $0.setImage(UIImage(named: "leftArrow"), for: .normal)
        $0.tintColor = UIColor(named: "gray-100")
    }
    let leftButton = UIButton(type: .system).then {
        $0.setImage(UIImage(named: "rightArrow"), for: .normal)
        $0.tintColor = UIColor(named: "gray-100")
    }
    let cellImageView = UIImageView().then {
        $0.backgroundColor = .black
        $0.layer.cornerRadius = 8
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.cornerRadius = 8
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        
        [
            rightButton,
            leftButton,
            cellImageView
        ].forEach({ contentView.addSubview($0) })
        
        cellImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
    }
    
}
