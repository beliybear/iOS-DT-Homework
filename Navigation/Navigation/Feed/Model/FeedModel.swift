//
//  FeedModel.swift
//  Navigation
//
//  Created by Beliy.Bear on 11.03.2023.
//

import Foundation

protocol FeedViewDelegate: AnyObject {
    func infoButtonPressed()
    func postButtonPressed()
}

protocol FeedViewModelProtocol {
    func buttonPressed(viewInput: FeedViewModel.ViewInput)
}

class FeedViewModel: FeedViewModelProtocol {
    
    enum ViewInput {
        case postButtonPressed
        case infoButtonPressed
    }
    
    weak var coordinator: FeedCoordinator?
    var secretWord = "alpha"
    
    func buttonPressed(viewInput: ViewInput) {
        switch viewInput {
        case .postButtonPressed:
            coordinator?.pushPostViewController()
        case .infoButtonPressed:
            coordinator?.pushInfoViewController()
        }
    }
}
    
class FeedModel {
    
    private weak var delegate: FeedViewDelegate?
    
    var secretWord = "password"
    
    func check(_ word: String) -> Bool {
        return word == secretWord
    }
    
    func infoButtonPressed() {
        delegate?.infoButtonPressed()
    }
    
    func postButtonPressed() {
        delegate?.postButtonPressed()
    }
}
