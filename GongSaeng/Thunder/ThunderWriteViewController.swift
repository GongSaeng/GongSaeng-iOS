//
//  TempWrite2ViewController.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/02/04.
//

import UIKit
import SnapKit
import PhotosUI

final class ThunderWriteViewController: UIViewController {
    
    // MARK: Properties
    var placeDocument: PlaceDocument? {
        didSet {
            guard let placeDocument = placeDocument else { return }
            placeInputTextField.text = placeDocument.placeName
        }
    }
    
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
    private let numOfPeopleList: [String] = Array<Int>(2...50).map { String($0) }
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
    
    private let dateAndTimeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17.0, weight: .medium)
        label.textColor = .black
        label.text = "시간"
        return label
    }()
    
    private lazy var dateAndTimeInputTextField: UITextField = {
        let textField = UITextField()
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "arrowtriangle.down.fill")
        imageView.preferredSymbolConfiguration = .init(pointSize: 12)
        imageView.tintColor = UIColor(named: "colorBlueGreen")
        textField.rightView = imageView
        textField.rightViewMode = .always
        textField.attributedPlaceholder = NSAttributedString(string: "날짜와 시간을 선택해주세요.",
                                                             attributes: [.font: UIFont.systemFont(ofSize: 14.0),
                                                                          .foregroundColor: UIColor.lightGray])
        textField.font = .systemFont(ofSize: 14.0)
        textField.addTarget(self, action: #selector(validateTextFieldForm), for: .editingChanged)
        textField.tintColor = .clear
        textField.delegate = self
        return textField
    }()
    
    private let dateAndTimeUnderlinedView: UIView = {
        let underlinedView = UIView()
        underlinedView.backgroundColor = UIColor(white: 0, alpha: 0.2)
        return underlinedView
    }()
    
    private let placeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17.0, weight: .medium)
        label.textColor = .black
        label.text = "장소"
        return label
    }()
    
    private lazy var placeInputTextField: UITextField = {
        let textField = UITextField()
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "arrowtriangle.down.fill")
        imageView.preferredSymbolConfiguration = .init(pointSize: 12)
        imageView.tintColor = UIColor(named: "colorBlueGreen")
        textField.rightView = imageView
        textField.rightViewMode = .always
        textField.attributedPlaceholder = NSAttributedString(string: "장소를 선택해주세요.",
                                                             attributes: [.font: UIFont.systemFont(ofSize: 14.0),
                                                                          .foregroundColor: UIColor.lightGray])
        textField.font = .systemFont(ofSize: 14.0)
        textField.tintColor = .clear
        textField.delegate = self
        return textField
    }()
    
    private let placeUnderlinedView: UIView = {
        let underlinedView = UIView()
        underlinedView.backgroundColor = UIColor(white: 0, alpha: 0.2)
        return underlinedView
    }()
    
    private let numOfPeopleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17.0, weight: .medium)
        label.textColor = .black
        label.text = "인원"
        return label
    }()
    
    private lazy var numOfPeopleInputTextField: UITextField = {
        let textField = UITextField()
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "arrowtriangle.down.fill")
        imageView.preferredSymbolConfiguration = .init(pointSize: 12)
        imageView.tintColor = UIColor(named: "colorBlueGreen")
        textField.rightView = imageView
        textField.rightViewMode = .always
        textField.attributedPlaceholder = NSAttributedString(string: "인원을 선택해주세요.",
                                                             attributes: [.font: UIFont.systemFont(ofSize: 14.0),
                                                                          .foregroundColor: UIColor.lightGray])
        textField.font = .systemFont(ofSize: 14.0)
        textField.tintColor = .clear
        textField.addTarget(self, action: #selector(validateTextFieldForm), for: .editingChanged)
        textField.delegate = self
        return textField
    }()
    
    private let numOfPeopleUnderlinedView: UIView = {
        let underlinedView = UIView()
        underlinedView.backgroundColor = UIColor(white: 0, alpha: 0.2)
        return underlinedView
    }()
    
    private lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.backgroundColor = .white
        pickerView.delegate = self
        pickerView.dataSource = self
        return pickerView
    }()
    
    private let pickerTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20.0, weight: .semibold)
        label.textColor = .black
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
    
    private let pickerShadowView: UIView = {
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
    
    private lazy var datePickerView: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.tintColor = UIColor(named: "colorBlueGreen")
        datePicker.preferredDatePickerStyle = .inline
        datePicker.datePickerMode = .dateAndTime
        datePicker.locale = Locale(identifier: "ko-KR")
        datePicker.timeZone = .autoupdatingCurrent
        datePicker.minuteInterval = 10
        datePicker.minimumDate = Date() + 60 * 10
        datePicker.addTarget(self, action: #selector(DidChangeDatePicker), for: .valueChanged)
        return datePicker
    }()
    
    private let gatheringDetailsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18.0, weight: .semibold)
        label.text = "+ 모집 상세"
        return label
    }()
    
    private let postDetailsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18.0, weight: .semibold)
        label.text = "+ 글 상세"
        return label
    }()
    
    override var inputAccessoryView: UIView? {
        get { return imageInputView }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    // MARK: Lifecycle
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
        datePickerView.backgroundColor = .white
        let width: CGFloat = UIScreen.main.bounds.width
        let height: CGFloat = width * 1.1
        datePickerView.frame = CGRect(x: 0, y: 0, width: width, height: height)
    }
    
    // MARK: Actions
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    private func showPickerBar(_ isAppeared: Bool, withTitle title: String? = nil) {
        pickerTitleLabel.text = title
        pickerShadowView.isHidden = !isAppeared
        imageInputView.hideImageAddingButton = isAppeared
    }
    
    @objc
    private func DidChangeDatePicker(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_kr")
        dateFormatter.dateFormat = "yyyy년 M월 d일 (E) a h:mm"
        var selectedDate: String = dateFormatter.string(from: sender.date)
        selectedDate.removeLast()
        selectedDate += "0"
        dateAndTimeInputTextField.text = selectedDate
    }
    
    @objc
    private func selectCategory() {
        guard let text = numOfPeopleInputTextField.text, !text.isEmpty else { return }
        view.endEditing(true)
    }
    
    @objc
    private func validateTextFieldForm(_ sender: UITextField) {
        guard let text = sender.text else { return }
        switch sender {
        case numOfPeopleInputTextField:
            let numOfPeoples = numOfPeopleList.map { $0 + " 명"}
            if !numOfPeoples.contains(text) {
                sender.text = ""
                return
            }
            
            
        case dateAndTimeInputTextField:
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "ko_kr")
            dateFormatter.dateFormat = "yyyy년 M월 d일 (E) a h:mm"
            guard let date = dateFormatter.date(from: text), date > Date() else {
                sender.text = ""
                return
            }
            return
            
        default:
            return
        }
    }
    
    @objc
    private func didTapCompleteButton() {
        guard var timeText = dateAndTimeInputTextField.text, let placeText = placeInputTextField.text, var numOfPeopleText = numOfPeopleInputTextField.text, let titleText = titleInputTextField.text, let contentsText = contentsInputTextView.text else { return }
        var popUpContents = ""
        
        if timeText.isEmpty {
            popUpContents += popUpContents.isEmpty ? "" : "\n"
            popUpContents += "-시간을 선택해주세요."
        }
        
        if placeText.isEmpty {
            popUpContents += popUpContents.isEmpty ? "" : "\n"
            popUpContents += "-장소를 선택해주세요."
        }
        
        if numOfPeopleText.isEmpty {
            popUpContents += popUpContents.isEmpty ? "" : "\n"
            popUpContents += "-인원을 선택해주세요."
        }
        
        if titleText.isEmpty {
            popUpContents += popUpContents.isEmpty ? "" : "\n"
            popUpContents += "-제목을 입력해주세요."
        }
        
        if contentsText.isEmpty {
            popUpContents += popUpContents.isEmpty ? "" : "\n"
            popUpContents += "-내용을 입력해주세요."
        }
        
        if selectedImages.isEmpty {
            popUpContents += popUpContents.isEmpty ? "" : "\n"
            popUpContents += "-사진을 1장 이상 첨부해주세요."
        }
        
        guard popUpContents.isEmpty else {
            let viewController = PopUpViewController(contents: popUpContents)
            viewController.modalPresentationStyle = .overCurrentContext
            present(viewController, animated: false, completion: nil)
            return
        }
        
        let beforeDateFormatter = DateFormatter()
        let afterDateFormatter = DateFormatter()
        beforeDateFormatter.locale = Locale(identifier: "ko_kr")
        afterDateFormatter.locale = Locale(identifier: "ko_kr")
        beforeDateFormatter.dateFormat = "yyyy년 M월 d일 (E) a h:mm"
        afterDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:00"
        guard let date = beforeDateFormatter.date(from: timeText), let roadAddressName = placeDocument?.roadAddressName, let addressName = placeDocument?.addressName else { return }
        let addressText = roadAddressName.isEmpty ? addressName : roadAddressName
        timeText = afterDateFormatter.string(from: date)
        numOfPeopleText = numOfPeopleText.filter { $0.isNumber }
        
        // API 코드 작성
        print("DEBUG: timeText -> \(timeText)")
        print("DEBUG: placeText -> \(placeText)")
        print("DEBUG: addressText -> \(addressText)")
        print("DEBUG: numOfPeopleText -> \(numOfPeopleText)")
        print("DEBUG: titleText -> \(titleText)")
        print("DEBUG: contentsText -> \(contentsText)")
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
        dateAndTimeInputTextField.inputView = datePickerView
        numOfPeopleInputTextField.inputView = pickerView
        
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
        contentsInputTextView.placeHolderText = "다른 메이트님들이 쉽게 참여할실 수 있도록,\n함께하고 싶은 내용 등 정보를 자세하게 적어주세요."
    }
    
    private func configureNavigationView() {
        navigationItem.title = "번개 글쓰기"
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.tintColor = UIColor(named: "colorPaleOrange")
        navigationController?.navigationBar.titleTextAttributes = [.font: UIFont.systemFont(ofSize: 18.0, weight: .medium)]
        
        let rightBarButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(didTapCompleteButton))
        rightBarButton.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 16.0, weight: .medium)], for: .normal)
        navigationItem.rightBarButtonItem = rightBarButton
    }
    
    private func layout() {
        [gatheringDetailsLabel, postDetailsLabel, dateAndTimeLabel, dateAndTimeInputTextField, dateAndTimeUnderlinedView, placeLabel, placeInputTextField, placeUnderlinedView, numOfPeopleLabel, numOfPeopleInputTextField, numOfPeopleUnderlinedView, titleLabel, titleInputTextField, titleUnderlinedView, contentsLabel, contentsInputTextView, contentsUnderlinedView].forEach { contentsView.addSubview($0) }
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
        
        gatheringDetailsLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(11.0)
            $0.leading.equalToSuperview().inset(18.0)
        }
        
        dateAndTimeLabel.snp.makeConstraints {
            $0.top.equalTo(gatheringDetailsLabel.snp.bottom).offset(9.5)
            $0.leading.equalTo(gatheringDetailsLabel)
            $0.height.equalTo(20.0)
        }
        
        dateAndTimeInputTextField.snp.makeConstraints {
            $0.top.equalTo(dateAndTimeLabel.snp.bottom).offset(12.0)
            $0.leading.equalTo(dateAndTimeLabel)
            $0.trailing.equalToSuperview().inset(18.0)
        }
        
        dateAndTimeUnderlinedView.snp.makeConstraints {
            $0.top.equalTo(dateAndTimeInputTextField.snp.bottom).offset(9.5)
            $0.leading.equalTo(dateAndTimeInputTextField)
            $0.trailing.equalToSuperview().inset(18.0)
            $0.height.equalTo(1.0)
        }
        
        placeLabel.snp.makeConstraints {
            $0.top.equalTo(dateAndTimeUnderlinedView.snp.bottom).offset(19.5)
            $0.leading.equalTo(dateAndTimeUnderlinedView)
            $0.height.equalTo(20.0)
        }
        
        placeInputTextField.snp.makeConstraints {
            $0.top.equalTo(placeLabel.snp.bottom).offset(12.0)
            $0.leading.equalTo(placeLabel)
            $0.trailing.equalToSuperview().inset(18.0)
        }
        
        placeUnderlinedView.snp.makeConstraints {
            $0.top.equalTo(placeInputTextField.snp.bottom).offset(9.5)
            $0.leading.equalTo(placeInputTextField)
            $0.trailing.equalToSuperview().inset(18.0)
            $0.height.equalTo(1.0)
        }
        
        numOfPeopleLabel.snp.makeConstraints {
            $0.top.equalTo(placeUnderlinedView.snp.bottom).offset(19.5)
            $0.leading.equalTo(placeUnderlinedView)
            $0.height.equalTo(20.0)
        }
        
        numOfPeopleInputTextField.snp.makeConstraints {
            $0.top.equalTo(numOfPeopleLabel.snp.bottom).offset(12.0)
            $0.leading.equalTo(numOfPeopleLabel)
            $0.trailing.equalToSuperview().inset(18.0)
        }
        
        numOfPeopleUnderlinedView.snp.makeConstraints {
            $0.top.equalTo(numOfPeopleInputTextField.snp.bottom).offset(9.5)
            $0.leading.equalTo(numOfPeopleInputTextField)
            $0.trailing.equalToSuperview().inset(18.0)
            $0.height.equalTo(1.0)
        }
        
        postDetailsLabel.snp.makeConstraints {
            $0.top.equalTo(numOfPeopleUnderlinedView.snp.bottom).offset(79.5)
            $0.leading.equalTo(numOfPeopleUnderlinedView)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(postDetailsLabel.snp.bottom).offset(9.5)
            $0.leading.equalTo(postDetailsLabel)
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
        
        contentsLabel.snp.makeConstraints {
            $0.top.equalTo(titleUnderlinedView.snp.bottom).offset(19.5)
            $0.leading.equalTo(titleUnderlinedView)
            $0.height.equalTo(20.0)
        }

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

// MARK: SearchPlaceViewControllerDelegate
extension ThunderWriteViewController: SearchPlaceViewControllerDelegate {
    func setPlace(placeDocument: PlaceDocument) {
        self.placeDocument = placeDocument
    }
}

// MARK: ImageInputAccessoryViewDelegate
extension ThunderWriteViewController: ImageInputAccessoryViewDelegate {
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
extension ThunderWriteViewController: WriteImageCellDelegate {
    func subtractImage(indexPath: IndexPath) {
        selectedImages.remove(at: indexPath.item)
        numberOfImages -= 1
    }
}

// MARK: PHPickerViewControllerDelegate
extension ThunderWriteViewController: PHPickerViewControllerDelegate {
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
extension ThunderWriteViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return numOfPeopleList.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return numOfPeopleList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        numOfPeopleInputTextField.text = numOfPeopleList[row] + " 명"
    }
}

// MARK: UITextFieldDelegate
extension ThunderWriteViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("DEBUG: textFieldDidBeginEditing")
        switch textField {
        case titleInputTextField:
            titleUnderlinedView.backgroundColor = UIColor(named: "colorBlueGreen")
            titleUnderlinedView.snp.updateConstraints { $0.height.equalTo(1.5) }
            
        case dateAndTimeInputTextField:
            dateAndTimeUnderlinedView.backgroundColor = UIColor(named: "colorBlueGreen")
            dateAndTimeUnderlinedView.snp.updateConstraints { $0.height.equalTo(1.5) }
            showPickerBar(true, withTitle: "시간선택")
            
        case placeInputTextField:
            let viewController = SearchPlaceViewController()
            viewController.delegate = self
            navigationController?.pushViewController(viewController, animated: true)
  
        case numOfPeopleInputTextField:
            numOfPeopleUnderlinedView.backgroundColor = UIColor(named: "colorBlueGreen")
            numOfPeopleUnderlinedView.snp.updateConstraints { $0.height.equalTo(1.5) }
            showPickerBar(true, withTitle: "인원선택")
            if textField.text == "" {
                let time = DispatchTime.now() + .milliseconds(250)
                DispatchQueue.main.asyncAfter(deadline: time) { [weak self] in
                    guard let self = self else { return }
                    textField.text = self.numOfPeopleList[0] + " 명"
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
            
        case dateAndTimeInputTextField:
            dateAndTimeUnderlinedView.backgroundColor = UIColor(white: 0, alpha: 0.2)
            dateAndTimeUnderlinedView.snp.updateConstraints { $0.height.equalTo(1.0) }
            showPickerBar(false)
 
        case numOfPeopleInputTextField:
            numOfPeopleUnderlinedView.backgroundColor = UIColor(white: 0, alpha: 0.2)
            numOfPeopleUnderlinedView.snp.updateConstraints { $0.height.equalTo(1.0) }
            showPickerBar(false)
            
        default:
            return
        }
    }
}

// MARK: UITextViewDelegate
extension ThunderWriteViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == contentsInputTextView {
            contentsUnderlinedView.backgroundColor = UIColor(named: "colorBlueGreen")
            contentsUnderlinedView.snp.updateConstraints { $0.height.equalTo(1.5) }
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
extension ThunderWriteViewController: UICollectionViewDataSource {
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
extension ThunderWriteViewController: UICollectionViewDelegateFlowLayout {
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
