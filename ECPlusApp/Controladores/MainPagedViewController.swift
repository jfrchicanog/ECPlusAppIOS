//
//  MainPagedViewController.swift
//  ECPlusApp
//
//  Created by José Francisco Chicano García on 13/1/18.
//  Copyright © 2018 José Francisco Chicano García. All rights reserved.
//

import Foundation
import UIKit

class MainPagedViewController: UIPageViewController, UIPageViewControllerDataSource, UIGestureRecognizerDelegate {
    var paneles: [UIViewController] =  [];
    var transit: Bool = true
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
    
    override func viewDidLoad() {
        self.dataSource = self;
        
        gestureRecognizers.forEach({(gr) in
            gr.delegate = self
        })
        NSLog("GRs \(gestureRecognizers.count)")
        
        let sindromes = UIStoryboard(name: "Main", bundle: nil) .
            instantiateViewController(withIdentifier: "DocumentosViewController") as! UINavigationController;
        let sindViewController: (SindromeViewController) =
            (sindromes.topViewController as! SindromeViewController)
        sindViewController.tipoDocumento = .SINDROME;
        sindViewController.pageViewController = self
        
        let comunicacion = UIStoryboard(name: "Main", bundle: nil) .
            instantiateViewController(withIdentifier: "DocumentosViewController") as! UINavigationController;
        let comViewController: SindromeViewController = (comunicacion.topViewController as! SindromeViewController)
        comViewController.tipoDocumento = .GENERALIDAD;
        comViewController.pageViewController = self
        
        let palabras = UIStoryboard(name: "Main", bundle: nil) .
            instantiateViewController(withIdentifier: "PalabrasViewController") as! UINavigationController;
        (palabras.topViewController as! PalabraViewController).avanzadas = false;
        
        let avanzadas = UIStoryboard(name: "Main", bundle: nil) .
            instantiateViewController(withIdentifier: "PalabrasViewController") as! UINavigationController;
        (avanzadas.topViewController as! PalabraViewController).avanzadas = true;
        
        paneles = [palabras, avanzadas, sindromes, comunicacion];
        
        setViewControllers([palabras],
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
