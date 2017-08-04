//
//  NewViewController.swift
//  Journal
//
//  Created by yuling on 2017/8/4.
//  Copyright © 2017年 yuling. All rights reserved.
//

import UIKit
import CoreData

class NewViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var journalImage: UIImageView!
    @IBOutlet weak var journalTitle: UITextField!
    @IBOutlet weak var journalDescription: UITextView!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var separetLine: UIView!
    @IBOutlet weak var cancelButton: UIButton!

    var journal: JournalMO!
    var journals = [JournalMO]()
    //swiftlint:disable force_cast
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    //swiftlint:enable force_cast
    var imageSave = UIImage()

    @IBAction func cancelButton(_ sender: UIButton) {

        self.presentingViewController?.dismiss(animated: false, completion: nil)

//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainVC")
//        self.present(vc!, animated: true, completion: nil)

    }

    @IBAction func createButton(_ sender: Any) {

        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {

            journal = JournalMO(context: appDelegate.persistentContainer.viewContext)
            journal.journalTitle = journalTitle.text
            journal.journalDescription = journalDescription.text

            let img = imageSave
            if let imageData = UIImagePNGRepresentation(img) {

                journal.journalImage = imageData as NSData

                do {
                    let task = try self.context.fetch(JournalMO.fetchRequest())
                    journals = (task as? [JournalMO])!

                } catch let error {
                    print("Cannot save the journal image to core data!", error)
                }

            }

            appDelegate.saveContext()

            let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainVC")
            self.present(vc!, animated: true, completion: nil)

        }

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        //ImageView
        journalImage.image = UIImage(named: "icon_photo")
        journalImage.contentMode = .center
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        journalImage.isUserInteractionEnabled = true
        journalImage.addGestureRecognizer(tapGestureRecognizer)

        //CreateButton
        createButton.setTitle("Create", for: .normal)
        createButton.backgroundColor = UIColor(red: 237.0/255.0, green: 96.0/255.0, blue: 81.0/255.0, alpha: 1.0)
        createButton.layer.cornerRadius = 22
        createButton.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        createButton.layer.shadowRadius = 15.0
        createButton.setTitleColor(UIColor.white, for: .normal)

        //SeparateLine
        separetLine.backgroundColor = UIColor(red: 171.0/255.0, green: 179.0/255.0, blue: 176.0/255.0, alpha: 1.0)

        //TitleText

        //CancelButton
        cancelButton.setImage(UIImage(named: "button_close"), for: .normal)

    }

    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {

        //swiftlint:disable force_cast
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        //swiftlint:enable force_cast

        let picker: UIImagePickerController = UIImagePickerController()

        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary

        picker.delegate = self

        self.present(picker, animated: true, completion: nil)

    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {

        picker.dismiss(animated: true, completion: nil) // 關掉

        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            journalImage.image = image
            journalImage.contentMode = .scaleAspectFit

            imageSave = image

        } else {
            print("Something went wrong")
        }

    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
