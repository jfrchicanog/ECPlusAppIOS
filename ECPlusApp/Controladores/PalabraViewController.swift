//
//  PalabraViewController.swift
//  ECPlusApp
//
//  Created by José Francisco Chicano García on 11/2/18.
//  Copyright © 2018 José Francisco Chicano García. All rights reserved.
//

import Foundation
import UIKit

class PalabraViewController : UIViewController, UITableViewDataSource, UpdateServiceListener {
    let daoPalabra: DAOPalabra = DAOFactory.getDAOPalabra()
    var elementos : [PalabraEntity] = []
    var avanzadas : Bool = false
    var gestureRecognizers: [UIGestureRecognizer] = []
    @IBOutlet weak var tabla: UITableView!
    
    func onUpdateEvent(event: UpdateEvent) {
        if event.action! == UpdateEventAction.stopGlobalUpdate {
            OperationQueue.main.addOperation({self.refrescarDatos()})
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.tabla.separatorStyle = .singleLine
        
        if elementos.count  == 0 {
            let label = UILabel(frame:
                CGRect(x: 0, y: 0, width: self.tabla.bounds.size.width * 0.8, height: self.tabla.bounds.size.height))
            label.text = UpdateCoordinator.coordinator.isThereNetworkActivity() ?
                NSLocalizedString("Downloading", comment: "Message for tables when data is downloading"):
                NSLocalizedString("NoItemsForLanguage", comment: "Message for tables when there are no items to show");
            
            label.textAlignment = .center
            label.sizeToFit()
            label.lineBreakMode = .byWordWrapping
            label.numberOfLines = 0
            self.tabla.backgroundView = label
            self.tabla.separatorStyle = .none
        } else {
            self.tabla.backgroundView = nil
        }
        
        return elementos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "palabra", for: indexPath);
        let palabra = elementos[indexPath.item]
        cell.textLabel?.text = palabra.nombre;
        if let logo = WordsUtility.getLogoFromWord(palabra: palabra) {
            cell.imageView?.image = logo
        } else {
            cell.imageView?.image = UIImage(named: "logo")
        }
        return cell;
    }

    func refrescarDatos() {
        let listaPalabras = daoPalabra.getWords(language: UserDefaults.standard.string(forKey: AppDelegate.LANGUAGE)!, resolution: Resolution.baja)
        elementos=listaPalabras.filter({$0.avanzada == self.avanzadas}).sorted(by: {$0.nombre! < $1.nombre!});
        WordsUtility.preloadPictograms(palabras: elementos)
        tabla.reloadData();
    }
    
    override func viewDidLoad() {
        if avanzadas {
            self.navigationItem.title = NSLocalizedString("AdvancedWords", comment: "Advances words title")
        } else {
            self.navigationItem.title = NSLocalizedString("RegularWords", comment: "Regular Words title")
        }
        UpdateCoordinator.coordinator.addListener(listener: self)
        NotificationCenter.default.addObserver(forName: UserDefaults.didChangeNotification, object: nil, queue: OperationQueue.main, using: {notification in
            WordsUtility.clearCache()
            self.refrescarDatos();
        })
        refrescarDatos();
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let contentView = segue.destination as! PalabraContentView;
        let indexPath = tabla.indexPathForSelectedRow;
        tabla.deselectRow(at: indexPath!, animated: false);
        
        contentView.palabra = elementos[(indexPath?.item)!];
    }
    
    
}
