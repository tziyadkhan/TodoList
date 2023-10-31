//
//  RealmController.swift
//  ToDoList
//
//  Created by Ziyadkhan on 22.10.23.
//

import UIKit
import RealmSwift

class ToDoListRealm: Object {
   @Persisted var title: String = ""
}

class RealmController: UIViewController {
    
    @IBOutlet weak var tableRealm: UITableView!
    var items = [ToDoListRealm]()
    let realm = try! Realm() // Realm-i initialize edirik // Databazaya access ucun birinci referansimizi veririk
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Realm Todo List"
        getFilePath()
        fetchItems()
    }
    
    

    @IBAction func realmAddButton(_ sender: Any) {
        addAlert()
    }
    
    
}

extension RealmController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        cell.textLabel?.text = items[indexPath.row].title
        return cell
    }
}

// Functions
extension RealmController {
    func addAlert() {
        let alertController = UIAlertController(title: "Enter new item", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "Enter new item"
        }
        
        let okayButton = UIAlertAction(title: "Add", style: .default) { _ in
            let text = alertController.textFields?[0].text ?? ""
            self.saveItem(text: text)
        }
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(okayButton)
        alertController.addAction(cancelButton)
        present(alertController, animated: true)
    }
    
    func saveItem(text: String) {
        let item = ToDoListRealm()
        item.title = text
        do {
            try realm.write {
                realm.add(item)
                fetchItems()
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    func fetchItems() {
        items.removeAll()
        let data = realm.objects(ToDoListRealm.self)
        items.append(contentsOf: data)
        tableRealm.reloadData()
    }
    
    func getFilePath() {
        if let url = realm.configuration.fileURL {
            print(url)
        }
    }
}
