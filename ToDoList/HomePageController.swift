//
//  HomePageController.swift
//  ToDoList
//
//  Created by Ziyadkhan on 19.10.23.
//

import UIKit

class HomePageController: UIViewController {

    @IBOutlet weak var table: UITableView!
    let context = AppDelegate().persistentContainer.viewContext
    var items = [ToDoList]()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "ToDo List"
        fetchItems()
    }

    @IBAction func addButton(_ sender: Any) {
        showAlert()
        
    }
}

extension HomePageController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        cell.textLabel?.text = items[indexPath.row].title
        return cell
    }
    // surushdurub delete etmek (commit by default delete ishini gorur)
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        deleteItem(index: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        updateItem(index: indexPath.row)
    }
}


// Yeni item elave etmek
extension HomePageController {
    func showAlert() {
        let alertController = UIAlertController(title: "Add new item",
                                                message: nil,
                                                preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Enter something"
        }
        
        let addButton = UIAlertAction(title: "Add", style: .default) { _ in
            let text = alertController.textFields?[0].text ?? ""
            // Alertimizin icinde bir dene textfield oldugu ucu 0 qoyuruq. iki dene olsaydi ikincini almaq ucun [1] yazacag idik
            self.saveItem(text: text)
        }
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(addButton)
        alertController.addAction(cancelButton)
        present(alertController, animated: true)
    }
    
    // database'e yazmaq ucun
    
    func saveItem(text: String) {
        do {
            let model = ToDoList(context: context)
            model.title = text
            try context.save() //database'e yazdi
            self.fetchItems()
        } catch {
            print(error.localizedDescription)
        }
    }
    // Save etdiyimiz datani oxumaq ucun
    func fetchItems() {
        do {
            items = try context.fetch(ToDoList.fetchRequest())
            table.reloadData()
        } catch {
            print(error.localizedDescription)
        }
    }
    // Delete etmek ucun
    func deleteItem(index: Int) {
        do {
            context.delete(items[index])
            try context.save()
            fetchItems()
        } catch {
            print(error.localizedDescription)
        }
        
    }
}

extension HomePageController {
    //Itemi update etmek ucun
    
    func updateItemInDB(index: Int, newItem: String) {
        do {
            items[index].title = newItem
            try context.save()
            fetchItems()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func updateItem(index: Int) {
        let alertController = UIAlertController(title: "Update the item",
                                                message: nil,
                                                preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Enter something"
            textField.text = self.items[index].title
        }
        
        let saveButton = UIAlertAction(title: "Save", style: .default) { _ in
            let text = alertController.textFields?[0].text ?? ""
            self.updateItemInDB(index: index, newItem: text)
        }
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(saveButton)
        alertController.addAction(cancelButton)
        
        present(alertController, animated: true)
    }

}
