//
//  CoreDataManager.swift
//  roman_andruseiko_SimpleBooks
//
//  Created by Roman Andruseiko on 10/21/16.
//  Copyright © 2016 SimpleBooks. All rights reserved.
//

import Foundation
import CoreLocation

extension CoreDataManager {
    
    func getUser() -> User? {
        let users : [User]? = self.objectsFromEntity(nil)
        if (users?.count)! > 0 {
            return users?.first
        } else {
            return nil
        }
    }
    
    func createUser(id: String, name: String, token: String) -> User {
        let predicate = NSPredicate(format: "id == %@", id)
        let user : User = self.createEntity(predicate: predicate)
        user.facebookToken = token
        user.name = name
        self.saveContext(nil)
        return user
    }
    
    func isUserLoggedIn() -> Bool {
        let user : [User]? = self.objectsFromEntity(nil)
        return (user?.count)! > 0
    }
    
    func removeUsers() {
        self.deleteAllEntities(User.self)
        self.saveContext(nil)
    }
    
    func createBook(name: String, author: String, amazonURL: String, rank: String, isbnCode: String, image: NSData?) {
        guard let user = self.getUser() else {
            return
        }
        guard let id = self.uniqueIdForEntity(Book.self) else {
            return
        }
        let predicate = NSPredicate(format: "id == %d", id)
        let book : Book = self.createEntity(predicate: predicate)
        
        book.name = name
        book.author = author
        book.amazonURL = amazonURL
        book.rank = rank
        if image != nil {
            book.image = image
        }
        book.isbnCode = isbnCode
        user.addToBooks(book)
        self.saveContext(nil)
    }
    
    func getBookWithCode(isbnCode: String) -> Book?{
        let predicate = NSPredicate(format: "isbnCode == %@", isbnCode)
        let book : Book? = self.objectFromEntity(predicate)
        return book
    }
    
    func removeBookWithCode(isbnCode: String) {
        guard let user = self.getUser() else {
            return
        }
        let predicate = NSPredicate(format: "isbnCode == %@", isbnCode)
        if let book : Book = CoreDataManager.sharedInstance.objectFromEntity(predicate) {
            user.removeFromBooks(book)
            self.removeObject(book, completion: { (succeded) in
                if succeded {
                    self.saveContext(nil)
                }
            })
        }
    }
    
    func getAllBooks() -> [Book]? {
        guard let user = self.getUser() else {
            return nil
        }
        return user.books?.allObjects as? [Book]
    }
}
