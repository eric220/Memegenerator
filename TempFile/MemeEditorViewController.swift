//
//  MemeEditorViewController.swift
//  TempFile
//
//  Created by Macbook on 10/26/16.
//  Copyright © 2016 Macbook. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    @IBOutlet weak var imagePick: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var inputTop: UITextField!
    @IBOutlet weak var inputBottom: UITextField!
    @IBOutlet weak var share: UIBarButtonItem!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    //textfield delegates
    let textFieldDelegate1 = TopTextFieldDelegate()

    override func viewDidLoad() {
        super.viewDidLoad()
        imagePick.image = nil
        configure(textField: inputTop)
        configure(textField: inputBottom)
        //share button initialization
        share.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeToKeyboardNotifications()
    }
    
    //MARK Image Pickers
    
    //use album or camera
    @IBAction func pickImage(_ sender: AnyObject) {
        let nextController = UIImagePickerController()
        nextController.delegate = self
        if (sender.tag == 0){
            nextController.sourceType = UIImagePickerControllerSourceType.camera
            present(nextController, animated: true, completion: nil)
        }else {
        nextController.sourceType = UIImagePickerControllerSourceType.photoLibrary
        present(nextController, animated: true, completion: nil)
        }
    }
    
    //
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
        imagePick.image = image
        dismiss(animated: true, completion: nil)
        }
        enableShareButton()
    }
    //cancel image picker
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    //Keyboard show and hide
    
    //move keyboard up
    func keyboardWillShow(notification: NSNotification){
        if inputBottom.isFirstResponder{
        view.frame.origin.y = getKeyboardHeight(notification: notification) * -1
        }
    }
    //move keyboard down
    func keyboardWillHide(notification: NSNotification){
        view.frame.origin.y = 0
    }
    //watch for keyboard to show
    func subscribeToKeyboardNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    //let go of notification
    func unsubscribeToKeyboardNotifications(){
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    //get height of keyboard
    func getKeyboardHeight(notification: NSNotification) -> CGFloat{
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    func save(/*_ sender: AnyObject*/) {
        let memedImage = createMemeImage()
        var originalImage = UIImage()
        if ((imagePick.image) != nil){//WORK ON THIS 
            originalImage = imagePick.image!
        } else{
            print("no image found")
        }
        let meme = MemeObject(topString: inputTop.text!, bottomString: inputBottom.text!, originalImage: originalImage, memeImage: memedImage) 
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }
    //present activity viewController
    @IBAction func shareMeme(_ sender: AnyObject) {
        let image = createMemeImage()
        let controller = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        controller.completionWithItemsHandler = {
            (activityType, complete, returnedItems, activityError ) in
            if complete {
                self.save()
                self.dismiss(animated: true, completion: nil)
            }
        }
        present(controller, animated: true, completion: nil)
        }
    //create meme
    func createMemeImage()-> UIImage{
        //hide toolbar
        navigationBar.isHidden = true
        toolBar.isHidden = true
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawHierarchy(in: view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        //restore toolbar
        navigationBar.isHidden = false
        toolBar.isHidden = false
        return memedImage
    }
    
    //call to enable share button
    func enableShareButton() {
        share.isEnabled = true
    }

    @IBAction func cancelButton(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    //configure text fields
    func configure(textField: UITextField){
        let textAttributes = [
            NSStrokeColorAttributeName : UIColor.black,
            NSForegroundColorAttributeName : UIColor.white,
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName : -2.0,
            ] as [String : Any]
        textField.defaultTextAttributes = textAttributes
        textField.textAlignment = NSTextAlignment.center
        if (textField == inputTop){
            inputTop.text = "TOP"
            inputTop.delegate = textFieldDelegate1
        } else {
            inputBottom.text = "BOTTOM"
            inputBottom.delegate = textFieldDelegate1
        }
    }

}

