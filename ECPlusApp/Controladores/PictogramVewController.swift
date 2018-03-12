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
        let imageView = (cell.viewWithTag(1) as? SVGKImageView)
        imageView?.image = getLogoFromWord(palabra: palabra)
        return cell;
    }
    
    func getLogoFromWord(palabra: PalabraEntity) -> SVGKImage? {
        if let recurso = palabra.icono {
            if (recurso.tipo == TipoRecurso.pictograma.rawValue) {
                let hash = recurso.getFichero(for: Resolution.baja)!.hashvalue!
                if let imagen = resourceCache.getFileResource(for: hash, type: TipoRecurso.pictograma) {
                    return imagen
                }
            }
        }
        for elemento in palabra.recursos! {
            if let recurso = (elemento as? RecursoAudioVisual) {
                if (recurso.tipo == TipoRecurso.pictograma.rawValue) {
                    let hash = recurso.getFichero(for: Resolution.baja)!.hashvalue!
                    if let imagen = resourceCache.getFileResource(for: hash, type: TipoRecurso.pictograma) {
                        return imagen
                    }
                }
            }
        }
        return nil
    }
    
    func refrescarDatos() {
        let listaPalabras = daoPalabra.getWords(language: "es", resolution: Resolution.baja)
        elementos=listaPalabras.sorted(by: {$0.nombre! < $1.nombre!});
        collectionView.reloadData();
        NSLog("refresco")
    }
    
    override func viewDidLoad() {
        UpdateCoordinator.coordinator.addListener(listener: self)
        refrescarDatos();
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let contentView = segue.destination as! PalabraContentView;
        let indexPath = collectionView.indexPathsForSelectedItems![0];
        
        contentView.palabra = elementos[(indexPath.item)];
    }
    
    /*
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout

        let totalSpace = flowLayout.sectionInset.left + flowLayout.sectionInset.right
            + flowLayout.minimumInteritemSpacing
        let width = (collectionView.bounds.width - totalSpace)/2
        return CGSize(width: 100, height: 100)
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.invalidateLayout()
    }*/
    
    
}
