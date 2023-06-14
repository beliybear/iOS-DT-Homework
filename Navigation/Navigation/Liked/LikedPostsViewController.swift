//
//  LikedViewController.swift
//  Navigation
//
//  Created by Beliy.Bear on 23.05.2023.
//

import UIKit
import CoreData

class LikedPostsViewController: UITableViewController {
    
    private var likedPosts: [LikedPost] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: "PostTableViewCell")
        fetchLikedPosts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchLikedPosts()
    }
    
    private func fetchLikedPosts() {
        likedPosts = CoreDataStack.shared.fetchLikedPosts()
        tableView.reloadData()
    }

    // MARK: - UITableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return likedPosts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostTableViewCell", for: indexPath) as? PostTableViewCell else {
            return UITableViewCell()
        }
        let likedPost = likedPosts[indexPath.row]
        let viewModel = PostTableViewCell.ViewPost(
            author: likedPost.author ?? "",
            descriptionText: likedPost.descriptionText ?? "",
            image: UIImage(data: likedPost.imageData!)!,
            likes: Int(likedPost.likes),
            views: Int(likedPost.views),
            postId: String(likedPost.postId!)
        )
        cell.setup(with: viewModel)
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let likedPost = likedPosts[indexPath.row]
            CoreDataStack.shared.deleteLikedPost(likedPost: likedPost)
            likedPosts.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
