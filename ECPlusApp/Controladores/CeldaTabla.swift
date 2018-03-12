//
//  CeldaTabla.swift
//  ECPlusApp
//
//  Created by José Francisco Chicano García on 11/3/18.
//  Copyright © 2018 José Francisco Chicano García. All rights reserved.
//

import Foundation
import UIKit

class CeldaTabla : UITableViewCell {
    override func layoutSubviews() {
        super.layoutSubviews()
        self.imageView?.frame = CGRect(x: 15, y: 0, width: 45, height: 45)
        self.textLabel?.frame.origin = CGPoint(x: 60, y: 0)
        
    }
}
