//
//  PalabraContentView.swift
//  ECPlusApp
//
//  Created by José Francisco Chicano García on 12/2/18.
//  Copyright © 2018 José Francisco Chicano García. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import SVGKit
import AVKit
import AVFoundation

class PalabraContentView : UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var palabra : PalabraEntity?
    @IBOutlet weak var collectionView: UICollectionView!
    var recursos : [RecursoAudioVisual] = []
    let resourceStore = ResourceStore.resourceStore
    var players : [UIGestureRecognizer:AVPlayer] = [:]
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recursos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let recurso = recursos[indexPath.item]
        var cell : UICollectionViewCell?
        if recurso.tipo == TipoRecurso.video.rawValue {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "video", for: indexPath)
            let hash = recurso.getFichero(for: Resolution.baja)!.hashvalue!
            if resourceStore.fileExists(withHash: hash, type: TipoRecurso.video) {
                let url = resourceStore.getFileResource(for: hash, type: TipoRecurso.video)
                
                let player = AVPlayer(url: url)
                (cell?.viewWithTag(1) as! PlayerView).player = player
                player.seek(to: CMTime(seconds: 30, preferredTimescale: 60))
                
                let tapGR = UITapGestureRecognizer(target: self, action: #selector(playVideo(_:)))
                players[tapGR] = player
                cell?.addGestureRecognizer(tapGR)
            } else {
                NSLog("El fichero: \(hash) no existe")
            }
            
        } else if recurso.tipo == TipoRecurso.foto.rawValue{
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "picture", for: indexPath)
            let hash = recurso.getFichero(for: Resolution.baja)!.hashvalue!
            if resourceStore.fileExists(withHash: hash, type: TipoRecurso.foto) {
                let url = resourceStore.getFileResource(for: hash, type: TipoRecurso.foto)
                (cell?.viewWithTag(1) as! UIImageView).image = UIImage(contentsOfFile: url.path)
            }
        } else if recurso.tipo == TipoRecurso.pictograma.rawValue {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "picture", for: indexPath)
            let hash = recurso.getFichero(for: Resolution.baja)!.hashvalue!
            if resourceStore.fileExists(withHash: hash, type: TipoRecurso.pictograma) {
                let url = resourceStore.getFileResource(for: hash, type: TipoRecurso.pictograma)
                let anSVGImage: SVGKImage = SVGKImage(contentsOf: url)
                (cell?.viewWithTag(1) as! UIImageView).image = anSVGImage.uiImage
            }
        } else if recurso.tipo == TipoRecurso.audio.rawValue {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "audio", for: indexPath)
            let hash = recurso.getFichero(for: Resolution.baja)!.hashvalue!
            if resourceStore.fileExists(withHash: hash, type: TipoRecurso.audio) {
                let url = resourceStore.getFileResource(for: hash, type: TipoRecurso.audio)
                let player = AVPlayer(url: url)
                let tapGR = UITapGestureRecognizer(target: self, action: #selector(playAudio(_:)))
                players[tapGR] = player
                cell?.addGestureRecognizer(tapGR)
            } else {
                NSLog("File does not exist")
            }
        } else {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "picture", for: indexPath)
        }
        return cell!
    }
    
    @objc func playVideo(_ sender: UITapGestureRecognizer) {
        let player = players[sender]!
        player.seek(to: CMTime(seconds: 0, preferredTimescale: 60))
        player.play()
    }
    
    @objc func playAudio(_ sender: UITapGestureRecognizer) {
        let player = players[sender]!
        player.seek(to: CMTime(seconds: 0, preferredTimescale: 60))
        player.play()
        NSLog("Play audio")
    }
    
    override func viewDidLoad() {
        self.navigationItem.title = palabra?.nombre
        //collectionView.delegate = self
        
        recursos = Array((palabra?.recursos as! Set<RecursoAudioVisual>)).sorted(by: {(r1, r2) in
            if r1.tipo! == r2.tipo! {
                return r1.id < r2.id;
            } else if (r1.tipo! == TipoRecurso.video.rawValue) {
                return true
            } else if (r2.tipo! == TipoRecurso.video.rawValue) {
                return false
            } else if (r1.tipo! == TipoRecurso.pictograma.rawValue) {
                return true
            } else {
                return false
            }
        })
        collectionView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        (segue.destination as! LargeImageViewController).image = ((sender as! UICollectionViewCell).viewWithTag(1) as! UIImageView).image
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let tipo = recursos[indexPath.item].tipo
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        
        if landscape() {
            let totalSpace = flowLayout.sectionInset.top + flowLayout.sectionInset.bottom
                + flowLayout.minimumLineSpacing
            let height = (collectionView.bounds.height - totalSpace)/2
            if (tipo == TipoRecurso.video.rawValue) {
                return CGSize(width: height/9.0*16.0, height: height)
            } else {
                return CGSize(width: height, height: height)
            }
        } else {
            if (tipo == TipoRecurso.video.rawValue) {
                let totalSpace = flowLayout.sectionInset.left + flowLayout.sectionInset.right
                let width = collectionView.bounds.width - totalSpace
                return CGSize(width: width, height: width/16.0*9.0)
            } else {
                let totalSpace = flowLayout.sectionInset.left + flowLayout.sectionInset.right
                    + flowLayout.minimumInteritemSpacing
                let width = (collectionView.bounds.width - totalSpace)/2
                return CGSize(width: width, height: width)
            }
        }
    }
    
    fileprivate func landscape() -> Bool {
        return view.bounds.width > view.bounds.height
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        if landscape() {
            flowLayout.scrollDirection = UICollectionViewScrollDirection.horizontal
        } else {
            flowLayout.scrollDirection = UICollectionViewScrollDirection.vertical
        }
        flowLayout.invalidateLayout()
    }
    
}
