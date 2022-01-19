//
//  WriteViewController.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/01/11.
//

import UIKit
import SnapKit
import PhotosUI

final class WriteViewController: UIViewController {
    
    // MARK: Properties
    private let communityType: CommunityType
    
    private var selectedImages = [UIImage]() {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.collectionView.reloadData()
                self.imageInputView.hasImage = !self.selectedImages.isEmpty
            }
        }
    }
    
    private var numberOfImages = 0
    
    private let categoryList: [String] = ["소음", "예약", "냉장고", "세탁실", "수질", "와이파이", "전기", "기타"]
    
    private let reuseIdentifier = "WriteImageCell"
    
    private let scrollView = UIScrollView()
    private let contentsView = UIView()
    
    private lazy var imageInputView: ImageInputAccessoryView = {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50.0)
        let imageInputAccesoryView = ImageInputAccessoryView(frame: frame)
        imageInputAccesoryView.delegate = self
        return imageInputAccesoryView
    }()
    
    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17.0, weight: .medium)
        label.textColor = .black
        label.text = "제목"
        return label
    }()
    
    private lazy var titleInputTextField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: "제목을 입력해주세요.",
                                                             attributes: [.font: UIFont.systemFont(ofSize: 14.0),
                                                                          .foregroundColor: UIColor.lightGray])
        textField.font = .systemFont(ofSize: 14.0)
        textField.tintColor = .black
        textField.delegate = self
        return textField
    }()
    
    private let titleUnderlinedView: UIView = {
        let underlinedView = UIView()
        underlinedView.backgroundColor = UIColor(white: 0, alpha: 0.2)
        return underlinedView
    }()
    
    private let contentsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17.0, weight: .medium)
        label.text = "내용"
        return label
    }()
    
    private let contentsUnderlinedView: UIView = {
        let underlinedView = UIView()
        underlinedView.backgroundColor = UIColor(white: 0, alpha: 0.2)
        return underlinedView
    }()
    
    private lazy var contentsInputTextView: PostTextView = {
        let textView = PostTextView()
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5.0
        textView.typingAttributes = [.paragraphStyle: paragraphStyle, .font: UIFont.systemFont(ofSize: 14.0)]
        textView.delegate = self
        return textView
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17.0, weight: .medium)
        label.textColor = .black
        label.text = "가격"
        return label
    }()
    
    private lazy var priceInputTextField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: "가격을 입력해주세요.",
                                                             attributes: [.font: UIFont.systemFont(ofSize: 14.0),
                                                                          .foregroundColor: UIColor.lightGray])
        textField.font = .systemFont(ofSize: 14.0)
        textField.keyboardType = .numberPad
        textField.tintColor = .black
        textField.addTarget(self, action: #selector(validateNumberForm), for: .editingChanged)
        textField.delegate = self
        return textField
    }()
    
    private lazy var priceUnderlinedView: UIView = {
        let underlinedView = UIView()
        underlinedView.backgroundColor = UIColor(white: 0, alpha: 0.2)
        return underlinedView
    }()
    
    private lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17.0, weight: .medium)
        label.textColor = .black
        label.text = "분류 선택"
        return label
    }()
    
    private lazy var categoryInputTextField: UITextField = {
        let textField = UITextField()
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "arrowtriangle.down.fill")
        imageView.preferredSymbolConfiguration = .init(pointSize: 12)
        imageView.tintColor = UIColor(named: "colorBlueGreen")
        textField.rightView = imageView
        textField.rightViewMode = .always
        textField.attributedPlaceholder = NSAttributedString(string: "분류를 선택해주세요.",
                                                             attributes: [.font: UIFont.systemFont(ofSize: 14.0),
                                                                          .foregroundColor: UIColor.lightGray])
        textField.font = .systemFont(ofSize: 14.0)
        textField.tintColor = .clear
        textField.addTarget(self, action: #selector(validateCategoryForm), for: .editingChanged)
        textField.delegate = self
        return textField
    }()
    
    private lazy var categoryUnderlinedView: UIView = {
        let underlinedView = UIView()
        underlinedView.backgroundColor = UIColor(white: 0, alpha: 0.2)
        return underlinedView
    }()
    
    private lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.backgroundColor = .white
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.selectRow(categoryList.count / 2 - 1, inComponent: 0, animated: true)
        return pickerView
    }()
    
    private lazy var pickerTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20.0, weight: .semibold)
        label.textColor = .black
        label.text = "분류선택"
        return label
    }()
    
    private lazy var pickerButton: UIButton = {
        let button = UIButton()
        button.setAttributedTitle(.init(string: "선택",
                                        attributes: [.font: UIFont.systemFont(ofSize: 17.0, weight: .semibold),
                                                     .foregroundColor: UIColor(named: "colorPaleOrange")!]),
                                        for: .normal)
        button.addTarget(self, action: #selector(selectCategory), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    private lazy var pickerShadowView: UIView = {
        let contentView = UIView()
        let shadowView = UIView()
        let emptyView = UIView()
        shadowView.backgroundColor = .white
        shadowView.layer.borderWidth = 8.0
        shadowView.layer.borderColor = UIColor.white.cgColor
        shadowView.layer.masksToBounds = false
        shadowView.layer.cornerRadius = 12
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOffset = CGSize(width: 0, height: -1.0)
        shadowView.layer.shadowOpacity = 0.3
        shadowView.layer.shadowRadius = 5.0
        emptyView.backgroundColor = .white
        [shadowView, emptyView].forEach { contentView.addSubview($0) }
        shadowView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(8.0)
        }
        emptyView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalToSuperview().dividedBy(2.0)
        }
        contentView.isHidden = true
        return contentView
    }()
    
    override var inputAccessoryView: UIView? {
        get { return imageInputView }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    // MARK: Lifecycle
    init(commuityType: CommunityType) {
        self.communityType = commuityType
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
        configure()
        configureNavigationView()
        layout()
        addTapGestureOnScrollView()
        addKeyboardObserver()
        configurePickerView()
    }
    
    override func viewDidLayoutSubviews() {
        guard imageInputView.imageCollectionView == nil else { return }
        imageInputView.imageCollectionView = collectionView
    }
    
    // MARK: Actions
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    private func showPickerBar(_ isAppeared: Bool) {
        pickerShadowView.isHidden = !isAppeared
        imageInputView.hideImageAddingButton = isAppeared
    }
    
    @objc
    private func selectCategory() {
        guard let text = categoryInputTextField.text, !text.isEmpty else { return }
        view.endEditing(true)
    }
    
    @objc
    private func validateNumberForm(_ sender: UITextField) {
        guard let text = sender.text else { return }
        guard let number = Int32(text.filter { $0.isNumber }), number < Int32.max else {
            sender.deleteBackward()
            return
        }
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        sender.text = numberFormatter.string(from: NSNumber(value: number))
            .map { "\(String(describing: $0))원" }
    }
    
    @objc
    private func validateCategoryForm(_ sender: UITextField) {
        guard let text = sender.text else { return }
        guard categoryList.contains(text) else {
            sender.text = ""
            return
        }
    }
    
    @objc
    private func didTapCompleteButton() {
        guard let titleText = titleInputTextField.text, let contentsText = contentsInputTextView.text else { return }
        guard !titleText.isEmpty else {
            let popUpContents = "제목을 입력해주세요."
            let viewController = PopUpViewController(contents: popUpContents)
            viewController.modalPresentationStyle = .overCurrentContext
            present(viewController, animated: false, completion: nil)
            return
        }
        
        if communityType == .market {
            guard let priceText = priceInputTextField.text, !priceText.isEmpty else {
                let popUpContents = "가격을 입력해주세요."
                let viewController = PopUpViewController(contents: popUpContents)
                viewController.modalPresentationStyle = .overCurrentContext
                present(viewController, animated: false, completion: nil)
                return
            }
        } else if communityType == .emergency || communityType == .suggestion {
            guard let categoryText = categoryInputTextField.text, !categoryText.isEmpty else {
                let popUpContents = "분류를 선택해주세요."
                let viewController = PopUpViewController(contents: popUpContents)
                viewController.modalPresentationStyle = .overCurrentContext
                present(viewController, animated: false, completion: nil)
                return
            }
        }
        
        guard !contentsText.isEmpty else {
            let popUpContents = "내용을 입력해주세요."
            let viewController = PopUpViewController(contents: popUpContents)
            viewController.modalPresentationStyle = .overCurrentContext
            present(viewController, animated: false, completion: nil)
            return
        }
        
        guard !(communityType == .market && selectedImages.isEmpty) else {
            let popUpContents = "사진을 1장 이상 첨부해주세요."
            let viewController = PopUpViewController(contents: popUpContents)
            viewController.modalPresentationStyle = .overCurrentContext
            present(viewController, animated: false, completion: nil)
            return
        }
        
        showLoader(true)
        CommunityNetworkManager().postCommunity(code: communityType.rawValue, title: titleText, contents: contentsText, images: selectedImages) { [weak self] isSucceded in
            guard let self = self else { return }
            guard isSucceded else {
                print("DEBUG: failed..")
                self.showLoader(false)
                return
            }
            self.showLoader(false)
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @objc
    private func didTapScrollView() {
        view.endEditing(true)
    }
    
    @objc
    private func keyboardWillShow(_ notification: NSNotification) {
        guard let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        scrollView.snp.updateConstraints { $0.bottom.equalToSuperview().inset(keyboardFrame.height) }
    }
    
    @objc
    private func keyboardWillHide(_ notification: NSNotification) {
        guard let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        scrollView.snp.updateConstraints { $0.bottom.equalToSuperview().inset(keyboardFrame.height) }
    }
    
    // MARK: Helpers
    private func configurePickerView() {
        guard communityType == .emergency || communityType == .suggestion else { return }
        categoryInputTextField.inputView = pickerView
        imageInputView.addSubview(pickerShadowView)
        pickerShadowView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(48.0)
        }
        
        [pickerTitleLabel,pickerButton].forEach { pickerShadowView.addSubview($0) }
        pickerTitleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        pickerButton.snp.makeConstraints {
            $0.centerY.equalTo(pickerTitleLabel)
            $0.trailing.equalToSuperview().inset(10.0)
            $0.width.height.equalTo(44.0)
        }
    }
    
    private func addKeyboardObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    private func addTapGestureOnScrollView() {
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapScrollView))
        singleTapGestureRecognizer.numberOfTapsRequired = 1
        singleTapGestureRecognizer.isEnabled = true
        singleTapGestureRecognizer.cancelsTouchesInView = false
        scrollView.addGestureRecognizer(singleTapGestureRecognizer)
    }
    
    private func configureCollectionView() {
        collectionView.register(WriteImageCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func configure() {
        view.backgroundColor = .white
        switch communityType {
        case .gathering:
            contentsInputTextView.placeHolderText = "다른 메이트님들이 쉽게 참여할실 수 있도록,\n함께하고 싶은 내용, 모집 예정 인원, 시간대 등\n정보를 자세하게 적어주세요."
        case .market:
            contentsInputTextView.placeHolderText = "거래하실 물품에 대하여 자세하게 적어주세요."
        default:
            contentsInputTextView.placeHolderText = "내용을 입력해주세요."
        }
    }
    
    private func configureNavigationView() {
        switch communityType {
        case .gathering:
            navigationItem.title = "함께글쓰기"
        case .market:
            navigationItem.title = "장터글쓰기"
        case .free:
            navigationItem.title = "자유글쓰기"
        case .emergency:
            navigationItem.title = "긴급글쓰기"
        case .suggestion:
            navigationItem.title = "건의글쓰기"
        }
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.tintColor = UIColor(named: "colorPaleOrange")
        navigationController?.navigationBar.titleTextAttributes = [.font: UIFont.systemFont(ofSize: 18.0, weight: .medium)]
        
        let rightBarButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(didTapCompleteButton))
        rightBarButton.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 16.0, weight: .medium)], for: .normal)
        navigationItem.rightBarButtonItem = rightBarButton
    }
    
    private func layout() {
        [titleLabel, titleInputTextField, titleUnderlinedView, contentsLabel, contentsInputTextView, contentsUnderlinedView].forEach { contentsView.addSubview($0) }
        scrollView.addSubview(contentsView)
        view.addSubview(scrollView)
        view.addSubview(collectionView)
        
        scrollView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalToSuperview()
        }
        
        contentsView.snp.makeConstraints {
            $0.edges.equalTo(0)
            $0.width.equalTo(view.frame.width)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(11.0)
            $0.leading.equalToSuperview().inset(16.0)
            $0.height.equalTo(20.0)
        }
        
        titleInputTextField.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12.0)
            $0.leading.equalTo(titleLabel)
            $0.trailing.equalToSuperview().inset(18.0)
        }

        titleUnderlinedView.snp.makeConstraints {
            $0.top.equalTo(titleInputTextField.snp.bottom).offset(9.5)
            $0.leading.equalTo(titleInputTextField)
            $0.trailing.equalToSuperview().inset(18.0)
            $0.height.equalTo(1.0)
        }
        // 분기 시작 -----------------------------------
        switch communityType {
        case .market:
            [priceLabel, priceInputTextField, priceUnderlinedView].forEach { contentsView.addSubview($0) }
            priceLabel.snp.makeConstraints {
                $0.top.equalTo(titleUnderlinedView.snp.bottom).offset(19.5)
                $0.leading.equalTo(titleUnderlinedView)
                $0.height.equalTo(20.0)
            }
            
            priceInputTextField.snp.makeConstraints {
                $0.top.equalTo(priceLabel.snp.bottom).offset(12.0)
                $0.leading.equalTo(priceLabel)
                $0.trailing.equalToSuperview().inset(18.0)
            }
            
            priceUnderlinedView.snp.makeConstraints {
                $0.top.equalTo(priceInputTextField.snp.bottom).offset(9.5)
                $0.leading.equalTo(priceInputTextField)
                $0.trailing.equalToSuperview().inset(18.0)
                $0.height.equalTo(1.0)
            }
            
            contentsLabel.snp.makeConstraints {
                $0.top.equalTo(priceUnderlinedView.snp.bottom).offset(19.5)
                $0.leading.equalTo(priceUnderlinedView)
                $0.height.equalTo(20.0)
            }
            
        case .emergency, .suggestion:
            [categoryLabel, categoryInputTextField, categoryUnderlinedView].forEach { contentsView.addSubview($0) }
            categoryLabel.snp.makeConstraints {
                $0.top.equalTo(titleUnderlinedView.snp.bottom).offset(19.5)
                $0.leading.equalTo(titleUnderlinedView)
                $0.height.equalTo(20.0)
            }
            
            categoryInputTextField.snp.makeConstraints {
                $0.top.equalTo(categoryLabel.snp.bottom).offset(12.0)
                $0.leading.equalTo(categoryLabel)
                $0.trailing.equalToSuperview().inset(18.0)
            }
            
            categoryUnderlinedView.snp.makeConstraints {
                $0.top.equalTo(categoryInputTextField.snp.bottom).offset(9.5)
                $0.leading.equalTo(categoryInputTextField)
                $0.trailing.equalToSuperview().inset(18.0)
                $0.height.equalTo(1.0)
            }
            
            contentsLabel.snp.makeConstraints {
                $0.top.equalTo(categoryUnderlinedView.snp.bottom).offset(19.5)
                $0.leading.equalTo(categoryUnderlinedView)
                $0.height.equalTo(20.0)
            }
            
        default:
            contentsLabel.snp.makeConstraints {
                $0.top.equalTo(titleUnderlinedView.snp.bottom).offset(19.5)
                $0.leading.equalTo(titleUnderlinedView)
                $0.height.equalTo(20.0)
            }
        }
        // 분기 끝 -------------------------------------
        contentsInputTextView.snp.makeConstraints {
            $0.top.equalTo(contentsLabel.snp.bottom).offset(12.0)
            $0.leading.equalTo(contentsLabel)
            $0.trailing.equalToSuperview().inset(18.0)
        }
        
        contentsUnderlinedView.snp.makeConstraints {
            $0.top.equalTo(contentsInputTextView.snp.bottom).offset(9.5)
            $0.leading.equalTo(titleInputTextField)
            $0.trailing.equalToSuperview().inset(18.0)
            $0.height.equalTo(1.0)
            $0.bottom.equalToSuperview().inset(3.0)
        }
    }
    
}

