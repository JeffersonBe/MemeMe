//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Jefferson Bonnaire on 29/10/2015.
//  Copyright © 2015 Jefferson Bonnaire. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textLabel: UILabel!

    var meme: Meme?
    
    override func viewDidLoad() {
        if let meme  = meme {
            textLabel.text = "\(meme.topText) \(meme.bottomText)"
            imageView.image = meme.memedImage
        }
    }
}
