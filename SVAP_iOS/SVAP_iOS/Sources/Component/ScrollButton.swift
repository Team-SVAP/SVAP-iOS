import UIKit

class ScrollButton: UIButton {
    
    private func setup() {
        self.setImage(UIImage(named: "upArrow"), for: .normal)
        self.backgroundColor = UIColor(named: "main-3")
        self.tintColor = .white
        self.layer.cornerRadius = 30
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
