//
//  ViewController.swift
//  Birthday tracker
//
//  Created by Ilya on 11.03.2023.
//

import UIKit
import CoreData


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
        
        let firstName = firstNameTextField.text ?? ""
        let lastName = lastNameTextField.text ?? ""
        let birthDate = birthdatePicker.date
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let newBirthday = Birthday(context: context)
        newBirthday.firstName = firstName
        newBirthday.lastName = lastName
        newBirthday.birthdate = birthDate as Date? // возможно без перевода в формат Date можно обойтись
        newBirthday.birthdayID = UUID().uuidString
        
        if let uniqueId = newBirthday.birthdayID {
            
            print("birthdayId: \(uniqueId)")
        }
        
        do {
            try context.save()
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
