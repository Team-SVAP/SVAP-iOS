import UIKit

class CreatePetitionViewController: BaseVC, UITextFieldDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate, UITextViewDelegate {
    
    lazy var arr = [titleLabel, typeLabel, placeLabel, contentLabel]
    private let leftButton = UIButton(type: .system).then {
        $0.setImage(UIImage(named: "leftArrow"), for: .normal)
        $0.tintColor = UIColor(named: "gray-700")
    }
    private let rightButton = UIButton(type: .system).then {
        $0.setTitle("완료", for: .normal)
        $0.setTitleColor(UIColor(named: "gray-600"), for: .normal)
        $0.titleLabel?.font = UIFont(name: "IBMPlexSansKR-Medium", size: 16)
    }
    let titleLabel = UILabel().then {
        $0.text = "*제목"
        $0.textColor = UIColor(named: "gray-700")
        $0.font = UIFont(name: "IBMPlexSansKR-Medium", size: 14)
    }
    private let titleTextField = SearchTextField(placeholder: "제목을 입력하세요.").then {
        $0.layer.borderColor = UIColor(named: "gray-400")?.cgColor
        $0.layer.borderWidth = 0.5
        $0.layer.cornerRadius = 8
    }
    private let typeLabel = UILabel().then {
        $0.text = "*종류"
        $0.textColor = UIColor(named: "gray-700")
        $0.font = UIFont(name: "IBMPlexSansKR-Medium", size: 14)
    }
    private let menuButton = UIButton(type: .system).then {
        $0.setImage(UIImage(named: "leftMiniArrow"), for: .normal)
        $0.tintColor = UIColor(named: "gray-700")
        $0.addTarget(self, action: #selector(clickMenuButton), for: .touchUpInside)
    }
    private let typeView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.borderColor = UIColor(named: "gray-400")?.cgColor
        $0.layer.borderWidth = 0.5
        $0.layer.cornerRadius = 8
    }
    private let petitionTypeLabel = UILabel().then {
        $0.text = nil
        $0.textColor = UIColor(named: "gray-700")
        $0.font = UIFont(name: "IBMPlexSansKR-Medium", size: 12)
    }
    private let placeLabel = UILabel().then {
        $0.text = "*위치태그"
        $0.textColor = UIColor(named: "gray-700")
        $0.font = UIFont(name: "IBMPlexSansKR-Medium", size: 14)
    }
    private let placeTextField = SearchTextField(placeholder: "").then {
        $0.layer.borderColor = UIColor(named: "gray-400")?.cgColor
        $0.layer.borderWidth = 0.5
        $0.layer.cornerRadius = 8
    }
    private let contentLabel = UILabel().then {
        $0.text = "*내용"
        $0.textColor = UIColor(named: "gray-700")
        $0.font = UIFont(name: "IBMPlexSansKR-Medium", size: 14)
    }
    private let contentTextView = CustomTextView().then {
        $0.text = "내용을 입력하세요."
        $0.textColor = UIColor(named: "gray-400")
        $0.font = UIFont(name: "IBMPlexSansKR-Regular", size: 12)
    }
    
    private let imageLabel = UILabel().then {
        $0.text = "사진"
        $0.textColor = UIColor(named: "gray-700")
        $0.font = UIFont(name: "IBMPlexSansKR-Medium", size: 14)
    }
    private let imageView = UIImageView().then {
        $0.backgroundColor = .white
        $0.layer.borderColor = UIColor(named: "gray-400")?.cgColor
        $0.layer.borderWidth = 0.5
        $0.layer.cornerRadius = 8
    }
    private let cameraIcon = UIImageView(image: UIImage(named: "camera"))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBarSetting()
        imageSetting()
        arr.forEach({ labelSetting($0) })
        titleTextField.delegate = self
        placeTextField.delegate = self
        contentTextView.delegate = self
        updateButtonState()
    }
    override func configureUI() {
        super.configureUI()
        [
            titleLabel,
            titleTextField,
            typeLabel,
            typeView,
            placeLabel,
            placeTextField,
            contentLabel,
            contentTextView,
            imageLabel,
            imageView
        ].forEach({ view.addSubview($0) })
        [petitionTypeLabel, menuButton].forEach({ typeView.addSubview($0) })
        imageView.addSubview(cameraIcon)
    }
    override func setupConstraints() {
        super.setupConstraints()
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(104)
            $0.left.equalToSuperview().inset(20)
        }
        titleTextField.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.left.right.equalToSuperview().inset(20)
            $0.height.equalTo(40)
        }
        typeLabel.snp.makeConstraints {
            $0.top.equalTo(titleTextField.snp.bottom).offset(24)
            $0.left.equalToSuperview().inset(20)
        }
        typeView.snp.makeConstraints {
            $0.top.equalTo(typeLabel.snp.bottom).offset(8)
            $0.left.equalToSuperview().inset(20)
            $0.width.equalTo(165)
            $0.height.equalTo(40)
        }
        menuButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().inset(13)
        }
        petitionTypeLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().inset(12)
        }
        placeLabel.snp.makeConstraints {
            $0.top.equalTo(titleTextField.snp.bottom).offset(24)
            $0.right.equalToSuperview().inset(126)
        }
        placeTextField.snp.makeConstraints {
            $0.top.equalTo(placeLabel.snp.bottom).offset(8)
            $0.right.equalToSuperview().inset(20)
            $0.width.equalTo(165)
            $0.height.equalTo(40)
        }
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(typeView.snp.bottom).offset(24)
            $0.left.equalToSuperview().inset(20)
        }
        contentTextView.snp.makeConstraints {
            $0.top.equalTo(contentLabel.snp.bottom).offset(8)
            $0.left.right.equalToSuperview().inset(20)
            $0.height.equalTo(220)
        }
        imageLabel.snp.makeConstraints {
            $0.top.equalTo(contentTextView.snp.bottom).offset(24)
            $0.left.equalToSuperview().inset(20)
        }
        imageView.snp.makeConstraints {
            $0.top.equalTo(imageLabel.snp.bottom).offset(8)
            $0.left.equalToSuperview().inset(20)
            $0.width.height.equalTo(70)
        }
        cameraIcon.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    @objc private func clickLeftBarButton() {
        self.navigationController?.popViewController(animated: true)
    }
    @objc private func clickRightBarButton() {
        self.navigationController?.popViewController(animated: true)
        //청원등록 서버통신
    }
    
}

