//
//  ContentViewController.swift
//  Journal
//
//  Created by yuling on 2017/8/4.
//  Copyright © 2017年 yuling. All rights reserved.
//

import UIKit
import CoreData

class ContentViewController: UIViewController {

    @IBOutlet weak var journalImage: UIImageView!
    @IBOutlet weak var journalTitleText: UITextField!
    @IBOutlet weak var journalDescriptionText: UITextView!
    @IBOutlet weak var separateLineImage: UIView!
    @IBOutlet weak var createButton: UIButton!

    var journal: JournalMO!
    var journals = [JournalMO]()
    //swiftlint:disable force_cast
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    //swiftlint:enable force_cast

    var position = Int()

    @IBAction func cancelButton(_ sender: Any) {
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let request: NSFetchRequest<JournalMO> = JournalMO.fetchRequest()
            do {
                //                print("!!!!!!!!", request)
                journals = try context.fetch(request)
                //                fot item in favoriteItems {
                //                    products.append(item)
                //                }

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
//            bottomCollectionView.reloadData()

        }

        // Do any additional setup after loading the view.
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
