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
    var elementos : [PalabraEntity] = []
    var avanzadas : Bool = false
    let daoPalabra: DAOPalabra = DAOFactory.getDAOPalabra()
    @IBOutlet weak var tabla: UITableView!
    
    func onUpdateEvent(event: UpdateEvent) {
        if event.action! == UpdateEventAction.stopDatabase && event.somethingChanged! {
            NSLog("Here I am")
            OperationQueue.main.addOperation({self.refrescarDatos()})
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return elementos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "palabra", for: indexPath);
        cell.textLabel?.text = elementos[indexPath.item].nombre;
        return cell;
    }
    
    func refrescarDatos() {
        let listaPalabras = daoPalabra.getWords(language: "es", resolution: Resolution.baja)
        elementos=listaPalabras.filter({$0.avanzada == self.avanzadas}).sorted(by: {$0.nombre! < $1.nombre!});
        tabla.reloadData();
        NSLog("refresco")
    }
    
    override func viewDidLoad() {
        if avanzadas {
            self.navigationItem.title = "Avanzadas"
        } else {
            self.navigationItem.title = "Palabras"
        }
        UpdateCoordinator.coordinator.addListener(listener: self)
        refrescarDatos();
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let contentView = segue.destination as! PalabraContentView;
        let indexPath = tabla.indexPathForSelectedRow;
        tabla.deselectRow(at: indexPath!, animated: false);
        
        contentView.palabra = elementos[(indexPath?.item)!];
    }
    
    
}
