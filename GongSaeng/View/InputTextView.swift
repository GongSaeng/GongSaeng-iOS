//
//  InputTextView.swift
//  GongSaeng
//
//  Created by 정동천 on 2021/12/26.
//

import UIKit
import SnapKit

class InputTextView: UITextView {
    
    // MARK: Properties
    var placeHolderText: String? {
        didSet {
            placeholderLabel.text = placeHolderText
            layout()
        }
    }
    
    var shouldDeleteText: Bool? {
        didSet {
            guard let shouldDeleteText = shouldDeleteText, shouldDeleteText else { return }
            text = ""
            placeholderLabel.isHidden = false
            self.snp.updateConstraints { $0.height.equalTo(33.0) }
            self.isScrollEnabled = false
            resignFirstResponder()
        }
    }
    
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 14.0)
        return label
    }()
    
    // MARK: Lifecycle
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        addSubview(placeholderLabel)
        
        placeholderLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(4.0)
            $0.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextDidChange), name: UITextView.textDidChangeNotification, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Actions
    @objc
    private func handleTextDidChange() {
        placeholderLabel.isHidden = !text.isEmpty
        
        let size = CGSize(width: self.frame.width, height: .infinity)
        let estimatedHeight = self.sizeThatFits(size).height
        if estimatedHeight <= 70 {
            self.isScrollEnabled = false
            self.snp.updateConstraints { $0.height.equalTo(estimatedHeight) }
        } else {
            print("DEBUG: estimatedSize", estimatedHeight)
            self.isScrollEnabled = true
            self.snp.updateConstraints { $0.height.equalTo(66.5) } // 66.5 -> 3줄크기
        }
    }
    
    // MARK: Helpers
    private func layout() {
        self.snp.makeConstraints { $0.height.equalTo(33.0) }
    }
}