extension CreatePetitionViewController {
    
    @objc func clickImageView() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.delegate = self
        self.present(picker, animated: true)
    }
    private func imageSetting() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(clickImageView))
        imageView.addGestureRecognizer(tapGesture)
        imageView.isUserInteractionEnabled = true
    }
    
    @objc private func clickMenuButton() {
        let petitionClosure = UINavigationController(rootViewController: CustomMenu(closure: { [weak self] petition in
            self?.petitionTypeLabel.text = petition
            self?.updateButtonState()
        }))
        petitionClosure.modalPresentationStyle = .overFullScreen
        petitionClosure.modalTransitionStyle = .crossDissolve
        self.present(petitionClosure, animated: true)
    }
    
    private func navigationBarSetting() {
        navigationItem.hidesBackButton = true
        let title = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 60))
        title.text = "청원하기"
        title.textColor = UIColor(named: "gray-800")
        title.font = UIFont(name: "IBMPlexSansKR-Medium", size: 14)
        title.textAlignment = .center
        navigationItem.titleView = title
        
        leftButton.addTarget(self, action: #selector(clickLeftBarButton), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftButton)
        
        rightButton.addTarget(self, action: #selector(clickRightBarButton), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    private func labelSetting(_ label: UILabel) {
        let attributedString = NSMutableAttributedString(string: label.text!)
        
        attributedString.addAttribute(.font, value: UIFont(name: "IBMPlexSansKR-Regular", size: 14)!, range: (label.text! as NSString).range(of: "*"))
        attributedString.addAttribute(.foregroundColor, value: UIColor.red, range: (label.text! as NSString).range(of:"*"))
        label.attributedText = attributedString
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true) {}
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) {
            let img = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
            self.imageView.image = img
            self.imageView.contentMode = .scaleAspectFill
            self.imageView.clipsToBounds = true
            self.cameraIcon.isHidden = true
        }
    }
    
    func updateButtonState() {
        let title = !(titleTextField.text!.isEmpty)
        let type = ((petitionTypeLabel.text?.isEmpty) != nil)
        let place = !(placeTextField.text!.isEmpty)
        let content = !(contentTextView.text.isEmpty)
        
        if title && type && place && content {
            navigationItem.rightBarButtonItem?.isEnabled = true
            rightButton.setTitleColor(UIColor(named: "main-1"), for: .normal)
        } else {
            navigationItem.rightBarButtonItem?.isEnabled = false
            rightButton.setTitleColor(UIColor(named: "gray-600"), for: .normal)
        }
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor(named: "main-1")?.cgColor
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateButtonState()
        textField.layer.borderColor = UIColor(named: "gray-400")?.cgColor
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if contentTextView.textColor == UIColor(named: "gray-400") {
            contentTextView.text = nil
            contentTextView.textColor = UIColor(named: "gray-800")
            contentTextView.font = UIFont(name: "IBMPlexSansKR-Medium", size: 12)
        }
        contentTextView.layer.borderColor = UIColor(named: "main-1")?.cgColor
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        updateButtonState()
        if contentTextView.text.isEmpty {
            contentTextView.text = "내용을 입력하세요."
            contentTextView.textColor = UIColor(named: "gray-400")
            contentTextView.font = UIFont(name: "IBMPlexSansKR-Regular", size: 12)
        }
        contentTextView.layer.borderColor = UIColor(named: "gray-400")?.cgColor
    }
    
}
