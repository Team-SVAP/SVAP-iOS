import UIKit
import RxSwift
import RxCocoa
import RxGesture
import Moya

class ModifyPetitionViewController: BaseVC, UITextFieldDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate, UITextViewDelegate {
    
    private let disposeBag = DisposeBag()
    
    lazy var labelArray = [titleLabel, typeLabel, placeLabel, contentLabel]
    lazy var imageViewArray = [firstImageView, secondImageView, thirdImageView]
    let leftButton = UIButton(type: .system).then {
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
    private let firstImageView = UIImageView().then {
        $0.backgroundColor = .white
        $0.layer.borderColor = UIColor(named: "gray-400")?.cgColor
        $0.layer.borderWidth = 0.5
        $0.layer.cornerRadius = 8
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    private let secondImageView = UIImageView().then {
        $0.backgroundColor = .white
        $0.layer.borderColor = UIColor(named: "gray-400")?.cgColor
        $0.layer.borderWidth = 0.5
        $0.layer.cornerRadius = 8
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.isHidden = false
    }
    private let thirdImageView = UIImageView().then {
        $0.backgroundColor = .white
        $0.layer.borderColor = UIColor(named: "gray-400")?.cgColor
        $0.layer.borderWidth = 0.5
        $0.layer.cornerRadius = 8
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.isHidden =  false
    }
    private let cameraIcon = UIImageView(image: UIImage(named: "camera"))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBarSetting()
        self.navigationItem.hidesBackButton = false
        labelArray.forEach({ labelSetting($0) })
        titleTextField.delegate = self
        placeTextField.delegate = self
        contentTextView.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
            firstImageView,
            secondImageView
        ].forEach({ view.addSubview($0) })
        [petitionTypeLabel, menuButton].forEach({ typeView.addSubview($0) })
        firstImageView.addSubview(cameraIcon)
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
        firstImageView.snp.makeConstraints {
            $0.top.equalTo(imageLabel.snp.bottom).offset(8)
            $0.left.equalToSuperview().inset(20)
            $0.width.height.equalTo(70)
        }
        secondImageView.snp.makeConstraints {
            $0.top.equalTo(imageLabel.snp.bottom).offset(8)
            $0.left.equalTo(firstImageView.snp.right).offset(20)
            $0.width.height.equalTo(70)
        }
        cameraIcon.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    override func subscribe() {
        leftButton.rx.tap
            .subscribe(onNext: {
                self.popViewController()
            }).disposed(by: disposeBag)
        
        firstImageView.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: {_ in
                self.clickImageView()
            }).disposed(by: disposeBag)
        
        menuButton.rx.tap
            .subscribe(onNext: {
                self.clickMenuButton()
            }).disposed(by: disposeBag)
        
        contentTextView.rx.didChange
            .subscribe(onNext: { [self] in
                if contentTextView.textColor == UIColor(named: "gray-400") {
                    contentTextView.text = nil
                    contentTextView.textColor = UIColor(named: "gray-800")
                    contentTextView.font = UIFont(name: "IBMPlexSansKR-Medium", size: 12)
                }
                contentTextView.layer.borderColor = UIColor(named: "main-1")?.cgColor
            }).disposed(by: disposeBag)
        contentTextView.rx.didEndEditing
            .subscribe(onNext: { [self] in
                updateButtonState()
                if contentTextView.text.isEmpty {
                    contentTextView.text = "내용을 입력하세요."
                    contentTextView.textColor = UIColor(named: "gray-400")
                    contentTextView.font = UIFont(name: "IBMPlexSansKR-Regular", size: 12)
                }
                contentTextView.layer.borderColor = UIColor(named: "gray-400")?.cgColor
            }).disposed(by: disposeBag)
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
    
    @objc private func clickRightBarButton() {
        let provider = MoyaProvider<PetitionAPI>(plugins: [MoyaLoggerPlugin()])
        let array = [titleTextField.text, petitionTypeLabel.text, placeTextField.text, contentTextView.text]
        
        //content에 array넣는 법 알아내기
//        provider.request(.createPetition(content: <#[String?]#>, image: firstImageView.image?.jpegData(compressionQuality: 0.1) ?? Data())) { res in
//            switch res {
//                case .success(let result):
//                    switch result.statusCode {
//                        case 200:
//                            print("Success")
//                            self.navigationController?.popViewController(animated: true)
//                        default:
//                            print("Fail: \(result.statusCode)")
//                    }
//                case .failure(let err):
//                    print("Request Error: \(err.localizedDescription)")
//            }
//        }
    }
}

extension ModifyPetitionViewController {
    
    private func clickMenuButton() {
        let petitionClosure = UINavigationController(rootViewController: CustomMenu(closure: { [weak self] petition in
            self?.petitionTypeLabel.text = petition
            self?.updateButtonState()
        }))
        petitionClosure.modalPresentationStyle = .overFullScreen
        petitionClosure.modalTransitionStyle = .crossDissolve
        self.present(petitionClosure, animated: true)
    }
    
    func clickImageView() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        
        let sheet = UIAlertController(title: "'SVAP'이(가) 사용자의 카메라 및 앨범에 접근하려고 합니다", message: "", preferredStyle: .alert)
        
        let camera = UIAlertAction(title: "카메라", style: .default, handler: {_ in
            picker.sourceType = .camera
            self.present(picker, animated: true)
        })
        sheet.addAction(camera)
        
        let album = UIAlertAction(title: "앨범", style: .default, handler: {_ in
            picker.sourceType = .photoLibrary
            self.present(picker, animated: true)
        })
        sheet.addAction(album)
        
        let cancel = UIAlertAction(title: "허용 안 함", style: .cancel)
        sheet.addAction(cancel)
        
        self.present(sheet, animated: true)
    }
    
    func navigationBarSetting() {
        navigationItem.hidesBackButton = true
        let title = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 60))
        title.text = "수정하기"
        title.textColor = UIColor(named: "gray-800")
        title.font = UIFont(name: "IBMPlexSansKR-Medium", size: 14)
        title.textAlignment = .center
        navigationItem.titleView = title
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
            self.firstImageView.image = img
            self.cameraIcon.isHidden = true
        }
    }
    
}