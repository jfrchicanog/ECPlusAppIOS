//
//  LargeImage.swift
//  ECPlusApp
//
//  Created by José Francisco Chicano García on 9/3/18.
//  Copyright © 2018 José Francisco Chicano García. All rights reserved.
//

import Foundation
import UIKit

class LargeImageViewController : UIViewController {
    var image : UIImage? = nil
    @IBOutlet weak var uiImage: UIImageView!
    
    override func viewDidLoad() {
        uiImage.image = image
    }
    
    @IBAction func imagenTocada(_ sender: UITapGestureRecognizer) {
        self.dismiss(animated: true)
    }
    
}
