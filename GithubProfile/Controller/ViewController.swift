//
//  ViewController.swift
//  GithubProfile
//
//  Created by 김정호 on 4/12/24.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - properties
    @IBOutlet weak var tableView: UITableView!
    
    private let networkManager = NetworkManager()
    
    private var profile: ProfileDTO?
    private var repositories = [RepositoryDTO]()
    
    private var name = "ohhoooo"
    private var isLoadingLast = false
    private var page = 1

    // MARK: - life cycles
    override func viewDidLoad() {
        super.viewDidLoad()

        setDatas()
        setTableView()
        setRefreshControl()
    }

    // MARK: - methods
    private func setDatas() {
        fetchProfile()
        fetchRepository()
    }
    
    func fetchProfile() {
        networkManager.fetchUserProfile(userName: name) { [weak self] result in
            switch result {
            case .success(let profile):
                self?.profile = profile
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchRepository() {
        networkManager.fetchUserRepositories(userName: name, page: page) { [weak self] result in
            switch result {
            case .success(let repositories):
                self?.repositories += repositories
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    private func setTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.register(ProfileTableViewCell.self, forCellReuseIdentifier: "ProfileTableViewCell")
        self.tableView.register(UINib(nibName: "RepositoryTableViewCell", bundle: nil), forCellReuseIdentifier: "RepositoryTableViewCell")
    }
    
    private func setRefreshControl() {
        self.tableView.refreshControl = UIRefreshControl()
        self.tableView.refreshControl?.addTarget(self, action: #selector(refreshTableView), for: .valueChanged)
    }
    
    @objc private func refreshTableView() {
        setDatas()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) { [weak self] in
            self?.tableView.refreshControl?.endRefreshing()
        }
    }
    
    private func loadMoreRepositories() {
        if isLoadingLast == true {
            return
        }
        
        page += 1
        
        // 프로젝트의 개수가 부족하여 다른 것으로 대체
        networkManager.fetchUserRepositories(userName: "al45tair", page: page) { [weak self] result in
            switch result {
            case .success(let repositories):
                if repositories.isEmpty == true {
                    self?.isLoadingLast = true
                    return
                }
                self?.repositories += repositories
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (indexPath.section == 0) ? 140 : 90
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == 1 && indexPath.row == repositories.count - 1 {
            loadMoreRepositories()
        }
    }
}

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (section == 0) ? 1 : repositories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableViewCell", for: indexPath) as? ProfileTableViewCell else { return UITableViewCell() }
            
            cell.bind(profile: profile)
            
            return cell
        } else if indexPath.section == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "RepositoryTableViewCell", for: indexPath) as? RepositoryTableViewCell else { return UITableViewCell() }
            
            cell.bind(repository: repositories[indexPath.row])
            
            return cell
        }
        
        return UITableViewCell()
    }
}
