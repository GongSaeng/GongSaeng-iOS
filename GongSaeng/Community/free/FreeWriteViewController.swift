//
//  FreeWriteViewController.swift
//  GongSaeng
//
//  Created by 정동천 on 2021/12/29.
//

import UIKit
import SnapKit

class FreeWriteController: UIViewController {
    
    // MARK: Properties
    let scrollView = UIScrollView()
    let contentsView = UIView()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17.0, weight: .medium)
        label.textColor = .black
        label.text = "제목"
        return label
    }()
    
    private let titleInputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "제목을 입력해주세요."
        textField.font = .systemFont(ofSize: 14.0)
        textField.tintColor = .black
        return textField
    }()
    
    private let titleUnderlinedView: UIView = {
        let underlinedView = UIView()
        underlinedView.backgroundColor = UIColor(white: 0, alpha: 0.2)
        return underlinedView
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17.0, weight: .medium)
        label.text = "내용"
        return label
    }()
    
    private let contentInputTextView: PostTextView = {
        let textView = PostTextView()
        textView.placeHolderText = "다른 메이트님들이 쉽게 참여할실 수 있도록, 함께하고 싶은 내용, 모집 예정 인원, 시간대 등 정보를 자세하게 적어주세요."
        textView.font = .systemFont(ofSize: 14.0)
        return textView
    }()
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        configureNavigationView()
        layout()
    }
    
    // MARK: Actions
    @objc func didTapCompleteButton() {
        showLoader(true)
        
        let titleText = titleInputTextField.text ?? "test title"
        let contentsText = contentInputTextView.text ?? "test contents"
        freeNetwork.freeWrite(titleText: titleText, contentsText: contentsText) { [weak self] isSucceded in
            guard let self = self, isSucceded else { return }
            self.showLoader(false)
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    // MARK: Helpers
    private func configure() {
        view.backgroundColor = .white
        scrollView.keyboardDismissMode = .interactive
    }
    
    private func configureNavigationView() {
        navigationController?.navigationBar.isHidden = false
        navigationItem.title = "자유글쓰기"
        navigationController?.navigationBar.tintColor = UIColor(named: "colorPaleOrange")
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18.0, weight: .medium)]
        
        let backBarButton = UIBarButtonItem(title: "자유게시판", style: UIBarButtonItem.Style.plain, target: self, action: nil)
        backBarButton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0)], for: .normal)

        navigationController?.navigationBar.topItem?.backBarButtonItem = backBarButton
        
        let rightBarButton = UIBarButtonItem(title: "완료", style: UIBarButtonItem.Style.plain, target: self, action: #selector(didTapCompleteButton))
        rightBarButton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0, weight: .medium)], for: .normal)
        navigationItem.rightBarButtonItem = rightBarButton
    }
    
    private func layout() {
        [titleLabel, titleInputTextField, titleUnderlinedView, contentLabel, contentInputTextView].forEach {
            contentsView.addSubview($0)
        }
        scrollView.addSubview(contentsView)
        view.addSubview(scrollView)
        
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

        contentLabel.snp.makeConstraints {
            $0.top.equalTo(titleUnderlinedView.snp.bottom).offset(19.5)
            $0.leading.equalTo(titleUnderlinedView)
            $0.height.equalTo(20.0)
        }

        contentInputTextView.snp.makeConstraints {
            $0.top.equalTo(contentLabel.snp.bottom).offset(12.0)
            $0.leading.equalTo(contentLabel)
            $0.trailing.equalToSuperview().inset(18.0)
            $0.bottom.equalToSuperview().inset(30.0)
        }
    }
}
