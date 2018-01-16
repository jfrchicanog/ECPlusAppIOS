//
//  SindromeViewController.swift
//  ECPlusApp
//
//  Created by José Francisco Chicano García on 25/10/17.
//  Copyright © 2017 José Francisco Chicano García. All rights reserved.
//

import Foundation
import UIKit

class SindromeViewController: UIViewController, UITableViewDataSource, UpdateServiceListener {
    @IBOutlet weak var tabla: UITableView!
    let daoSindrome: DAOSindrome = DAOFactory.getDAOSindrome();
    
    var elementos: [SindromeEntity] = []
    var tipoDocumento: TipoDocumento? = .GENERALIDAD
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        NSLog("cuenta \(elementos.count)")
        return elementos.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sindrome", for: indexPath);
        cell.textLabel?.text = elementos[indexPath.item].nombre;
        return cell;
    }
    
    @IBAction func pulsado(_ sender: UIBarButtonItem) {
    }
    
    func refrescarDatos() {
        let listaSindromes = daoSindrome.getSyndromes(language: "es")
        elementos=listaSindromes.filter({$0.tipo == self.tipoDocumento!.rawValue});
        tabla.reloadData();
        NSLog("refresco")
    }
    
    func cargaDatos() {
        self.refrescarDatos()

        if let hash = daoSindrome.getHashForListOfSyndromes(language: "es") {
            NSLog(hash);
        }
                
        let fm = FileManager.default;
        let url = fm.urls(for: .documentDirectory, in: .allDomainsMask)
        NSLog("URL: " + url.last!.description)
    }
    
    override func viewDidLoad() {
        if let tipo = self.tipoDocumento {
            switch (tipo) {
            case .GENERALIDAD:
                self.navigationItem.title = "Comunicación"
            case .SINDROME:
                self.navigationItem.title = "Síndrome"
            }
        }
        UpdateCoordinator.coordinator.addListener(listener: self)
        refrescarDatos();
    }
    
    func onUpdateEvent(event update: UpdateEvent) {
        NSLog(update.description())
        if update.action! == UpdateEventAction.stopDatabase && update.somethingChanged! {
            NSLog("Here I am")
            OperationQueue.main.addOperation({self.refrescarDatos()})
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let contentView = segue.destination as! SindromeContentView;
        let indexPath = tabla.indexPathForSelectedRow;
        tabla.deselectRow(at: indexPath!, animated: false);
        
        contentView.sindrome = elementos[(indexPath?.item)!];
    }
    
}
