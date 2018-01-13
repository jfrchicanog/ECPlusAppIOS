//
//  SindromeViewController.swift
//  ECPlusApp
//
//  Created by José Francisco Chicano García on 25/10/17.
//  Copyright © 2017 José Francisco Chicano García. All rights reserved.
//

import Foundation
import UIKit

class SindromeViewController: UIViewController, UITableViewDataSource {
    @IBOutlet weak var tabla: UITableView!
    let daoSindrome: DAOSindrome = DAOSindromeNetworkImpl();
    
    var elementos: [Sindrome] = []
    var tipoDocumento: TipoDocumento? = .GENERALIDAD
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return elementos.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sindrome", for: indexPath);
        cell.textLabel?.text = elementos[indexPath.item].nombre;
        return cell;
    }
    
    @IBAction func pulsado(_ sender: UIBarButtonItem) {
    }
    
    func cargaDatos() {
        daoSindrome.getSyndromes(language: "es", completion: { (listaSindromes:[Sindrome]) -> Void  in
            self.elementos=listaSindromes.filter({$0.tipo == self.tipoDocumento
            });
            OperationQueue.main.addOperation({
                self.tabla.reloadData();
            })
        })
        
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
        cargaDatos();
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let contentView = segue.destination as! SindromeContentView;
        let indexPath = tabla.indexPathForSelectedRow;
        tabla.deselectRow(at: indexPath!, animated: false);
        
        contentView.sindrome = elementos[(indexPath?.item)!];
    }
    
}
