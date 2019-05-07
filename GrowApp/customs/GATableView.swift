//
//  GATableView.swift
//  GrowApp
//
//  THIS CLASS TAKES CARE OF CREATING A CUSTOM TABLE VIEW
//
//  Created by Andrei on 05/02/2019.
//  Copyright © 2019 Andrei. All rights reserved.
//

import UIKit

class GATableView:UITableView {
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        backgroundColor = .cyan
        separatorStyle = .none 
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
