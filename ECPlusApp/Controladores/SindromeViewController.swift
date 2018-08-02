//
//  SindromeViewController.swift
//  ECPlusApp
//
//  Created by José Francisco Chicano García on 25/10/17.
//  Copyright © 2017 José Francisco Chicano García. All rights reserved.
//

import Foundation
import UIKit

class SindromeViewController: UIViewController, UITableViewDataSource, UpdateServiceListener, UINavigationControllerDelegate {
    @IBOutlet weak var tabla: UITableView!
    let daoSindrome: DAOSindrome = DAOFactory.getDAOSindrome();
    
    var pageViewController : MainPagedViewController? = nil
    var elementos: [SindromeEntity] = []
    var tipoDocumento: TipoDocumento? = .GENERALIDAD
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.tabla.separatorStyle = .singleLine
        
        if elementos.count  == 0 {
            let label = UILabel(frame:
                CGRect(x: 0, y: 0, width: self.tabla.bounds.size.width, height: self.tabla.bounds.size.height))
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
        let listaSindromes = daoSindrome.getSyndromes(language: UserDefaults.standard.string(forKey: AppDelegate.LANGUAGE)!)
        elementos=listaSindromes.filter({$0.tipo == self.tipoDocumento!.rawValue});
        tabla.reloadData();
        NSLog("refresco")
    }
    
    func cargaDatos() {
        self.refrescarDatos()
    }
    
    override func viewDidLoad() {
        self.navigationController?.delegate = self
        
        if let tipo = self.tipoDocumento {
            switch (tipo) {
            case .GENERALIDAD:
                self.navigationItem.title = NSLocalizedString("CommunicationKind", comment: "Communication document")
            case .SINDROME:
                self.navigationItem.title = NSLocalizedString("SyndromeKind", comment: "Syndrome document")
            }
        }
        UpdateCoordinator.coordinator.addListener(listener: self)
        NotificationCenter.default.addObserver(forName: UserDefaults.didChangeNotification, object: nil, queue: OperationQueue.main, using: {notification in
            NSLog("Recibida actualización")
            self.refrescarDatos();
        })
        refrescarDatos();
    }
    
    func onUpdateEvent(event: UpdateEvent) {
        if event.action! == UpdateEventAction.stopGlobalUpdate {
            OperationQueue.main.addOperation({self.refrescarDatos()})
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let contentView = segue.destination as! SindromeContentView;
        let indexPath = tabla.indexPathForSelectedRow;
        tabla.deselectRow(at: indexPath!, animated: false);
        
        contentView.sindrome = elementos[(indexPath?.item)!];
    }
    
    func navigationController(_: UINavigationController, willShow: UIViewController, animated: Bool) {
        if (willShow == self) {
            pageViewController!.transit = true
            NSLog("main")
        } else {
            pageViewController!.transit = false
            NSLog("content")
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}
