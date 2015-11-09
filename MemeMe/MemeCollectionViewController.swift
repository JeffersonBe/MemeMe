//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Jefferson Bonnaire on 29/10/2015.
//  Copyright © 2015 Jefferson Bonnaire. All rights reserved.
//

import UIKit

class MemeCollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = UIColor.whiteColor()
        let space: CGFloat = 3.0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        let numberOfItemInARow: CGFloat = 2.0
        flowLayout.itemSize = CGSize(width: (view.bounds.size.width - 2 * space) / numberOfItemInARow, height: view.bounds.size.width / numberOfItemInARow)
    }
    
    /* Reload Data */
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        collectionView!.reloadData()
    }
    
    // MARK: CollectionView delegate
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("memeCell", forIndexPath: indexPath) as! MemeCollectionViewCell
        
        let meme = memes[indexPath.item]
        cell.textLabel?.text = "\(meme.topText) \(meme.bottomText)"
        cell.imageView?.image = meme.memedImage
    
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let object: AnyObject = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController")
        let detailController = object as! MemeDetailViewController
        
        detailController.meme = memes[indexPath.row]
        navigationController!.pushViewController(detailController, animated: true)
    }
}
