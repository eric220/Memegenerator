//
//  MemeCollectionViewController.swift
//  TempFile
//
//  Created by Macbook on 11/9/16.
//  Copyright © 2016 Macbook. All rights reserved.
//

import Foundation
import UIKit

class MemeCollectionViewController: UICollectionViewController {
    @IBOutlet weak var flowLayout:UICollectionViewFlowLayout!
    
    var memes: [MemeObject]! {
        return (UIApplication.shared.delegate as! AppDelegate).memes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let space: CGFloat = 1
        let heightLimit = ((self.view.frame.size.height))
        let widthLimit = ((self.view.frame.size.width))
        let dimension:CGFloat = widthLimit >= heightLimit ? (widthLimit - (5 * space)) / 6.0 :  (widthLimit - (2 * space)) / 3.0
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView?.reloadData()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionViewCell", for: indexPath) as! MemeCollectionViewCell
        let newMeme = memes[indexPath.row]
        cell.collectionViewImage.image = newMeme.memeImage
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let memeToPass = memes[indexPath.row].memeImage
        let controller = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        controller.newMeme = memeToPass
        self.navigationController!.pushViewController(controller, animated: true)
    }
    
}
