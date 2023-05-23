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

    private func fetchLikedPosts() {
        let context = CoreDataStack.shared.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<LikedPost> = LikedPost.fetchRequest()
        do {
            likedPosts = try context.fetch(fetchRequest)
            tableView.reloadData()
        } catch {
            print("Failed to fetch liked posts: \(error)")
        }
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
            views: Int(likedPost.views)
        )
 cell.setup(with: viewModel)
        return cell
    }
}