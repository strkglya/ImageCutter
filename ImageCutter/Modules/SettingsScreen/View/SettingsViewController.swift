//
//  SettingsViewController.swift
//  ImageCutter
//
//  Created by Александра Среднева on 6.08.24.
//

import UIKit

class SettingsViewController: UIViewController {
    
    // MARK: - Properties
    
    private lazy var settingsTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(
            SettingsTableViewCell.self,
            forCellReuseIdentifier: String(describing: SettingsTableViewCell.self)
        )
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    private lazy var customNavigationBar: UINavigationBar = {
        let navbar = UINavigationBar()
        navbar.backgroundColor = .white
        navbar.isTranslucent = false
        return navbar
    }()
    
    private lazy var titleNavigationItem: UINavigationItem = {
        let navigationItem = UINavigationItem()
        navigationItem.title = LocalizedString.MainTabBar.settingsTitle
        return navigationItem
    }()
    
    private lazy var plusButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: .add,
                                     style: .plain,
                                     target: self,
                                     action: #selector(addRow)
        )
        return button
    }()
    
    private lazy var customAlert: UIAlertController = {
        let alert = CustomAlertController(
            title: LocalizedString.Settings.alertTitle,
            message: LocalizedString.Settings.alertMessage,
            actionTitle: LocalizedString.Settings.alertActionTitle
        )
        return alert
    }()
    
    private var viewModel: SettingsScreenViewModelProtocol?
        
    // MARK: - Override

    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = SettingsScreenViewModel()
        setUpView()
        addSubviews()
        setUpNavBar()
        setUpConstraints()
    }
    
    // MARK: - Private Methods
    
    private func setUpView() {
        view.backgroundColor = .white
    }
    
    private func addSubviews() {
        view.addSubview(settingsTableView)
        view.addSubview(customNavigationBar)
    }
    
    private func setUpNavBar() {
        titleNavigationItem.rightBarButtonItem = plusButton
        customNavigationBar.items = [titleNavigationItem]
    }
    
    private func setUpConstraints() {
        
        customNavigationBar.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        settingsTableView.snp.makeConstraints { make in
            make.top.equalTo(customNavigationBar.snp.bottom)
            make.bottom.trailing.leading.equalToSuperview()
        }
    }
    
    @objc private func addRow() {
        guard var viewModel = viewModel else {
            return
        }
        viewModel.performUpdate = {
            self.settingsTableView.performBatchUpdates({
                self.settingsTableView.insertRows(
                    at: [
                        IndexPath(
                            row: viewModel.getNumberOfRows() - 1,
                            section: 0)
                    ],
                    with: .automatic)
            }, completion: nil)
        }
        viewModel.addRow()
    }
}

// MARK: - Extension UITableViewDelegate

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewModel = viewModel else {
            return
        }
        present(customAlert, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - Extension UITableViewDataSource

extension SettingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.getNumberOfRows() ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SettingsTableViewCell.self)) as? SettingsTableViewCell else {
            return UITableViewCell()
        }
        return cell
    }
}
