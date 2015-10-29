//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Jefferson Bonnaire on 24/10/2015.
//  Copyright © 2015 Jefferson Bonnaire. All rights reserved.
//

import UIKit

class MemeTableViewController: UITableViewController {

    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        self.tableView.reloadData()
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {   
        let cell = tableView.dequeueReusableCellWithIdentifier("memeCell", forIndexPath: indexPath)
        let meme = memes[indexPath.row]
        cell.textLabel?.text =  "\(meme.topText) \(meme.bottomText)"
        cell.imageView?.image = meme.memedImage
        return cell
    }

    @IBAction func launchMemeEditor(sender: AnyObject) {
//        let controller = MemeEditorViewController()
    }
}
