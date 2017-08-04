//
//  ContentViewController.swift
//  Journal
//
//  Created by yuling on 2017/8/4.
//  Copyright © 2017年 yuling. All rights reserved.
//

import UIKit
import CoreData

class ContentViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var journalImage: UIImageView!
    @IBOutlet weak var journalTitleText: UITextField!
    @IBOutlet weak var journalDescriptionText: UITextView!
    @IBOutlet weak var separateLineImage: UIView!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!

    var journal: JournalMO!
    var journals = [JournalMO]()
    //swiftlint:disable force_cast
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    //swiftlint:enable force_cast

    var position = Int()
    var imageSave = UIImage()

    @IBAction func cancelButton(_ sender: Any) {

        dismiss(animated: true)
    }

    @IBAction func modifyButton(_ sender: Any) {

        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {

//            journal = JournalMO(context: appDelegate.persistentContainer.viewContext)

            do {

                let request: NSFetchRequest<JournalMO> = JournalMO.fetchRequest()
                journals = try context.fetch(request)

                journals[position].journalTitle = journalTitleText.text
                journals[position].journalDescription = journalDescriptionText.text

                let img = imageSave
                if let imageData = UIImagePNGRepresentation(img) {

                    journals[position].journalImage = imageData as NSData

                    do {
                        let task = try self.context.fetch(JournalMO.fetchRequest())
                        journals = (task as? [JournalMO])!

                    } catch let error {
                        print("Cannot save the journal image to core data!", error)
                    }

                }

                appDelegate.saveContext()

                //                journalsTableView.reloadData()

            } catch {
                print("fetch failed！！")
            }
            dismiss(animated: true)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        journalImage.isUserInteractionEnabled = true
        journalImage.addGestureRecognizer(tapGestureRecognizer)

        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let request: NSFetchRequest<JournalMO> = JournalMO.fetchRequest()
            do {

                journals = try context.fetch(request)

                journalTitleText.text = journals[position].journalTitle

                journalDescriptionText.text = journals[position].journalDescription

                if let imageData = UIImage(data: (journals[position].journalImage as? Data)!) {
                    journalImage.image = imageData

                    journalImage.layer.masksToBounds = true
                    journalImage.contentMode = .scaleAspectFill

                }

            } catch {
                print("沒抓到資料！！")
            }

        }

        //CreateButton
        createButton.setTitle("Modify", for: .normal)
        createButton.backgroundColor = UIColor(red: 237.0/255.0, green: 96.0/255.0, blue: 81.0/255.0, alpha: 1.0)
        createButton.layer.cornerRadius = 22
        createButton.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        createButton.layer.shadowRadius = 15.0
        createButton.setTitleColor(UIColor.white, for: .normal)

        //SeparateLine
        separateLineImage.backgroundColor = UIColor(red: 171.0/255.0, green: 179.0/255.0, blue: 176.0/255.0, alpha: 1.0)

        //CancelButton
        cancelButton.setImage(UIImage(named: "button_close"), for: .normal)
        cancelButton.backgroundColor = UIColor.clear
        cancelButton.tintColor = UIColor.white

        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardNotification(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {

            //swiftlint:disable force_cast
            let keyboardFrame: CGRect = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            let duration: Double = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! Double
            //swiftlint:enable force_cast

            UIView.animate(withDuration: duration, animations: { () -> Void in
                var frame = self.view.frame
                frame.origin.y = keyboardFrame.minY - self.view.frame.height
                self.view.frame = frame
            })
        }
    }

    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {

        //swiftlint:disable force_cast
        _ = tapGestureRecognizer.view as! UIImageView
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Return" {

//            if let cell = sender as? JournalTableViewCell {
                let destinationTableViewController = segue.destination as? MainPageTableViewController

                destinationTableViewController?.position = position

//            }

        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
