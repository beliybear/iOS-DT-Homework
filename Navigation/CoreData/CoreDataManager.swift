//
//  CoreDataManager.swift
//  Navigation
//
//  Created by Ian Belyakov on 05.08.2023
//

import CoreData
import UIKit

class CoreDataManeger {
    
    static let defaulManager = CoreDataManeger()
    
    init() {
        reloadUsers()
//        reloadPosts()
    }
    
    lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "CoreData")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        container.viewContext.automaticallyMergesChangesFromParent = true
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
    
    // Users
    
    var user: User?
    var users: [User] = []
    func reloadUsers() {
        let fetchRequest = User.fetchRequest()
        users = (try? persistentContainer.viewContext.fetch(fetchRequest)) ?? []
    }
    
    func addUser(logIn: String, password: String, fullName: String, avatar: Data?) {
        
        persistentContainer.performBackgroundTask { contextBackground in
            let user = User(context: contextBackground)
            user.login = logIn
            user.password = password
            user.fullName = fullName
            user.dateCreated = Date()
            let image = UIImage(named: "addPhotoIcon")
            let imageData = image?.pngData()
            if let imageData {
                user.avatar = imageData
            } else {
                user.avatar = avatar
            }
            user.isLogIn = true
            user.lastAutorizationDate = Date()
            
            do {
                try contextBackground.save()
            } catch {
                print(error)
            }
        }
    }
    
    func subscribe(aotorizedUser: User, subscribedUser: User) {
//        aotorizedUser.subscrabedUser = subscribedUser
    }
    
    func updateUserStatus(user: User, newStatus: String?) {
        user.status = newStatus
        
        do {
            try user.managedObjectContext?.save()
        } catch {
            print(error)
        }
    }
    
    func updateUserAvatar(user: User, imageData: Data?) {
        user.avatar = imageData
        
        do {
            try user.managedObjectContext?.save()
        } catch {
            print(error)
        }
    }
    
    func deleteUser(user: User) {
        persistentContainer.viewContext.delete(user)
        try? persistentContainer.viewContext.save()
    }
    
    // Posts
    
    var posts: [Post] = []
    func reloadPosts() {
        let fetchRequest = Post.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "dateCreated", ascending: false)]
        posts = (try? persistentContainer.viewContext.fetch(fetchRequest)) ?? []
    }
    
    func addPost(text: String, image: Data?, for user: User) {
        persistentContainer.performBackgroundTask { contextBackground in
            let post = Post(context: contextBackground)
            post.author = user.fullName
            post.text = text
            post.image = image
            
            post.user = self.getUser(login: user.login!, context: contextBackground)
            
            do {
                try contextBackground.save()
            } catch {
                print(error)
            }
        }
    }
    
    func getUser(login: String, context: NSManagedObjectContext) -> User? {
        let fetchRequest = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "login == %@", login)
        return (try? context.fetch(fetchRequest))?.first
    }
    
    func isAuthorOfPost(post: Post, user: User) -> Bool {
        return post.author == user.fullName
    }
    
    func updatePost(post: Post, newText: String, imageData: Data?) {
        post.text = newText
        if let imageData {
            post.image = imageData
        }
        
        do {
            try post.managedObjectContext?.save()
        } catch {
            print(error)
        }
    }
    
    func favoritePost(post: Post, isFavorite: Bool) {
        post.isFavorite = isFavorite
        if isFavorite {
            post.likes += 1
        } else {
            post.likes -= 1
        }
        
        do {
            try post.managedObjectContext?.save()
        } catch {
            print(error)
        }
    }
    
    func deletePost(post: Post) {
        persistentContainer.viewContext.delete(post)
        try? persistentContainer.viewContext.save()
    }
    
    func getPost(author: String, context: NSManagedObjectContext) -> Post? {
        let fetchRequest = Post.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "author == %@", author)
        return try? context.fetch(fetchRequest).first
    }
    
    // Likes

    func addLike(user: User, post: Post) {
       persistentContainer.performBackgroundTask { contextBackground in
           let like = Like(context: contextBackground)
           like.dateCreated = Date()
           like.user = self.getUser(login: user.login!, context: contextBackground)
           like.post = self.getPost(author: post.author!, context: contextBackground)

          do {
             try contextBackground.save()
          } catch {
             print(error)
          }
       }
    }

    func removeLike(like: Like) {
        persistentContainer.viewContext.delete(like)
        try? persistentContainer.viewContext.save()
    }

    func isLiked(post: Post, by user: User) -> Bool {
        return getLike(post: post, by: user) != nil
    }
    
    func getLike(post: Post, by user: User) -> Like? {
        let fetchRequest = Like.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "post == %@ AND user == %@", post, user)
        return try? persistentContainer.viewContext.fetch(fetchRequest).first
    }
    
    
    // Authorization
    
    func authorization(user: User) {
        user.isLogIn = true
        user.lastAutorizationDate = Date()
        do {
            try user.managedObjectContext?.save()
        } catch {
            print(error)
        }
    }
    
    func deauthorization(user: User) {
        user.isLogIn = false
        
        do {
            try user.managedObjectContext?.save()
        } catch {
            print(error)
        }
    }
    
    // Subscribe
    
    // Добавление подписки на пользователя
    func addSubscription(authorizedUser: User, subscriptionUser: User) {
        persistentContainer.performBackgroundTask { contextBackground in
            let subscription = Subscription(context: contextBackground)
            let contextBackgroundSubscriptionUser = self.getUser(login: subscriptionUser.login ?? "", context: contextBackground)
            let contextBackgroundAuthorizedUser = self.getUser(login: authorizedUser.login ?? "", context: contextBackground)
            subscription.login = contextBackgroundSubscriptionUser?.login
            subscription.dateCreated = Date()
            subscription.user = contextBackgroundAuthorizedUser
            
            do {
                try contextBackground.save()
            } catch {
                print(error)
            }
        }
    }
    // Добавление подписчика
    func addSubscriber(authorizedUser: User, subscriberUser: User) {
        persistentContainer.performBackgroundTask { contextBackground in
            let subscriber = Subscriber(context: contextBackground)
            let contextBackgroundSubscriberUser = self.getUser(login: subscriberUser.login ?? "", context: contextBackground)
            let contextBackgroundAuthorizedUser = self.getUser(login: authorizedUser.login ?? "", context: contextBackground)
            subscriber.login = contextBackgroundAuthorizedUser?.login
            subscriber.user = contextBackgroundSubscriberUser
            
            do {
                try contextBackground.save()
            } catch {
                print(error)
            }
        }
    }
    
    // Photos
    
    func saveUserImage(user: User, image: UIImage) {
        let imageData = image.jpegData(compressionQuality: 1.0)
        updateUserAvatar(user: user, imageData: imageData)
    }
    
}

extension User {
    var postsSorted: [Post] {
        posts?.sortedArray(using: [NSSortDescriptor(key: "dateCreated", ascending: false)]) as? [Post] ?? []
    }
}

extension Post {
    var likess: [Like] {
        like?.sortedArray(using: [NSSortDescriptor(key: "dateCreated", ascending: false)]) as? [Like] ?? []
    }
}

extension User {
    var images: [UIImage] {
        set {
            let imageDatas = newValue.map { $0.jpegData(compressionQuality: 1.0) }
            imagesData = NSKeyedArchiver.archivedData(withRootObject: imageDatas)
        }
        get {
            guard let imagesData = imagesData,
                  let imageDatas = NSKeyedUnarchiver.unarchiveObject(with: imagesData) as? [Data]
            else {
                return [UIImage(systemName: "camera") ?? UIImage()]
            }
            return imageDatas.compactMap { UIImage(data: $0) }
        }
    }
}
