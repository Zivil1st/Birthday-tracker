//
//  BirthdaysTableViewController.swift
//  Birthdays
//
//  Created by Ilya on 13.03.2023.
//

import UIKit
import CoreData
import UserNotifications

class BirthdaysTableViewController: UITableViewController {
    
    var birthdays = [Birthday] ()
    let dateFormatter = DateFormatter()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .none
    }
        
        
        
        override func viewWillAppear (_ animated: Bool) { // проблема была здесь !!!!! не было добавлена override
            super.viewWillAppear(animated)
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest = Birthday.fetchRequest() as NSFetchRequest<Birthday>
            
            //  Сортировка имен
            let sortDescription1 = NSSortDescriptor (key: "lastName", ascending: true)
            let sortDescription2 = NSSortDescriptor (key: "firstName", ascending: true)
            fetchRequest.sortDescriptors = [sortDescription1, sortDescription2]
            // Конец сортировки имен
            
            do {
                birthdays = try context.fetch(fetchRequest)
                
            } catch let error {
                print("Не удалось загрузить данные из-за ошибки \(error)")
            }
            tableView.reloadData()
        }
        
        
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    
    
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return birthdays.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "birthdayCellIdentifier", for: indexPath)
        let birthday = birthdays[indexPath.row]
        
        let firstName = birthday.firstName ?? ""
        let lastName = birthday.lastName ?? ""
        cell.textLabel?.text = firstName + " " + lastName
        
        if let date = birthday.birthdate as Date? {
            cell.detailTextLabel?.text = dateFormatter.string(from: date)
        } else {
            cell.detailTextLabel?.text = " "
        }
        
        return cell
    }
    
    
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
    
    
    
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if birthdays.count > indexPath.row {
            
            let birthday = birthdays[indexPath.row]
            
            // Начало удаления дня рождения
            if let identifier = birthday.birthdayID {
                let center = UNUserNotificationCenter.current()
                center.removePendingNotificationRequests(withIdentifiers: [identifier])
            }
            // Конец удаления дня рождения
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            context.delete(birthday)
            birthdays.remove(at: indexPath.row)
            
            do {
                try context.save()
            } catch let error {
                print("Could not save \(error).")
            }
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
     }
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
}
