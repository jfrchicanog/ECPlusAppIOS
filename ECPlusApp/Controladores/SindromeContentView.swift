//
//  SindromeContentView.swift
//  ECPlusApp
//
//  Created by José Francisco Chicano García on 26/10/17.
//  Copyright © 2017 José Francisco Chicano García. All rights reserved.
//

import Foundation
import UIKit

class SindromeContentView: UIViewController {
    @IBOutlet weak var webView: UIWebView!;
    var sindrome: SindromeEntity?;
    
    override func viewDidLoad() {
        /*let url = NSURL (string: "https://www.uma.es");
        let request = URLRequest(url: url! as URL);
        webView.loadRequest(request);*/
        if (sindrome != nil) {
            webView.loadHTMLString((sindrome?.contenido!)!, baseURL: nil);
        }
    }
}
