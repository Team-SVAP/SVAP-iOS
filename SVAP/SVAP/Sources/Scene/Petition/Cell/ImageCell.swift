import UIKit
import SnapKit
import Then

class ImageCell: UICollectionViewCell {
    
    static let id = "ImageCell"
    
    let cellImageView = CustomImageView(frame: .zero)
    let imageDeleteButton = UIButton(type: .system).then {
        $0.setImage(UIImage(named: "closeIcon"), for: .normal)
        $0.tintColor = .white
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
        
        contentView.addSubview(cellImageView)
        contentView.addSubview(imageDeleteButton)
        
        cellImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        imageDeleteButton.snp.makeConstraints {
            $0.top.right.equalToSuperview().inset(4)
            $0.height.width.equalTo(17)
        }
        
    }
    
}