// MARK: ImageInputAccessoryViewDelegate
extension WriteViewController: ImageInputAccessoryViewDelegate {
    func didTapimageAddingButton() {
        guard numberOfImages < 9 else {
            let popUpContents = "사진은 최대 9장까지 첨부할 수 있습니다."
            let popUpViewController = PopUpViewController(buttonType: .cancel, contents: popUpContents)
            popUpViewController.modalPresentationStyle = .overCurrentContext
            present(popUpViewController, animated: false)
            return
        }
        
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 9 - numberOfImages
        configuration.filter = .images
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }
}

// MARK: WriteImageCellDelegate
extension WriteViewController: WriteImageCellDelegate {
    func subtractImage(indexPath: IndexPath) {
        selectedImages.remove(at: indexPath.item)
        numberOfImages -= 1
    }
}

// MARK: PHPickerViewControllerDelegate
extension WriteViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        guard !results.isEmpty else { return }
        self.numberOfImages += results.count
        for result in results {
            result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] object, error in
                guard let self = self, let image = object as? UIImage else { return }
                self.selectedImages.append(image.downSize(newWidth: 300))
            }
        }
    }
}

// MARK: UIPickerViewDataSource, Delegate
extension WriteViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch communityType {
        case .suggestion, .emergency:
            return categoryList.count
        default:
            return 0
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch communityType {
        case .suggestion, .emergency:
            return categoryList[row]
        default:
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        categoryInputTextField.text = categoryList[row]
    }
}

