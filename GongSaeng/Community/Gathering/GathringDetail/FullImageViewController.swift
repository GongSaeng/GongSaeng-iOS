//
//  FullImageViewController.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/01/15.
//

import UIKit
import SnapKit

final class FullImageViewController: UIViewController {
    
    // MARK: Properties
    private var imageList: [UIImage]
    private var page: Int
    
    private let reuseIdentifier = "FullImageCell"
    private var shouldStatusHidden: Bool = false {
        didSet { setNeedsStatusBarAppearanceUpdate() }
    }
    
    private let topNavigationView: UIView = {
        let topView = UIView()
        topView.backgroundColor = .black.withAlphaComponent(0.7)
        return topView
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .white
        let configuration = UIImage.SymbolConfiguration(pointSize: 24.0, weight: .regular)
        button.setPreferredSymbolConfiguration(configuration, forImageIn: .normal)
        button.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
        return button
    }()
    
    private let imageIndexLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 16.0, weight: .semibold)
        return label
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 0
        layout.itemSize = .init(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .black
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        return collectionView
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    override var prefersStatusBarHidden: Bool {
        return shouldStatusHidden
    }
    
    // MARK: Lifecycle
    init(imageList: [UIImage], page: Int) {
        self.imageList = imageList
        self.page = page

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateIndexLabel()
        configureCollectionView()
        layout()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        moveToCurrentPage()
    }
    
    // MARK: Actions
    @objc
    private func didTapCancelButton() {
        dismiss(animated: true)
    }
    
    private func toggleShowingTopView() {
        topNavigationView.isHidden = !topNavigationView.isHidden
        shouldStatusHidden = !shouldStatusHidden
    }
    
    private func moveToCurrentPage() {
        collectionView.setContentOffset(CGPoint(x: CGFloat(view.frame.width * CGFloat(page - 1)), y: 0), animated: false)
    }
    
    // MARK: Helpers
    private func updateIndexLabel() {
        imageIndexLabel.text = "\(page) / \(imageList.count)"
    }
    
    private func configureCollectionView() {
        collectionView.register(FullImageCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.decelerationRate = .fast
//        collectionView.zoomScale = 1.0
//        collectionView.alwaysBounceVertical = false
//        collectionView.alwaysBounceHorizontal = false
//        collectionView.minimumZoomScale = 1.0
//        collectionView.maximumZoomScale = 2.0
    }
    
    private func layout() {
        let indexContentView = UIView()
        indexContentView.backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0)
        indexContentView.layer.cornerRadius = 17.0
        indexContentView.addSubview(imageIndexLabel)
        imageIndexLabel.snp.makeConstraints { $0.center.equalToSuperview() }
        
        [cancelButton, indexContentView].forEach { topNavigationView.addSubview($0) }
        cancelButton.snp.makeConstraints {
            $0.width.height.equalTo(44.0)
            $0.bottom.trailing.equalToSuperview().inset(11.0)
        }
        
        indexContentView.snp.makeConstraints {
            $0.width.equalTo(62.0)
            $0.height.equalTo(34.0)
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(cancelButton)
        }
        
        [collectionView, topNavigationView].forEach { view.addSubview($0) }
        topNavigationView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.top).offset(50.0)
        }
        
        collectionView.snp.makeConstraints {
            $0.edges.equalTo(0)
        }
    }
}

// MARK: UICollectionViewDataSource
extension FullImageViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("DEBUG: imageList.count -> \(imageList.count)")
        return imageList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? FullImageCell else { return FullImageCell() }
        cell.clipsToBounds = true
        cell.image = imageList[indexPath.item]
        return cell
    }
}

// MARK: UICollectionViewDelegate
extension FullImageViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        toggleShowingTopView()
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let page = Int(targetContentOffset.pointee.x / view.frame.width) + 1
        self.page = page
        updateIndexLabel()
    }
}
