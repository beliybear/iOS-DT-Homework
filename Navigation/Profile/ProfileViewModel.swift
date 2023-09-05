import Foundation
import UIKit

protocol ProfileViewModelProtocol: ViewModelProtocol {
    var onStateDidChange: ((ProfileViewModel.State) -> Void)? { get set }
    func updateState(viewInput: ProfileViewModel.ViewInput)
}

final class ProfileViewModel: ProfileViewModelProtocol {
    enum State {
        case waiting
        case setStatus(String)
        case newPost
        case setImage(UIImage)
        case tableViewCellPressed
    }

    enum ViewInput {
        case setStatus(status: String, user: User)
        case newPost
        case setImage(image: UIImage)
        case tableViewCellPressed
        case likePost(post: Post)
        case subscribe(authorizedUser: User, subscriptionUser: User)
    }
    
    var onStateDidChange: ((State) -> Void)?
    private var biometricIDAuth = BiometricIDAuth()

    private(set) var state: State = .waiting {
        didSet {
            onStateDidChange?(state)
        }
    }

    func updateState(viewInput: ViewInput) {
        switch viewInput {

        case let .setStatus(status, user):
            CoreDataManeger.defaulManager.updateUserStatus(user: user, newStatus: status)
        case .newPost:
            ()
        case .setImage:
            ()
        case .tableViewCellPressed:
            ()
        case let .likePost(post):
            guard let currentUser = CoreDataManeger.defaulManager.user else {
                return
            }
        
            if CoreDataManeger.defaulManager.isLiked(post: post, by: currentUser) {
                if let like = CoreDataManeger.defaulManager.getLike(post: post, by: currentUser) {
                    CoreDataManeger.defaulManager.removeLike(like: like)
                    post.likes -= 1
                }
                
            } else {
                CoreDataManeger.defaulManager.addLike(user: currentUser, post: post)
                post.likes += 1
            }
        case let .subscribe(authorizedUser, subscriptionUser):
            CoreDataManeger.defaulManager.addSubscription(authorizedUser: authorizedUser, subscriptionUser: subscriptionUser)
            CoreDataManeger.defaulManager.addSubscriber(authorizedUser: subscriptionUser, subscriberUser: authorizedUser)
        }
        
    }
}
