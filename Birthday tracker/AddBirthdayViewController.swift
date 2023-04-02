//
//  ViewController.swift
//  Birthday tracker
//
//  Created by Ilya on 11.03.2023.
//

import UIKit
import CoreData
import UserNotifications


class AddBirthdayViewController: UIViewController {
    
    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    @IBOutlet var birthdatePicker: UIDatePicker!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        birthdatePicker.maximumDate = Date()
        
        // Do any additional setup after loading the view.
    }
    @IBAction func saveTaped(_ sender: UIBarButtonItem) {
        
        print("The save button was tapped.")
        
        let firstName = firstNameTextField.text ?? ""
        let lastName = lastNameTextField.text ?? ""
        let birthDate = birthdatePicker.date
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let newBirthday = Birthday(context: context)
        newBirthday.firstName = firstName
        newBirthday.lastName = lastName
        newBirthday.birthdate = birthDate as Date?
        newBirthday.birthdayID = UUID().uuidString
        
        if let uniqueId = newBirthday.birthdayID {
            
            print("birthdayId: \(uniqueId)")
            print("Данные сохранены \(lastName)")
        }
        
        do {
            try context.save()
            
            // Начало отображения дня рождения и напоминания о нем
            let message = "Сегодня \(lastName) \(firstName) празднует день рождения!"
            let content = UNMutableNotificationContent()
            content.body = message
            content.sound = UNNotificationSound.default
            var dateComponents = Calendar.current.dateComponents([.month, .day], from: birthDate)
            dateComponents.hour = 8
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            if let identifier = newBirthday.birthdayID {
                let request = UNNotificationRequest (identifier: identifier, content: content, trigger: trigger)
                let center = UNUserNotificationCenter.current()
                center.add(request, withCompletionHandler: nil)
            }
            // Окончание отображения дня рождения и напоминания о нем
            
            
        } catch let error {
            print("Не удалось сохранить из-за ошибки \(error)")
        }
        
        dismiss(animated: true, completion: nil)
        
//        print("Создана запись о дне рождения!")
//        print("Имя \(String(describing: newBirthday.firstName))")
//        print("Фамилия \(String(describing: newBirthday.lastName))")
//        print("День рождения \(String(describing: newBirthday.birthdate))")
    }
    
    @IBAction func cancelTapped ( _ sender: UIBarButtonItem) {
        dismiss (animated: true, completion: nil)
    }
    
    
}
