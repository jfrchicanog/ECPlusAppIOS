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
    
    let daoPalabra: DAOPalabra = DAOFactory.getDAOPalabra()
    
    var elementosCategorias : [[PalabraEntity]] = []
    var secciones : [String] = []
    
    @IBOutlet var collectionView: UICollectionView!
    
    func onUpdateEvent(event: UpdateEvent) {
        NSLog("Event: \(event.action!.rawValue)")
        if event.action! == UpdateEventAction.stopGlobalUpdate {
            OperationQueue.main.addOperation({self.refrescarDatos()})
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        if secciones.count  == 0 {
            let label = UILabel(frame:
                CGRect(x: 0, y: 0, width: self.collectionView.bounds.size.width * 0.8, height: self.collectionView.bounds.size.height))
            label.text = UpdateCoordinator.coordinator.isThereNetworkActivity() ?
                NSLocalizedString("Downloading", comment: "Message for tables when data is downloading"):
                NSLocalizedString("NoItemsForLanguage", comment: "Message for tables when there are no items to show");
            label.textAlignment = .center
            label.sizeToFit()
            label.lineBreakMode = .byWordWrapping
            label.numberOfLines = 0
            self.collectionView.backgroundView = label
        } else {
            self.collectionView.backgroundView = nil
        }
        
        return secciones.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return elementosCategorias[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pictograma", for: indexPath);
        let palabra = elementosCategorias[indexPath.section][indexPath.item]
        
        let imageView = (cell.viewWithTag(1) as? UIImageView)
        imageView?.contentMode = .scaleAspectFit
        imageView?.image = WordsUtility.getLogoFromWord(palabra: palabra)
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let cell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "cabecera", for: indexPath)
        let label = cell.viewWithTag(1) as? UILabel
        label?.text = secciones[indexPath.section];
        return cell;
    }
    
    func refrescarDatos() {
        self.elementosCategorias.removeAll();
        self.secciones.removeAll();
        let listaPalabras = daoPalabra.getWords(language: UserDefaults.standard.string(forKey: AppDelegate.LANGUAGE)!, resolution: Resolution.baja)
        let elementos=listaPalabras
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
            .sorted(by: {(first, second) in
                let firstCategory = first.categoria
                let secondCategory = second.categoria
                
                if firstCategory != nil && secondCategory == nil {
                    return true
                } else if firstCategory == nil && secondCategory != nil {
                    return false;
                } else if firstCategory == nil && secondCategory == nil {
                    return first.nombre! < second.nombre!
                } else if firstCategory! == secondCategory! {
                    return first.nombre! < second.nombre!
                } else if firstCategory!.nombre! < secondCategory!.nombre! {
                    return true;
                } else {
                    return false;
                }
            });
        
        if elementos.count > 0 {
            var categoriaAnterior : Categoria? = elementos.first?.categoria
            var actualLista : [PalabraEntity] = []
            for palabra in elementos {
                if categoriasIguales(categoria1: palabra.categoria, categoria2: categoriaAnterior) {
                    actualLista.append(palabra);
                } else {
                    elementosCategorias.append(actualLista)
                    secciones.append(categoriaAnterior == nil ? NSLocalizedString("Words without category", comment: "Words without category") : categoriaAnterior!.nombre!)
                    
                    actualLista = [palabra];
                    categoriaAnterior = palabra.categoria
                }
            }
            
            if actualLista.count > 0 {
                elementosCategorias.append(actualLista)
                secciones.append(categoriaAnterior == nil ? NSLocalizedString("Words without category", comment: "Words without category") : categoriaAnterior!.nombre!)
            }
        }
        
        collectionView.reloadData();
        NSLog("refresco")
    }
    
    private func categoriasIguales (categoria1: Categoria?, categoria2: Categoria?) -> Bool {
        if categoria1 == nil && categoria2 == nil {
            return true
        } else if (categoria1 != nil && categoria2 != nil) {
            return categoria1! == categoria2!
        } else {
            return false
        }
    }
    
    override func viewDidLoad() {
        UpdateCoordinator.coordinator.addListener(listener: self)
        NotificationCenter.default.addObserver(forName: UserDefaults.didChangeNotification, object: nil, queue: OperationQueue.main, using: {notification in
            WordsUtility.clearCache()
            self.refrescarDatos();
        })
        refrescarDatos();
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let contentView = segue.destination as! PalabraContentView;
        let indexPath = collectionView.indexPathsForSelectedItems![0];
        
        contentView.palabra = elementosCategorias[indexPath.section][indexPath.item];
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}
