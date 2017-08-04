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

    var journal: JournalMO!
    var journals = [JournalMO]()

    @IBAction func cancelButton(_ sender: UIButton) {

        dismiss(animated: true)

    }

    @IBAction func createButton(_ sender: Any) {

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

    }

    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {

        //swiftlint:disable force_cast
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        //swiftlint:enable force_cast

        let picker: UIImagePickerController = UIImagePickerController()

        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary

        //        picker.allowsEditing = true // 可對照片作編輯

        //swiftlint:disable force_cast
        picker.delegate = self
        //swiftlint:enable force_cast

        self.present(picker, animated: true, completion: nil)

    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {

        picker.dismiss(animated: true, completion: nil) // 關掉

        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            journalImage.image = image
            journalImage.contentMode = .scaleAspectFit

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
