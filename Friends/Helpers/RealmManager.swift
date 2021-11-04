//
//  RealmManager.swift
//  Friends
//
//  Created by Emiray Nakip on 4.11.2021.
//

import Foundation
import RealmSwift

public class RealmManager {
    private let database: Realm
    
    static let sharedInstance = RealmManager()
    
    private init() {
        do {
            database = try Realm()
        }
        catch {
            fatalError(error.localizedDescription)
        }
    }
    
    /// Retrieves the given object type from the database.
    ///
    /// - Parameter object: The type of object to retrieve.
    /// - Returns: The results in the database for the given object type.
    public func fetch<T: Object>(object: T) -> Results<T> {
        return database.objects(T.self)
    }
    
    /// Writes the given object to the database.
    /// Custom error handling available as a closure parameter (default just returns).
    ///
    /// - Returns: Nothing
    public func save<T: Object>(object: T, _ errorHandler: @escaping ((_ error : Swift.Error) -> Void) = { _ in return }) {
        do {
            try database.write {
                database.add(object)
            }
        }
        catch {
            errorHandler(error)
        }
    }
    
    /// Overwrites the given object in the database if it exists. If not, it will write it as a new object.
    /// Custom error handling available as a closure parameter (default just returns).
    ///
    /// - Returns: Nothing
    public func update<T: Object>(object: T, errorHandler: @escaping ((_ error : Swift.Error) -> Void) = { _ in return }) {
        do {
            try database.write {
                database.add(object, update: .all)
            }
        }
        catch {
            errorHandler(error)
        }
    }
    
    /// Deletes the given object from the database if it exists.
    /// Custom error handling available as a closure parameter (default just returns).
    ///
    /// - Returns: Nothing
    public func delete<T: Object>(object: T, errorHandler: @escaping ((_ error : Swift.Error) -> Void) = { _ in return }) {
        do {
            try database.write {
                database.delete(object)
            }
        }
        catch {
            errorHandler(error)
        }
    }
    
    /// Deletes all existing data from the database. This includes all objects of all types.
    /// Custom error handling available as a closure parameter (default just returns).
    ///
    /// - Returns: Nothing
    public func deleteAll(errorHandler: @escaping ((_ error : Swift.Error) -> Void) = { _ in return }) {
        do {
            try database.write {
                database.deleteAll()
            }
        }
        catch {
            errorHandler(error)
        }
    }
    
    /// Write method (supports save, update + delete) to be used in asynchronous situations. Write logic is passed in via the "action" closure parameter.
    /// Custom error handling available as a closure parameter (default just returns).
    ///
    /// - Returns: Nothing
    public func asyncWrite<T: ThreadConfined>(object: T, errorHandler: @escaping ((_ error : Swift.Error) -> Void) = { _ in return }, action: @escaping ((Realm, T?) -> Void)) {
        let threadSafeRef = ThreadSafeReference(to: object)
        let config = self.database.configuration
        DispatchQueue(label: "background").async {
            autoreleasepool {
                do {
                    let realm = try Realm(configuration: config)
                    let obj = realm.resolve(threadSafeRef)
                    
                    try realm.write {
                        action(realm, obj)
                    }
                }
                catch {
                    errorHandler(error)
                }
            }
        }
    }
}
