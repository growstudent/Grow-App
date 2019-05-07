//
//  GALabelCustom.swift
//  GrowApp
//
// THIS CLASS IS FOR CREATING CUSTOM LABELS IN THE APPLICATION
//
//  Created by Andrei on 06/01/2019.
//  Copyright © 2019 Andrei. All rights reserved.
//

import UIKit

class GALabel:UILabel {
    init(title:String = "default title", frame:CGRect = .zero, color:UIColor = .white, size:CGFloat = 20, textAlignment:NSTextAlignment = .center) {
        super.init(frame: frame)
        
            if frame == .zero { self.translatesAutoresizingMaskIntoConstraints = false }
        
            self.text = title
            self.textColor = color
            self.font = self.font.withSize(size)
            self.textAlignment = textAlignment
            self.font = UIFont.init(name: "Raleway-v4020-Black", size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
