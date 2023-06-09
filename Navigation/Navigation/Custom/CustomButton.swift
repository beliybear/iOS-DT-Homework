//
//  CustomButton.swift
//  Navigation
//
//  Created by Beliy.Bear on 11.03.2023.
//

import UIKit

class CustomButton: UIButton {

    var title: String?
    var cornerRadius: CGFloat?
    var titleColor: UIColor?
    var color: UIColor?
    var target: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    convenience  init (title: String, cornerRadius: CGFloat?, titleColor: UIColor?, color: UIColor?) {
        self.init(type: .custom)
        self.title = title
        self.cornerRadius = cornerRadius
        self.titleColor = titleColor
        self.color = color
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup() {
        layer.cornerRadius = cornerRadius ?? 0
        setTitle(NSLocalizedString(title!, comment: ""), for: .normal)
        setTitleColor(titleColor, for: .normal)
        backgroundColor = color
    }

}
