//
//  MainPagedViewController.swift
//  ECPlusApp
//
//  Created by José Francisco Chicano García on 13/1/18.
//  Copyright © 2018 José Francisco Chicano García. All rights reserved.
//

import Foundation
import UIKit

class MainPagedViewController: UIPageViewController, UIPageViewControllerDataSource {
    var paneles: [UIViewController] =  [];
    
    override func viewDidLoad() {
        self.dataSource = self;
        
        let sindromes = UIStoryboard(name: "Main", bundle: nil) .
            instantiateViewController(withIdentifier: "DocumentosViewController") as! UINavigationController;
        // Seguramente el topViewController no exista aún y por eso falla esta parte.
        (sindromes.topViewController as! SindromeViewController).tipoDocumento = .SINDROME;
        
        let comunicacion = UIStoryboard(name: "Main", bundle: nil) .
            instantiateViewController(withIdentifier: "DocumentosViewController") as! UINavigationController;
        (comunicacion.topViewController as! SindromeViewController).tipoDocumento = .GENERALIDAD;
        
        paneles = [sindromes, comunicacion];
        
        setViewControllers([sindromes],
                           direction: .forward,
                           animated: true,
                           completion: nil)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let index = paneles.index(of: viewController) {
            
            if (index == 0) {
                return nil;
            } else {
                return paneles[index-1]
            }
        } else {
            return nil;
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let index = paneles.index(of: viewController) {
            if (index >= paneles.count-1) {
                return nil;
            } else {
                return paneles[index+1]
            }
        } else {
            return nil;
        }
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return paneles.count;
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let firstViewController = pageViewController.viewControllers?.first,
            let firstViewControllerIndex = paneles.index(of: firstViewController) else {
                return 0
        }
        return firstViewControllerIndex;
    }
}
