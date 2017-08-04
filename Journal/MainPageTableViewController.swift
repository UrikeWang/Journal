//
//  MainPageTableViewController.swift
//  Journal
//
//  Created by yuling on 2017/8/4.
//  Copyright © 2017年 yuling. All rights reserved.
//

import UIKit
import CoreData

class MainPageTableViewController: UITableViewController {

//    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet var journalsTableView: UITableView!

    @IBOutlet weak var addButton: UIButton!

    @IBOutlet weak var myTitle: UILabel!

    var journal: JournalMO!
    var journals = [JournalMO]()
    //swiftlint:disable force_cast
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    //swiftlint:enable force_cast

    var position = Int()

    override func viewDidLoad() {
        super.viewDidLoad()

        addButton.addTarget(self, action: #selector(addNew(sender:)), for: .touchUpInside)
        addButton.setImage(UIImage(named: "icon_plus"), for: .normal)

        journalsTableView.separatorStyle = .none

        myTitle.font = UIFont(name: ".SFUIText-Semibold", size: 20)
        myTitle.textColor = UIColor(red: 67.0/255.0, green: 87.0/255.0, blue: 97.0/255.0, alpha: 1.0)

    }

    func addNew(sender: UIButton) {

        let vc = self.storyboard?.instantiateViewController(withIdentifier: "NewVC")
        self.present(vc!, animated: true, completion: nil)

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) // No need for semicolon
        do {

            let request: NSFetchRequest<JournalMO> = JournalMO.fetchRequest()
            journals = try context.fetch(request)

            journalsTableView.reloadData()

        } catch {
            print("fetch failed！！")
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return journals.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        //swiftlint:disable force_cast
        let cell = tableView.dequeueReusableCell(withIdentifier: "JournalCell", for: indexPath) as! JournalTableViewCell
        //swiftlint:enable force_cast

        cell.journalTitle.text = journals[indexPath.row].journalTitle
        cell.journalTitle.textColor = UIColor(red: 67.0/255.0, green: 87.0/255.0, blue: 97.0/255.0, alpha: 1.0)

        do {
            if let imageData = UIImage(data: (journals[indexPath.row].journalImage as? Data)!) {

                cell.journalImage.image = imageData
                cell.journalImage.layer.masksToBounds = true
                cell.journalImage.contentMode = .scaleAspectFill
                cell.journalImage.layer.cornerRadius = 8
                cell.journalImage.layer.shadowColor = UIColor.greyish.cgColor
                cell.journalImage.layer.shadowOffset = CGSize(width: 0, height: 0)

            }
            } catch let error {
            print("Cannot save the journal image to core data!", error)
        }

        cell.journalImage.tag = indexPath.row

        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            
            
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Show" {

            if let cell = sender as? JournalTableViewCell {
                let destinationTableViewController = segue.destination as? ContentViewController

                destinationTableViewController?.position = cell.journalImage.tag

            }

        }

    }

 }
