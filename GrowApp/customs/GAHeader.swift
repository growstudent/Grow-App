//
//  GDHeader.swift
//  GrowApp
//
//  THIS CLASS IS FOR CREATING CUSTOM HEADERS
//
//  Created by Andrei on 07/02/2019.
//  Copyright © 2019 Andrei. All rights reserved.
//

import UIKit

class GAHeader:UIView {
    
    init(frame: CGRect = .zero, title:String = "header", color: UIColor = .black, radius:CGFloat = 0) {
        super.init(frame:frame)
        if frame == .zero {
            translatesAutoresizingMaskIntoConstraints = false;
        }
        backgroundColor = color
        layer.cornerRadius = radius
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