// MARK: UITextFieldDelegate
extension WriteViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == priceInputTextField {
            guard var text = textField.text else { return false }
            if string.isEmpty {
                guard !text.isEmpty else { return false }
                text.removeLast()
                text.removeLast()
                let numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = .decimal
                priceInputTextField.text = Int32(text.filter { $0.isNumber })
                    .flatMap { numberFormatter.string(from: NSNumber(value: $0)) }
                    .map { "\(String(describing: $0))원" }
                return false
            }
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("DEBUG: textFieldDidBeginEditing")
        switch textField {
        case titleInputTextField:
            titleUnderlinedView.backgroundColor = UIColor(named: "colorBlueGreen")
            titleUnderlinedView.snp.updateConstraints { $0.height.equalTo(1.5) }
        case priceInputTextField:
            priceUnderlinedView.backgroundColor = UIColor(named: "colorPaleOrange")
            priceUnderlinedView.snp.updateConstraints { $0.height.equalTo(1.5) }
        case categoryInputTextField:
            categoryUnderlinedView.backgroundColor = UIColor(named: "colorBlueGreen")
            categoryUnderlinedView.snp.updateConstraints { $0.height.equalTo(1.5) }
            showPickerBar(true)
            if textField.text == "" {
                let time = DispatchTime.now() + .milliseconds(250)
                DispatchQueue.main.asyncAfter(deadline: time) { [weak self] in
                    guard let self = self else { return }
                    textField.text = self.categoryList[self.categoryList.count / 2 - 1]
                }
            }
        default:
            return
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("DEBUG: textFieldDidEndEditing")
        switch textField {
        case titleInputTextField:
            titleUnderlinedView.backgroundColor = UIColor(white: 0, alpha: 0.2)
            titleUnderlinedView.snp.updateConstraints { $0.height.equalTo(1.0) }
        case priceInputTextField:
            priceUnderlinedView.backgroundColor = UIColor(white: 0, alpha: 0.2)
            priceUnderlinedView.snp.updateConstraints { $0.height.equalTo(1.0) }
        case categoryInputTextField:
            categoryUnderlinedView.backgroundColor = UIColor(white: 0, alpha: 0.2)
            categoryUnderlinedView.snp.updateConstraints { $0.height.equalTo(1.0) }
            showPickerBar(false)
        default:
            return
        }
    }
}

// MARK: UITextViewDelegate
extension WriteViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == contentsInputTextView {
            contentsUnderlinedView.backgroundColor = UIColor(named: "colorBlueGreen")
            contentsUnderlinedView.snp.updateConstraints { $0.height.equalTo(1.8) }
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == contentsInputTextView {
            contentsUnderlinedView.backgroundColor = UIColor(white: 0, alpha: 0.2)
            contentsUnderlinedView.snp.updateConstraints { $0.height.equalTo(1.0) }
        }
    }
}

// MARK: UICollectionViewDataSource
extension WriteViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedImages.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? WriteImageCell else { return WriteImageCell() }
        cell.delegate = self
        cell.indexPath = indexPath
        cell.image = selectedImages[indexPath.item]
        return cell
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension WriteViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 114.0, height: 82.0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 12.0, bottom: 0, right: 12.0)
    }
}
