//
//  CoreDataStack.swift
//  Navigation
//
//  Created by Beliy.Bear on 23.05.2023.
//

import Foundation
import CoreData

class CoreDataStack {
    
    static let shared = CoreDataStack()
    
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "LikedPostsModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func saveLikedPost(viewPost: PostTableViewCell.ViewPost, postId: String) {
        let context = persistentContainer.viewContext
        let likedPost = NSEntityDescription.insertNewObject(forEntityName: "LikedPost", into: context) as! LikedPost
        likedPost.postId = postId
        likedPost.author = viewPost.author
        likedPost.descriptionText = viewPost.descriptionText
        likedPost.imageData = viewPost.image.jpegData(compressionQuality: 1.0)
        likedPost.likes = Int32(viewPost.likes)
        likedPost.views = Int32(viewPost.views)
        saveContext()
    }
    
    func fetchLikedPosts() -> [LikedPost] {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<LikedPost> = LikedPost.fetchRequest()
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch liked posts: \(error)")
            return []
        }
    }
    
    func isPostLiked(postId: String) -> Bool {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<LikedPost> = LikedPost.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "postId == %@", postId)
        do {
            let result = try context.fetch(fetchRequest)
            return !result.isEmpty
        } catch {
            print("Failed to check if post is liked: \(error)")
            return false
        }
    }
}
