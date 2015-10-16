//
//  ViewController.swift
//  MemeMe
//
//  Created by Jefferson Bonnaire on 30/09/2015.
//  Copyright © 2015 Jefferson Bonnaire. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var topToolbar: UIToolbar!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var albumButton: UIButton!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    var meme: Meme?
    var memedImage: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Hide scene if no image is selected
        if (imagePickerView.image == nil) {
            emptyAndHideScene()
        }
        
        // Create Attributes for textfield
        let memeTextAttributes = [
            NSFontAttributeName : UIFont(name: "Impact", size: 40)!,
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSStrokeColorAttributeName: UIColor.blackColor(),
            NSStrokeWidthAttributeName : -3.0,
        ]

        topTextField.delegate = self
        bottomTextField.delegate = self
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
        topTextField.textAlignment = NSTextAlignment(rawValue: 1)!
        bottomTextField.textAlignment = NSTextAlignment(rawValue: 1)!
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        topTextField.text = "Enter you text"
        bottomTextField.text = "Enter you text"
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        subscribeToKeyboardNotifications()
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }

    // Pick Image from Picker Controller
    @IBAction func pickImage(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        presentViewController(imagePicker, animated: true, completion: nil)
    }

    //MARK: Delegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = image
        }
        topTextField.hidden = false
        bottomTextField.hidden = false
        shareButton.enabled = true
        dismissViewControllerAnimated(true, completion: nil)
    }

    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    func textFieldDidBeginEditing(textField: UITextField) {
        if (textField == topTextField && textField.text! == "Enter you text") {
            topTextField.text = ""
        } else if (textField == bottomTextField && textField.text! == "Enter you text") {
            bottomTextField.text = ""
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        quitTextField()
        return true
    }

    func textFieldDidEndEditing(textField: UITextField) {
        if (textField.text == "") {
            textField.text = "Enter you text"
        }
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
    }
    
    //MARK: KeyboardManagement
    func keyboardWillShow(notification: NSNotification) {
        if bottomTextField.isFirstResponder() {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }

    func keyboardWillHide(notification: NSNotification){
        if bottomTextField.isFirstResponder() {
            view.frame.origin.y += getKeyboardHeight(notification)
        }
    }

    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    //MARK: Notifications
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }

    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name:UIKeyboardWillHideNotification, object: nil)
    }
    
    // Share Activity
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
        
        // Present Share Activity and Save when controller is dismissed
        presentViewController(activityViewController, animated: true, completion: nil)
        activityViewController.completionWithItemsHandler = {
            (s: String?, ok: Bool, items: [AnyObject]?, err:NSError?) -> Void in
            if ok {
                self.save()
            }
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    // Create the meme
    func save() {
        meme = Meme(
            topText: topTextField.text!,
            bottomText: bottomTextField.text!,
            image:imagePickerView.image!,
            memedImage: generateMemedImage()
        )
    }
    
    //  Generate Meme Image
    func generateMemedImage() -> UIImage {
        // Hide toolbar
        topToolbar.hidden = true
        bottomToolbar.hidden = true

        // Render view to an image
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawViewHierarchyInRect(view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        // Show Toolbar
        topToolbar.hidden = false
        bottomToolbar.hidden = false
        return memedImage
    }
    
    // Cancel current action
    @IBAction func cancel() {
        quitTextField()
        emptyAndHideScene()
    }
    
    func emptyAndHideScene() {
        imagePickerView.image = nil
        topTextField.text = ""
        bottomTextField.text = ""
        topTextField.hidden = true
        bottomTextField.hidden = true
        shareButton.enabled = false
    }
    
    func quitTextField() {
        topTextField.resignFirstResponder()
        bottomTextField.resignFirstResponder()
    }
}
