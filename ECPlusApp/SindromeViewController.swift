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
    
    var elementos: [Sindrome] = [];
    
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
    
    func descarga() {
        var peticion = URLRequest(url: NSURL(string: "https://ecplusproject.uma.es/academicPortal/ecplus/api/v1/sindromes/es")! as URL)
        
        peticion.addValue("application/json", forHTTPHeaderField: "Accept");
        peticion.httpMethod="GET"
        
        let session = URLSession.shared;
        let dataTask = session.dataTask(with: peticion, completionHandler:
        {(datos: Data?, respuesta: URLResponse?, error: Error?) in
            
            let object = try! JSONSerialization.jsonObject(with: datos!)
            
            let lista = object as! NSArray;
            for elemento in lista {
                let diccionario = elemento as! NSDictionary;
                self.elementos.append(Sindrome(jsonDictionary: diccionario));
            }
            
            OperationQueue.main.addOperation({
                self.tabla.reloadData();
            })
        })
        dataTask.resume();
    }
    
    override func viewDidLoad() {
        descarga();
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let contentView = segue.destination as! SindromeContentView;
        let indexPath = tabla.indexPathForSelectedRow;
        tabla.deselectRow(at: indexPath!, animated: false);
        
        contentView.sindrome = elementos[(indexPath?.item)!];
    }
    
}
