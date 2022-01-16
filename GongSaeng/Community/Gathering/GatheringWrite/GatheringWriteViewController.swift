//
//  GatheringWriteViewController.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/01/11.
//

import UIKit
import SnapKit
import PhotosUI

class GatheringWriteViewController: UIViewController {
    
    // MARK: Properties
    private var selectedImages = [UIImage]() {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.collectionView.reloadData()
                self.imageInputView.hasImage = !self.selectedImages.isEmpty
            }
        }
    }
    
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
    
    private let titleInputTextField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: "제목을 입력해주세요.", attributes: [.font: UIFont.systemFont(ofSize: 14.0), .foregroundColor: UIColor.lightGray])
        textField.font = .systemFont(ofSize: 14.0)
        textField.tintColor = .black
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
    
    private let contentsInputTextView: PostTextView = {
        let textView = PostTextView()
        textView.placeHolderText = "다른 메이트님들이 쉽게 참여할실 수 있도록,\n함께하고 싶은 내용, 모집 예정 인원, 시간대 등\n정보를 자세하게 적어주세요."
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5.0
        textView.typingAttributes = [.paragraphStyle: paragraphStyle, .font: UIFont.systemFont(ofSize: 14.0)]
        return textView
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
    }
    
    override func viewDidLayoutSubviews() {
        guard imageInputView.imageCollectionView == nil else { return }
        imageInputView.imageCollectionView = collectionView
    }
    
    // MARK: Actions
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @objc private func didTapCompleteButton() {
        print("DEBUG: Did Tap completeButton..")
        guard let titleText = titleInputTextField.text, let contentsText = contentsInputTextView.text else { return }
        print("DEBUG: titleText", titleText)
        print("DEBUG: contentsText", contentsText)
        print("DEBUG: selectedImages", selectedImages)
        guard titleText != "" else {
            let viewController = PopUpViewController()
            viewController.detailText = "제목을 입력해주세요."
            viewController.modalPresentationStyle = .overCurrentContext
            present(viewController, animated: false, completion: nil)
            return
        }
        
        guard contentsText != "" else {
            let viewController = PopUpViewController()
            viewController.detailText = "내용을 입력해주세요."
            viewController.modalPresentationStyle = .overCurrentContext
            present(viewController, animated: false, completion: nil)
            return
        }
        showLoader(true)
        CommunityNetworkManager().postCommunity(code: 0, title: titleText, contents: contentsText, images: selectedImages) { [weak self] isSucceded in
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
    
    @objc private func didTapScrollView() {
        view.endEditing(true)
    }
    
    // MARK: Helpers
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
        scrollView.keyboardDismissMode = .interactive
    }
    
    private func configureNavigationView() {
        navigationController?.navigationBar.isHidden = false
        navigationItem.title = "함께글쓰기"
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
            $0.edges.equalTo(0)
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
            $0.trailing.equalToSuperview().inset(12.0)
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
            $0.bottom.equalToSuperview().inset(30.0)
        }
        
        contentsUnderlinedView.snp.makeConstraints {
            $0.top.equalTo(contentsInputTextView.snp.bottom).offset(9.5)
            $0.leading.equalTo(titleInputTextField)
            $0.trailing.equalToSuperview().inset(18.0)
            $0.height.equalTo(1.0)
        }
    }
    
}

// MARK: ImageInputAccessoryViewDelegate
extension GatheringWriteViewController: ImageInputAccessoryViewDelegate {
    func didTapimageAddingButton() {
        print("DEBUG: Delegate succeded")
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 9
        configuration.filter = .images
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }
}

// MARK: PHPickerViewControllerDelegate
extension GatheringWriteViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        guard !results.isEmpty else { return }
        for result in results {
            result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] object, error in
                guard let self = self, let image = object as? UIImage else { return }
                self.selectedImages.append(image.downSize(newWidth: 500))
            }
        }
    }
}

// MARK: WriteImageCellDelegate
extension GatheringWriteViewController: WriteImageCellDelegate {
    func subtractImage(indexPath: IndexPath) {
        selectedImages.remove(at: indexPath.item)
    }
}

// MARK: UICollectionViewDataSource
extension GatheringWriteViewController: UICollectionViewDataSource {
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

// MARK: UICollectionViewDelegate
extension GatheringWriteViewController: UICollectionViewDelegate {

}

// MARK: UICollectionViewDelegateFlowLayout
extension GatheringWriteViewController: UICollectionViewDelegateFlowLayout {
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
