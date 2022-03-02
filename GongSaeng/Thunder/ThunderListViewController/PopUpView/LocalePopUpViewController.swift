//
//  LocalePopUpViewController.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/02/14.
//

import UIKit
import SnapKit

protocol LocalePopUpViewControllerDelegate: AnyObject {
    func updateTableView()
}

final class LocalePopUpViewController: UIViewController {
    
    // MARK: Properties
    weak var delegate: LocalePopUpViewControllerDelegate?
    
    private var viewModel = LocaleViewModel()
    
    private let maxDimmedAlpha: CGFloat = 0.4
    private let defaultWidth: CGFloat = 86.0
    private let defaultHeight: CGFloat = 300.0
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10.0
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var dimmedView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = maxDimmedAlpha
        return view
    }()
    
    private lazy var regionalTableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.bounces = false
        tableView.rowHeight = 40.0
        tableView.separatorInset = .zero
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "RegionalCell")
        return tableView
    }()
    
    private lazy var metropolisTableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.bounces = false
        tableView.rowHeight = 40.0
        tableView.separatorInset = .zero
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MetropolisCell")
        return tableView
    }()
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        layout()
        setupTapGestrue()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        animateShowDimmedView()
        animatePresentContainer()
    }
    
    // MARK: Animations
    private func animateShowDimmedView() {
        dimmedView.alpha = 0
        UIView.animate(withDuration: 0.4) {
            self.dimmedView.alpha = self.maxDimmedAlpha
        }
    }
    
    private func animatePresentContainer() {
        UIView.animate(withDuration: 0.3) {
            self.containerView.snp.updateConstraints {
                $0.height.equalTo(self.viewModel.regionalTableViewHeight)
            }
            self.view.layoutIfNeeded()
        }
    }
    
    private func animateDismissView(shouldUpdate: Bool = false) {
        if shouldUpdate { delegate?.updateTableView() }
        UIView.animate(withDuration: 0.3) {
            self.containerView.snp.updateConstraints {
                $0.height.equalTo(0)
            }
            self.view.layoutIfNeeded()
        }
        
        dimmedView.alpha = maxDimmedAlpha
        UIView.animate(withDuration: 0.4) {
            self.dimmedView.alpha = 0
        } completion: { _ in
            self.dismiss(animated: false)
        }
    }
    
    private func animateShowMetropolis() {
        UIView.animate(withDuration: 0.3) {
            self.regionalTableView.snp.updateConstraints {
                $0.trailing.equalToSuperview().inset(-self.defaultWidth)
            }
            self.containerView.snp.updateConstraints {
                $0.height.equalTo(self.defaultHeight)
            }
            self.view.layoutIfNeeded()
        }
    }
    
    private func setupTapGestrue() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        dimmedView.addGestureRecognizer(tapGesture)
    }
    
    @objc
    private func handleTapGesture(gesture: UITapGestureRecognizer) {
        animateDismissView()
    }

    // MARK: Helpers
    private func configure() {
        view.backgroundColor = .clear
    }
    
    private func layout() {
        [dimmedView, containerView].forEach { view.addSubview($0) }
        dimmedView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        containerView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(45.0)
            $0.trailing.equalToSuperview().inset(15.0)
            $0.width.equalTo(defaultWidth)
            $0.height.equalTo(0)
        }
        
        [regionalTableView, metropolisTableView]
            .forEach { containerView.addSubview($0) }
        regionalTableView.snp.makeConstraints {
            $0.top.trailing.bottom.equalToSuperview()
            $0.width.equalTo(defaultWidth)
        }
        
        metropolisTableView.snp.makeConstraints {
            $0.width.height.centerY.equalToSuperview()
            $0.trailing.equalTo(regionalTableView.snp.leading)
        }
    }
}

// MARK: UITableViewDataSource
extension LocalePopUpViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case regionalTableView:
            return viewModel.numOfRegion + 1
            
        case metropolisTableView:
            return viewModel.numOfMetropolis
            
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case regionalTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "RegionalCell", for: indexPath)
            var content = cell.defaultContentConfiguration()
            content.textProperties.alignment = .center
            var region: String = ""
            var attributes: [NSAttributedString.Key: Any] = [:]
            if indexPath.row == viewModel.selectedRegionIndex {
                region = viewModel.regionalList[indexPath.row]
                attributes = [
                    .font: UIFont.systemFont(
                        ofSize: 14.0,
                        weight: .bold),
                    .foregroundColor: UIColor.black]
            } else if indexPath.row == viewModel.numOfRegion {
                region = "전체지역"
                attributes = [
                    .font: UIFont.systemFont(
                        ofSize: 13.0,
                        weight: .heavy),
                    .foregroundColor: UIColor.systemGray]
                content.image = UIImage(systemName: "chevron.left")
                content.imageProperties.tintColor = .systemGray
                content.imageProperties.preferredSymbolConfiguration = .init(pointSize: 11.0)
                content.imageToTextPadding = -8.0
                content.imageProperties.reservedLayoutSize = CGSize(width: 10.0, height: 10.0)
            } else {
                region = viewModel.regionalList[indexPath.row]
                attributes = [
                    .font: UIFont.systemFont(
                        ofSize: 14.0,
                        weight: .bold),
                    .foregroundColor: UIColor.systemGray]
            }
            content.attributedText = NSAttributedString(
                string: region,
                attributes: attributes)
            cell.contentConfiguration = content
            cell.contentView.layoutMargins = .zero
            cell.preservesSuperviewLayoutMargins = false
            return cell
            
        case metropolisTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MetropolisCell", for: indexPath)
            var content = cell.defaultContentConfiguration()
            content.textProperties.alignment = .center
            content.attributedText = NSAttributedString(
                string: viewModel.metropolisList[indexPath.row],
                attributes: [
                    .font: UIFont.systemFont(ofSize: 14.0, weight: .bold),
                    .foregroundColor: (indexPath.row == viewModel.selectedMetropolisIndex) ? UIColor.black : UIColor.systemGray])
            cell.contentConfiguration = content
            return cell
            
        default:
            return UITableViewCell()
        }
        
    }
}

// MARK: UITableViewDelegate
extension LocalePopUpViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch tableView {
        case regionalTableView:
            guard indexPath.row != viewModel.selectedRegionIndex else {
                animateDismissView()
                return
            }
            guard indexPath.row != viewModel.numOfRegion else {
                animateShowMetropolis()
                return
            }
            let region = viewModel.regionalList[indexPath.row]
            UserDefaults.standard.setValue(region, forKey: "region")
            animateDismissView(shouldUpdate: true)
            
        case metropolisTableView:
            guard indexPath.row != viewModel.selectedMetropolisIndex else {
                animateDismissView()
                return
            }
            let metropolis = viewModel.metropolisList[indexPath.row]
            UserDefaults.standard.setValue(metropolis, forKey: "region")
            UserDefaults.standard.setValue(metropolis, forKey: "metropolis")
            animateDismissView(shouldUpdate: true)
            
        default:
            return
        }
        
    }
}
