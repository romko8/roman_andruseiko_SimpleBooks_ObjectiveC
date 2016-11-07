//
//  CoreDataManager.swift
//  roman_andruseiko_SimpleBooks
//
//  Created by Roman Andruseiko on 10/21/16.
//  Copyright © 2016 SimpleBooks. All rights reserved.
//

import CoreData

@objc(CoreDataManager)
open class CoreDataManager : NSObject  {
    lazy var managedObjectContext      :   NSManagedObjectContext = self.initManagedObjectContext()
    lazy var persistentStoreCoordinator       :   NSPersistentStoreCoordinator = self.initPersistentStore()
    lazy var managedObjectModel               :   NSManagedObjectModel = self.initManagedObjectModel()
    
    static let sharedInstance = CoreDataManager()
    
    //MARK:Init methods
    fileprivate func initManagedObjectContext() -> NSManagedObjectContext {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.mergePolicy = NSMergePolicy(merge: .mergeByPropertyObjectTrumpMergePolicyType)
        managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
        return managedObjectContext
    }
    
    
    lazy var applicationDocumentsDirectory: URL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()
    
    fileprivate func initPersistentStore() -> NSPersistentStoreCoordinator {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("SingleViewCoreData.sqlite")
        let failureReason = "There was an error creating or loading the application's saved data."
        do {
            let options = [NSInferMappingModelAutomaticallyOption: true, NSMigratePersistentStoresAutomaticallyOption: true]
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: options)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator

    }
    
    fileprivate func initManagedObjectModel() -> NSManagedObjectModel {
        let modelURL = Bundle.main.url(forResource: "roman_andruseiko_SimpleBooks", withExtension: "momd")
        return NSManagedObjectModel(contentsOf: modelURL!)!
    }

    //MARK: Helpers    
    open func createEntity<T : NSManagedObject>(predicate:NSPredicate?) -> T{
        print(NSStringFromClass(T.self))
        if let objectsFromDB:[T] = self.objectsFromEntity(predicate) {
            if objectsFromDB.count != 0
            {
                return objectsFromDB.first as T!
            }
        }
        let entity = NSEntityDescription.insertNewObject(forEntityName: NSStringFromClass(T.self), into: self.managedObjectContext) as! T
        return entity
    }
    
    open func objectFromEntity<T : NSManagedObject>(_ predicate:NSPredicate?) -> T? {
        print(NSStringFromClass(T.self))
        if let object = self.objectsFromEntity(predicate)?.first as T? {
            return object
        } else {
            return nil
        }
    }
    
    open func objectsFromEntity<T : NSManagedObject>(_ predicate:NSPredicate?) -> [T]? {
        let request = NSFetchRequest<T>(entityName: NSStringFromClass(T.self))
        request.predicate = predicate
        do {
            let results:[T] = try managedObjectContext.fetch(request)
            return results
        } catch {
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            return nil
        }
    }
    
    open func uniqueIdForEntity<T : NSManagedObject>(_ type: T.Type) -> Int? {
        let request = NSFetchRequest<T>(entityName: NSStringFromClass(T.self))
        do {
            let items = try managedObjectContext.fetch(request)
            return items.count
        } catch {
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            return nil
        }
    }
    
    open func pagedObjectsFromEntity<T : NSManagedObject>(_ predicate:NSPredicate?, limit:Int = 10, offset:Int = 0) -> [T]? {
        print(NSStringFromClass(T.self))
        let request = NSFetchRequest<T>(entityName: NSStringFromClass(T.self))
        request.predicate = predicate
        request.fetchOffset = offset;
        request.fetchLimit = limit
        do {
            let results:[T] = try managedObjectContext.fetch(request)
            return results
        } catch {
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            return nil
        }
    }
    
    open func saveContext(_ completion:((_ succeded:Bool) -> Void)?) {
        var succeeded:Bool = true;
        do {
            if managedObjectContext.hasChanges {
                try self.managedObjectContext.save()
            }
        } catch {
            let nserror = error as NSError
            succeeded = false;
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        completion?(succeeded)

    }
    
    open func removeObject(_ object:NSManagedObject, completion: (_ succeded:Bool) -> Void) {
        var succeeded:Bool = true;
        do {
            self.managedObjectContext.delete(object)
            try self.managedObjectContext.save()
        } catch {
            let nserror = error as NSError
            succeeded = false;
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        completion(succeeded)
    }
    
    open func deleteAllEntities<T : NSManagedObject>(_ type: T.Type) {
        print(NSStringFromClass(T.self))
        let request = NSFetchRequest<T>(entityName: NSStringFromClass(T.self))
        
        do {
            let items = try managedObjectContext.fetch(request)
            
            for object in items
            {
                managedObjectContext.delete(object)
            }
            try self.managedObjectContext.save()
        } catch {
            print("Failed to fetch entity with \(error)")
        }
    }
}
