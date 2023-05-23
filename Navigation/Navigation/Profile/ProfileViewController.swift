import UIKit
import ServiceStorage
import FirebaseAuth

class ProfileViewController: UIViewController {
    var user: User?
    var currentUser = User(login: "0000", name: "BeliyBear", avatar: UIImage(named: "avatarImage")!, status: "Something...")
    let photoCoordinator: PhotoCoordinator
    let profileViewModel: ProfileViewModel
    
    init(photoCoordinator: PhotoCoordinator, profileViewModel: ProfileViewModel) {
        self.photoCoordinator = photoCoordinator
        self.profileViewModel = profileViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        profileViewModel.setUser()
        profileViewModel.setPosts()
        setupTableView()
        #if DEBUG
        view.backgroundColor = .systemBlue
        #else
        view.backgroundColor = .white
        #endif

        let signOutButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(pushSignOutButton))
        navigationItem.leftBarButtonItem = signOutButton
    }
    
    private func setupTableView() {
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: "PostTableViewCell")
        tableView.register(ProfileHeaderView.self, forHeaderFooterViewReuseIdentifier: "ProfileHeaderView")
        tableView.register(PhotosTableViewCell.self, forCellReuseIdentifier: "PhotosTableViewCell")
        
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    @objc func pushSignOutButton(){
        try? Auth.auth().signOut()
        navigationController?.popViewController(animated: true)
    }
}

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        if section == 1 {
            return profileViewModel.postsData.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PhotosTableViewCell", for: indexPath) as? PhotosTableViewCell else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)
                return cell
            }
            return cell
        }
        if indexPath.section == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostTableViewCell", for: indexPath) as? PostTableViewCell else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)
                return cell
            }
            let post = self.profileViewModel.postsData[indexPath.row]
            let viewModel = PostTableViewCell.ViewPost(author: post.author, descriptionText: post.descriptionText, image: UIImage(named: post.image)!, likes: post.likes, views: post.views)
            cell.setup(with: viewModel)
            return cell
        }
        return tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)
    }
    
    func tableView (_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ProfileHeaderView") as? ProfileHeaderView else {
                return nil
            }
            headerView.avatarImageView.image = currentUser.avatar
            headerView.fullNameLabel.text = currentUser.name
            headerView.statusLabel.text = currentUser.status
            headerView.contentView.backgroundColor = .white
            return headerView
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0, indexPath.row == 0 {
            return 160
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            photoCoordinator.startView()
        }
    }
}
