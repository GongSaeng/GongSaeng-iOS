//
//  PostTextView.swift
//  GongSaeng
//
//  Created by 정동천 on 2021/12/29.
//

import UIKit
import SnapKit

class PostTextView: UITextView {
    
    // MARK: Properties
    var placeHolderText: String? {
        didSet {
            guard let placeHolderText = placeHolderText else { return }
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 5.0
            placeholderLabel.attributedText = NSAttributedString(string: placeHolderText, attributes: [.paragraphStyle: paragraphStyle, .font: UIFont.systemFont(ofSize: 14.0), .foregroundColor: UIColor.lightGray])
            let screenWidth = UIScreen.main.bounds.width
            let size = CGSize(width: screenWidth - 36.0, height: .infinity)
            let estimatedSize = placeholderLabel.sizeThatFits(size)
            self.snp.makeConstraints { $0.height.equalTo(estimatedSize.height) }
        }
    }
    
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
//        label.font = .systemFont(ofSize: 14.0)
        label.lineBreakMode = .byCharWrapping
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: Lifecycle
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        layout()
        confiugre()
        disableInputTraits()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Actions
    @objc func handleTextDidChange() {
        placeholderLabel.isHidden = !text.isEmpty
        updateTextViewHeight()
    }
    
    // MARK: Helpers
    private func layout() {
        addSubview(placeholderLabel)
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        placeholderLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.width.equalToSuperview()
        }
    }
    
    private func confiugre() {
        font = .systemFont(ofSize: 14.0)
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextDidChange), name: UITextView.textDidChangeNotification, object: nil)
        isScrollEnabled = false
        textContainerInset = UIEdgeInsets(top: 0, left: -6, bottom: -6, right: 0)
        
    }
    
    private func disableInputTraits() {
        autocapitalizationType = .none
        autocorrectionType = .no
        spellCheckingType = .no
        smartDashesType = .no
        smartQuotesType = .no
        smartInsertDeleteType = .no
    }
    
    private func updateTextViewHeight() {
        guard !text.isEmpty else {
            let screenWidth = UIScreen.main.bounds.width
            let size = CGSize(width: screenWidth - 36.0, height: .infinity)
            let estimatedSize = placeholderLabel.sizeThatFits(size)
            self.snp.updateConstraints { $0.height.equalTo(estimatedSize.height) }
            return
        }
        let size = CGSize(width: self.frame.width, height: .infinity)
        let estimatedSize = self.sizeThatFits(size)
        self.snp.updateConstraints { $0.height.equalTo(estimatedSize.height + 6.0) }
    }
}
