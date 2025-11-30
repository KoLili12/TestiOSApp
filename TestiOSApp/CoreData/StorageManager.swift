//
//  StorageManager.swift
//  TestiOSApp
//
//  Created by Николай Жирнов on 30.11.2025.
//

import UIKit
import CoreData

final class StorageManager {
    static let shared = StorageManager()
    private init() {}
    
    private var appDelegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    private var context: NSManagedObjectContext {
        appDelegate.persistentContainer.viewContext
    }
    
    // MARK: - Functions for working with items in CoreData
    
    func addItemsInCoreData(items: [Item]) {
        deleteItemsFromCoreData()
        items.forEach { item in
            guard let itemEntityDescription = NSEntityDescription.entity(forEntityName: "ItemCoreData", in: context) else {
                return
            }
            
            let newItemCoreData = ItemCoreData(entity: itemEntityDescription, insertInto: context)
            
            newItemCoreData.id = Int16(item.id)
            newItemCoreData.title = item.title
            newItemCoreData.body = item.body
            newItemCoreData.userId = Int16(item.userId)
        }
        appDelegate.saveContext()
    }
    
    func fetchItemsFromCoreData() -> [Item] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ItemCoreData")
        do {
            guard let fetchItems = try context.fetch(fetchRequest) as? [ItemCoreData] else { return [] }
            
            var result: [Item] = []
            
            fetchItems.forEach {
                let item = Item(id: Int($0.id), userId: Int($0.userId), title: $0.title!, body: $0.body!)
                result.append(item)
            }
            return result
        } catch {
            return []
        }
    }
    
    func deleteItemsFromCoreData() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ItemCoreData")
        do {
            guard let fetchItems = try? context.fetch(fetchRequest) as? [ItemCoreData] else { return }
            fetchItems.forEach { context.delete($0) }
        }
        
        appDelegate.saveContext()
    }
}
