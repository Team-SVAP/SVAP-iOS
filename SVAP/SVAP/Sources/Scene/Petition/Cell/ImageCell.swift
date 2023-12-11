import UIKit
import SnapKit
import Then

class ImageCell: UICollectionViewCell {
    
    static let id = "ImageCell"
    
    let cellImageView = CustomImageView(frame: .zero)
    
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
            cellImageView
        ].forEach({ contentView.addSubview($0) })
        
        cellImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
    }
    
}
