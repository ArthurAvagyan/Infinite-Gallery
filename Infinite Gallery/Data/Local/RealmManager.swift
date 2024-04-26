//
//  RealmManager.swift
//  Infinite Gallery
//
//  Created by Arthur Avagyan on 25.04.24.
//

import Foundation
import RealmSwift

class RealmManager {
	
	static let shared = RealmManager()
	
	private init() {}
	
	// MARK: - Realm Configuration
	
	func configure() {
		do {
			let realm = try Realm()
			print("Realm file location: \(realm.configuration.fileURL?.absoluteString ?? "Not found")")
		} catch {
			print("Error initializing Realm: \(error.localizedDescription)")
		}
	}
	
	// MARK: - CRUD Operations
	func write(_ block: (() -> Void)) {
		do {
			let realm = try Realm()
			try realm.write(block)
		} catch {
			print("Error saving object to Realm: \(error.localizedDescription)")
		}
	}
	func saveObject<T: Object>(_ object: T) {
		do {
			let realm = try Realm()
			try realm.write {
				realm.add(object, update: .modified)
			}
		} catch {
			print("Error saving object to Realm: \(error.localizedDescription)")
		}
	}
	
	func deleteObject<T: Object>(_ object: T) {
		do {
			let realm = try Realm()
			try realm.write {
				realm.delete(object)
			}
		} catch {
			print("Error deleting object from Realm: \(error.localizedDescription)")
		}
	}
	
	func getAllObjects<T: Object>(ofType type: T.Type) -> Results<T>? {
		do {
			let realm = try Realm()
			return realm.objects(type)
		} catch {
			print("Error retrieving objects from Realm: \(error.localizedDescription)")
			return nil
		}
	}
	
	func getObject<T: Object, KeyType>(ofType type: T.Type, primaryKey: KeyType) -> T? {
		do {
			let realm = try Realm()
			return realm.object(ofType: type, forPrimaryKey: primaryKey)
		} catch {
			print("Error retrieving object from Realm: \(error.localizedDescription)")
			return nil
		}
	}
}
