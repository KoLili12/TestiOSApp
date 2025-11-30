//
//  MainViewController.swift
//  TestiOSApp
//
//  Created by Николай Жирнов on 28.11.2025.
//

import UIKit
import Kingfisher

final class MainViewController: UIViewController {
    private let viewModel: ViewModel
    
    // MARK: - UI components
    
    private lazy var activityIndicator: UIActivityIndicatorView =  {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .gray
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private lazy var userTableView: UITableView = {
        let tableView = UITableView()
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UserTableViewCell.self, forCellReuseIdentifier: UserTableViewCell.identifier)
        return tableView
    }()
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        binding()
        viewModel.loadItems()
    }
    
    // MARK: - Connect viewModel and ViewController via binding
    
    func binding() {
        viewModel.onDataLoaded = { [weak self] _ in
            self?.userTableView.refreshControl?.endRefreshing()
            self?.userTableView.reloadData()
        }
        viewModel.onLoadingChanged = { [weak self] isLoad in
            if isLoad && !(self?.userTableView.refreshControl?.isRefreshing ?? false) {
                self?.showLoading()
            }
            if !isLoad {
                self?.hideLoading()
            }
        }
        viewModel.onError = { [weak self] error in
            self?.presentAlert()
        }
    }
    
    func setupUI() {
        self.navigationItem.title = "Тестовое задание"
        
        view.backgroundColor = .white
        
        view.addSubview(userTableView)
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            userTableView.topAnchor.constraint(equalTo: view.topAnchor),
            userTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            userTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            userTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func showLoading() {
        activityIndicator.startAnimating()
    }
    
    func hideLoading() {
        activityIndicator.stopAnimating()
    }
    
    // MARK: - Alert for error handling
    
    func presentAlert() {
        let alert = UIAlertController(title: "Ошибка", message: "Данные не загружены", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Повторить загрузку", style: .default, handler: { [weak self] _ in
            self?.viewModel.loadItems()
        }))
        
        alert.addAction(UIAlertAction(title: "Продолжить работу в автономном режиме", style: .cancel, handler: { [weak self] _ in
            self?.viewModel.loadItemsFromCoreData()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func handleRefreshControl() {
        viewModel.loadItems()
    }
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.identifier, for: indexPath) as? UserTableViewCell
        
        guard let cell else { return UITableViewCell() }
        
        cell.avatar.kf.setImage(with: Endpoint.avatar(id: indexPath.row).url)
        cell.body.text = viewModel.items[indexPath.row].body
        cell.title.text = viewModel.items[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        200
    }
}
