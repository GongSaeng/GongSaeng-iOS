//
//  CommentInputAccesoryView.swift
//  GongSaeng
//
//  Created by 정동천 on 2021/12/28.
//

import UIKit

protocol CommentInputAccesoryViewDelegate: AnyObject {
    func transferComment(_ contents: String?)
}

class CommentInputAccesoryView: UIView {
    
    // MARK: Properties
    weak var delegate: CommentInputAccesoryViewDelegate?
    
    private let commentTextView: InputTextView = {
        let textView = InputTextView()
        textView.placeHolderText = "댓글을 남겨보세요"
        textView.font = .systemFont(ofSize: 14.0)
        textView.backgroundColor = .clear
        textView.isScrollEnabled = false
        textView.tintColor = .black
        return textView
    }()
    
    private let postButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrow.up.circle.fill"), for: .normal)
        button.tintColor = UIColor(named: "colorPaleOrange")
        
        let configuration = UIImage.SymbolConfiguration(pointSize: 40.0)
        button.setPreferredSymbolConfiguration(configuration, forImageIn: .normal)
        button.addTarget(self, action: #selector(handlePostTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return .zero
    }
    
    // MARK: Actions
    func clearComment() {
        commentTextView.shouldDeleteText = true
    }
    
    @objc func handlePostTapped() {
        print("DEBUG: Did tap post button..")
        delegate?.transferComment(commentTextView.text)
    }
    
    // MARK: Helpers
    private func layout() {
        backgroundColor = .white
        autoresizingMask = .flexibleHeight
        
        let commentBackgroundView = UIView()
        commentBackgroundView.backgroundColor = UIColor(white: 0, alpha: 0.05)
        
        let divider = UIView()
        divider.backgroundColor = UIColor(white: 0, alpha: 0.05)
        
        [commentBackgroundView, commentTextView, postButton, divider].forEach { addSubview($0) }
        
        postButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8.0)
            $0.trailing.equalToSuperview().inset(18.0)
            $0.width.height.equalTo(40.0)
        }
        
        commentBackgroundView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16.0)
            $0.top.equalToSuperview().inset(6.0)
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-6.0)
            $0.trailing.equalTo(postButton.snp.leading).offset(-6.0)
        }
        
        commentTextView.snp.makeConstraints {
            $0.leading.equalTo(commentBackgroundView.snp.leading).offset(20.0)
            $0.trailing.equalTo(commentBackgroundView.snp.trailing).offset(-10.0)
            $0.top.equalTo(commentBackgroundView.snp.top).offset(6.0)
            $0.bottom.equalTo(commentBackgroundView.snp.bottom).offset(-6.0)
        }
        
        divider.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(0.5)
        }
        
        commentBackgroundView.layer.cornerRadius = 22.0
    }
}
