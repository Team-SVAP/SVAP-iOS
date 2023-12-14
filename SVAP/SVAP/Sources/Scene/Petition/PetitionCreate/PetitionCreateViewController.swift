import UIKit
import RxSwift
import RxCocoa
import RxGesture
import BSImagePicker
import Photos

class PetitionCreateViewController: BaseVC {
    
    private let disposeBag = DisposeBag()
    private let viewModel = PetitionCreateViewModel()
    private let imageSendSignal = PublishRelay<Void>()
    private let petitionCreateSignal = PublishRelay<Void>()
    
    var selectedAssets: [PHAsset] = []
    
    var image: [UIImage] = []
    
    var dataImage = BehaviorRelay<[Data]>(value: [])
    var imageArray =  BehaviorRelay<[String?]>(value: [])
    
    lazy var labelArray = [titleLabel, typeLabel, placeLabel, contentLabel]

    var types: String = "SCHOOL"
    
    private let navigationTitleLabel = UILabel().then {
        $0.text = "청원작성"
        $0.textColor = UIColor(named: "gray-800")
        $0.font = UIFont(name: "IBMPlexSansKR-Medium", size: 14)
    }
    private let rightButton = UIButton(type: .system).then {
        $0.setTitle("완료", for: .normal)
        $0.setTitleColor(UIColor(named: "gray-600"), for: .normal)
        $0.titleLabel?.font = UIFont(name: "IBMPlexSansKR-Medium", size: 16)
    }
    private let titleLabel = UILabel().then {
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
    private let textCountLabel = UILabel().then {
        $0.text = "0자"
        $0.textColor = UIColor(named: "gray-700")
        $0.font = UIFont(name: "IBMPlexSansKR-Medium", size: 10)
    }
    private let imageLabel = UILabel().then {
        $0.text = "사진"
        $0.textColor = UIColor(named: "gray-700")
        $0.font = UIFont(name: "IBMPlexSansKR-Medium", size: 14)
    }
    private let mainImageView = CustomImageView(frame: .zero).then {
        $0.layer.borderWidth = 0
        $0.backgroundColor = UIColor(named: "gray-100")
    }
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.layer.cornerRadius = 8
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: "ImageCell")
        return collectionView
    }()
    private let cameraIcon = UIImageView(image: UIImage(named: "camera"))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        labelArray.forEach({ labelSetting($0) })
        collectionView.delegate = self
        collectionView.dataSource = self
        navigationBarSetting()
    }
    
    override func configureUI() {
        super.configureUI()
        
        [
            navigationTitleLabel,
            rightButton,
            titleLabel,
            titleTextField,
            typeLabel,
            typeView,
            placeLabel,
            placeTextField,
            contentLabel,
            contentTextView,
            imageLabel,
            mainImageView,
            collectionView
        ].forEach({ view.addSubview($0) })
        
        [petitionTypeLabel, menuButton].forEach({ typeView.addSubview($0) })
        
        contentTextView.addSubview(textCountLabel)
        
        mainImageView.addSubview(cameraIcon)
    }
    override func setupConstraints() {
        super.setupConstraints()
        
        navigationTitleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(80)
        }
        rightButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(80)
            $0.right.equalToSuperview().inset(20)
        }
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
        textCountLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(198)
            $0.left.equalToSuperview().inset(12)
        }
        imageLabel.snp.makeConstraints {
            $0.top.equalTo(contentTextView.snp.bottom).offset(24)
            $0.left.equalToSuperview().inset(20)
        }
        mainImageView.snp.makeConstraints {
            $0.top.equalTo(imageLabel.snp.bottom).offset(8)
            $0.left.equalToSuperview().inset(20)
            $0.width.height.equalTo(70)
        }
        collectionView.snp.makeConstraints {
            $0.top.equalTo(imageLabel.snp.bottom).offset(8)
            $0.left.equalTo(mainImageView.snp.right).offset(20)
            $0.right.equalToSuperview().inset(20)
            $0.height.equalTo(70)
        }
        cameraIcon.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
    }
    override func bind() {
        super.bind()
        
        //type을 보내는 것만 해결하면 됨 물론 이미지도
        let input = PetitionCreateViewModel.Input(
            title: titleTextField.rx.text.orEmpty.asDriver(),
            types: types,
            location: placeTextField.rx.text.orEmpty.asDriver(),
            content: contentTextView.rx.text.orEmpty.asDriver(),
            images: dataImage.asDriver(),
            imageURL: imageArray.asDriver(),
            imageSendSignal: imageSendSignal.asSignal(),
            petitionCreateSignal: petitionCreateSignal.asSignal()
        )
        
        let output = viewModel.transform(input)
        
        rightButton.rx.tap
            .subscribe(onNext: {
                if self.image.isEmpty == true {
                    self.petitionCreateSignal.accept(())
                } else {
                    self.imageSendSignal.accept(())
                }
            }).disposed(by: disposeBag)
        
        output.imageResult.asObservable()
            .subscribe(onNext: { data in
                self.imageArray.accept(data.imageUrl)
                self.petitionCreateSignal.accept(())
            }).disposed(by: self.disposeBag)
        
        output.petitionResult.asObservable()
            .subscribe(onNext: { bool in
                if bool {
                    print("청원 성공")
                    self.titleTextField.text = nil
                    self.placeTextField.text = nil
                    self.contentTextView.text = nil
                    self.image.removeAll()
                    self.dataImage.accept([])
                    self.imageArray.accept([])
                    self.collectionView.reloadData()
                } else {
                    print("청원 실패")
                }
            }).disposed(by: disposeBag)
        
    }
    override func subscribe() {
        super.subscribe()
        
        mainImageView.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: {_ in
                self.clickImageView()
            }).disposed(by: disposeBag)
        
        menuButton.rx.tap
            .subscribe(onNext: {
                self.clickMenuButton()
                if self.petitionTypeLabel.text == "기숙사 청원" {
                    self.types = "DORMITORY"
                } else {
                    self.types = "SCHOOL"
                }
            }).disposed(by: disposeBag)
        
        titleTextField.rx.text.orEmpty
            .subscribe(onNext: {
                if $0.isEmpty {
                    self.titleTextField.layer.borderColor(UIColor(named: "gray-400")!)
                } else {
                    self.titleTextField.layer.borderColor(UIColor(named: "main-1")!)
                }
            }).disposed(by: disposeBag)
        
        placeTextField.rx.text.orEmpty
            .subscribe(onNext: {
                if $0.isEmpty {
                    self.placeTextField.layer.borderColor(UIColor(named: "gray-400")!)
                } else {
                    self.placeTextField.layer.borderColor(UIColor(named: "main-1")!)
                }
            }).disposed(by: disposeBag)
        
        contentTextView.rx.didBeginEditing
            .subscribe(onNext: { [self] in
                if contentTextView.textColor == UIColor(named: "gray-400") {
                    contentTextView.text = nil
                    contentTextView.textColor = UIColor(named: "gray-800")
                    contentTextView.font = UIFont(name: "IBMPlexSansKR-Medium", size: 12)
                }
                contentTextView.layer.borderColor = UIColor(named: "main-1")?.cgColor
                
                self.contentTextView.rx.text.orEmpty
                    .subscribe(onNext: { text in
                        if self.contentTextView.textColor == UIColor(named: "gray-400") {
                            self.textCountLabel.text = "0자"
                        } else {
                            self.textCountLabel.text = "\(text.count)자"
                        }
                    }).disposed(by: self.disposeBag)
                
            }).disposed(by: disposeBag)
        contentTextView.rx.didEndEditing
            .subscribe(onNext: { [self] in
                if contentTextView.text.isEmpty {
                    contentTextView.text = "내용을 입력하세요."
                    contentTextView.textColor = UIColor(named: "gray-400")
                    contentTextView.font = UIFont(name: "IBMPlexSansKR-Regular", size: 12)
                }
                if contentTextView.textColor == UIColor(named: "gray-400") {
                    contentTextView.layer.borderColor = UIColor(named: "gray-400")?.cgColor
                } else {
                    contentTextView.layer.borderColor = UIColor(named: "main-1")?.cgColor
                }
            }).disposed(by: disposeBag)
        
        let text = Observable.combineLatest(titleTextField.rx.text, contentTextView.rx.text, placeTextField.rx.text)
        text.subscribe(onNext: {
            if ($0!.count != 0 && $1!.count != 0 && $2!.count != 0) {
                self.rightButton.isEnabled = true
                self.rightButton.setTitleColor(UIColor(named: "main-1"), for: .normal)
            } else {
                self.rightButton.isEnabled = false
                self.rightButton.setTitleColor(UIColor(named: "gray-600"), for: .normal)
            }
        }).disposed(by: disposeBag)
        
    }
    
}

