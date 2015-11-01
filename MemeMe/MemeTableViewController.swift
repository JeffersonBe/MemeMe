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
        if (!memes.isEmpty) {
            navigationItem.leftBarButtonItem = editButtonItem()
        }
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
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //Grab the DetailVC from Storyboard
        let object: AnyObject = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController")
        let detailController = object as! MemeDetailViewController
        
        //Populate view controller with data from the selected item
        detailController.meme = memes[indexPath.row]
        
        //Present the view controller using navigation
        self.navigationController!.pushViewController(detailController, animated: true)
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            (UIApplication.sharedApplication().delegate as! AppDelegate).memes.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
}
