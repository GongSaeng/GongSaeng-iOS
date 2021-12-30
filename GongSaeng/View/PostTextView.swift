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
        didSet { placeholderLabel.text = placeHolderText }
    }
    
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 14.0)
        label.lineBreakMode = .byCharWrapping
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: Lifecycle
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        addSubview(placeholderLabel)
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        placeholderLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        confiugre()
        disableInputTraits()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Actions
    @objc func handleTextDidChange() {
        placeholderLabel.isHidden = !text.isEmpty
        setHeightFlexible()
    }
    
    private func confiugre() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextDidChange), name: UITextView.textDidChangeNotification, object: nil)
        tintColor = .black
        isScrollEnabled = false
        textContainerInset = UIEdgeInsets(top: 0, left: -6, bottom: -6, right: 0)
        self.snp.makeConstraints { $0.height.equalTo(300) }
    }
    
    private func disableInputTraits() {
        autocapitalizationType = .none
        autocorrectionType = .no
        spellCheckingType = .no
        smartDashesType = .no
        smartQuotesType = .no
        smartInsertDeleteType = .no
    }
    
    private func setHeightFlexible() {
        let size = CGSize(width: self.frame.width, height: .infinity)
        let estimatedSize = self.sizeThatFits(size)
        self.snp.updateConstraints {
            $0.height.equalTo(estimatedSize.height + 50.0)
        }
    }
}
