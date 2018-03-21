//
//  PictogramVewController.swift
//  ECPlusApp
//
//  Created by José Francisco Chicano García on 12/3/18.
//  Copyright © 2018 José Francisco Chicano García. All rights reserved.
//

import Foundation
import SVGKit

class PictogramViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UpdateServiceListener {
    func onUpdateEvent(event: UpdateEvent) {
        if event.action! == UpdateEventAction.stopDatabase && event.somethingChanged! {
            NSLog("Here I am")
            OperationQueue.main.addOperation({self.refrescarDatos()})
        }
    }
    
    let daoPalabra: DAOPalabra = DAOFactory.getDAOPalabra()
    let resourceCache = PictogramCache.pictogramCache
    let resourceStore = ResourceStore.resourceStore
    var elementos : [PalabraEntity] = []
    
    @IBOutlet var collectionView: UICollectionView!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return elementos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pictograma", for: indexPath);
        let palabra = elementos[indexPath.item]
        let imageView = (cell.viewWithTag(1) as? UIImageView)
        imageView?.contentMode = .scaleAspectFit
        imageView?.image = WordsUtility.getLogoFromWord(palabra: palabra)
        return cell;
    }
    
    func refrescarDatos() {
        let listaPalabras = daoPalabra.getWords(language: UserDefaults.standard.string(forKey: AppDelegate.LANGUAGE)!, resolution: Resolution.baja)
        elementos=listaPalabras
            .filter({palabra in
                if let icono = palabra.icono {
                    if icono.tipo == TipoRecurso.pictograma.rawValue {
                        return true
                    }
                }
                for recurso in palabra.recursos! {
                    if let r = recurso as? RecursoAudioVisual {
                        if r.tipo == TipoRecurso.pictograma.rawValue {
                            return true
                        }
                    }
                }
                return false;
            })
            .sorted(by: {$0.nombre! < $1.nombre!});
        collectionView.reloadData();
        NSLog("refresco")
    }
    
    override func viewDidLoad() {
        UpdateCoordinator.coordinator.addListener(listener: self)
        NotificationCenter.default.addObserver(forName: UserDefaults.didChangeNotification, object: nil, queue: OperationQueue.main, using: {notification in
            self.refrescarDatos();
        })
        refrescarDatos();
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let contentView = segue.destination as! PalabraContentView;
        let indexPath = collectionView.indexPathsForSelectedItems![0];
        
        contentView.palabra = elementos[(indexPath.item)];
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}
