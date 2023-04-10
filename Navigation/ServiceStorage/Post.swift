//
//  Post.swift
//  Navigation
//
//  Created by Beliy.Bear on 15.12.2022.
//

import Foundation

public struct Post{
    public var author: String
    public var descriptionText: String
    public var image: String
    public var likes: Int
    public var views: Int
    
    public init (author: String, descriptionText: String, image: String, likes: Int, views: Int) {
            self.author = author
            self.descriptionText = descriptionText
            self.image = image
            self.likes = likes
            self.views = views
        }
    
}

public let Posts = [
    Post(author: "BeliyBear", descriptionText: "The one of first student, who took the exam first time", image: "avatarImage", likes: 110, views: 130),
    Post(author: "BeliyBear", descriptionText: "Wanna learn something new? Wanna be a programmer, marketing specialist? Learn in Netology!", image: "netology", likes: 235, views: 235),
    Post(author: "BeliyBear", descriptionText: "Oblomoff, Russian Youtuber, published a shawarma review video»", image: "oblomoff", likes: 182, views: 501),
]