extension PetitionCreateViewController {
    
    private func clickMenuButton() {
        let petitionClosure = CustomMenu(closure: { [weak self] petition in
            self?.petitionTypeLabel.text = petition
            self?.typeView.layer.borderColor = UIColor(named: "main-1")?.cgColor
        })
        petitionClosure.modalPresentationStyle = .overFullScreen
        petitionClosure.modalTransitionStyle = .crossDissolve
        self.present(petitionClosure, animated: true)
    }
    
    func clickImageView() {
        let imagePicker = ImagePickerController()
        imagePicker.modalPresentationStyle = .fullScreen
        imagePicker.settings.selection.max = 2
        imagePicker.settings.theme.selectionStyle = .numbered
        imagePicker.settings.fetch.assets.supportedMediaTypes = [.image]
        imagePicker.settings.theme.selectionFillColor = .systemBlue
        imagePicker.doneButton.tintColor = .systemBlue
        imagePicker.doneButtonTitle = "선택완료"
        imagePicker.cancelButton.tintColor = .systemRed
        
        presentImagePicker(imagePicker, select: {
            (asset) in
            // 사진 하나 선택할 때마다 실행되는 내용 쓰기
        }, deselect: {
            (asset) in
            // 선택했던 사진들 중 하나를 선택 해제할 때마다 실행되는 내용 쓰기
        }, cancel: {
            (assets) in
            // Cancel 버튼 누르면 실행되는 내용
        }, finish: {
            (assets) in
            // Done 버튼 누르면 실행되는 내용
            
            self.selectedAssets.removeAll()
            self.image.removeAll()
            self.dataImage.accept([])
            
            for i in assets {
                self.selectedAssets.append(i)
            }
            
            self.convertAssetToImages()
            
        })
    }
    
    
    func convertAssetToImages() {
        
        if selectedAssets.count != 0 {
            
            var imageArr: [Data] = []
            
            for i in 0..<selectedAssets.count {
                
                let imageManager = PHImageManager.default()
                let option = PHImageRequestOptions()
                option.isSynchronous = true
                var thumbnail = UIImage()
                
                imageManager.requestImage(for: selectedAssets[i],
                                          targetSize: CGSize(width: 200, height: 200),
                                          contentMode: .aspectFit,
                                          options: option) { (result, info) in
                    thumbnail = result!
                }
                
                
                let data = thumbnail.jpegData(compressionQuality: 0.7)
                let newImage = UIImage(data: data!)
                
                imageArr.append(data ?? Data())
                
                self.image.append(newImage! as UIImage)
                collectionView.reloadData()
            }
            
            dataImage.accept(imageArr)
        }
    }
    
    private func labelSetting(_ label: UILabel) {
        let attributedString = NSMutableAttributedString(string: label.text!)
        
        attributedString.addAttribute(.font, value: UIFont(name: "IBMPlexSansKR-Regular", size: 14)!, range: (label.text! as NSString).range(of: "*"))
        attributedString.addAttribute(.foregroundColor, value: UIColor.red, range: (label.text! as NSString).range(of:"*"))
        label.attributedText = attributedString
    }
    
    private func navigationBarSetting() {
        self.navigationController?.isNavigationBarHidden = true
        navigationItem.titleView = navigationTitleLabel
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
    }
    
}

extension PetitionCreateViewController:  UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return image.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
        cell.cellImageView.image = image[indexPath.row]
        
        cell.imageDeleteButton.rx.tap
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] in
                guard let indexPath = collectionView.indexPath(for: cell) else {
                    return
                }
                guard indexPath.row < self.image.count else {
                    return
                }
                
                self.image.remove(at: indexPath.row)
                
                var currentImages = dataImage.value
                currentImages.remove(at: indexPath.row)
                dataImage.accept(currentImages)
                
                collectionView.reloadData()
            }).disposed(by: disposeBag)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 70, height: collectionView.frame.height)
    }
}
