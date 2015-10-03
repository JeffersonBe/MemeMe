//
//  ViewController.swift
//  MemeMe
//
//  Created by Jefferson Bonnaire on 30/09/2015.
//  Copyright © 2015 Jefferson Bonnaire. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var ImagePickerView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var shareButton: UIButton!
    var memedImage: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()

        if (ImagePickerView.image == nil) {
            topTextField.hidden = true
            bottomTextField.hidden = true
            shareButton.enabled = false
        }

        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.yellowColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName : 1.0 ]

        topTextField.text = "Enter you text"
        bottomTextField.text = "Enter you text"
        self.topTextField.delegate = self
        self.bottomTextField.delegate = self
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.subscribeToKeyboardNotifications()
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeFromKeyboardNotifications()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // Pick Image from Picker Controller
    @IBAction func pickImage(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }

    //MARK: Delegate

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.ImagePickerView.image = image
        }
        topTextField.hidden = false
        bottomTextField.hidden = false
        shareButton.enabled = true
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    func textFieldDidBeginEditing(textField: UITextField) {
        if (textField == topTextField && textField.text! == "Enter you text") {
            topTextField.text = ""
        } else if (textField == bottomTextField && textField.text! == "Enter you text") {
            bottomTextField.text = ""
        }
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        topTextField.resignFirstResponder()
        bottomTextField.resignFirstResponder()
        return true
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }

    func keyboardWillShow(notification: NSNotification) {
        if bottomTextField.isFirstResponder() {
            self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }

    func keyboardWillHide(notification: NSNotification){
        if bottomTextField.isFirstResponder() {
        self.view.frame.origin.y += getKeyboardHeight(notification)
        }
    }

    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }

    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }

    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name:UIKeyboardWillHideNotification, object: nil)
    }

    @IBAction func share(sender: AnyObject) {
        let activityViewController = UIActivityViewController(
            activityItems: [generateMemedImage()],
            applicationActivities: nil)
        activityViewController.excludedActivityTypes = [
            UIActivityTypeAirDrop,
            UIActivityTypeAddToReadingList,
            UIActivityTypeAssignToContact,
            UIActivityTypePrint,
            UIActivityTypeCopyToPasteboard
        ]
        self.presentViewController(activityViewController, animated: true, completion: nil)
        activityViewController.completionWithItemsHandler = {
            (s: String?, ok: Bool, items: [AnyObject]?, err:NSError?) -> Void in
            self.save()
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }

    func save() {
        // Create the meme
        let meme = Meme(
            topText: topTextField.text!,
            bottomText: bottomTextField.text!,
            image:ImagePickerView.image!,
            memedImage: generateMemedImage())
        print(meme)
    }

    func generateMemedImage() -> UIImage {
        // TODO: Hide toolbar and navbar
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame,
            afterScreenUpdates: true)
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        // TODO:  Show toolbar and navbar
        self.navigationController?.setNavigationBarHidden(true, animated: true)

        return memedImage
    }
}
