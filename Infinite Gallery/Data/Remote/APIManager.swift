//
//  APIManager.swift
//  Infinite Gallery
//
//  Created by Arthur Avagyan on 25.04.24.
//

import Foundation

class APIManager {
	
	static let shared = APIManager()
	
	private let baseURL = "https://jsonplaceholder.typicode.com"
	
	private init() {}
	
	func getAlbums(completion: @escaping (Result<[Album], Error>) -> Void) {
		let url = URL(string: baseURL + "/albums")!
		
		RequestManager.shared.makeRequest(url: url, method: .get) { (result: Result<[Album], Error>) in
			completion(result)
		}
	}
	
	func getPhotos(albumId: Int, completion: @escaping (Result<[Photo], Error>) -> Void) {
		let url = URL(string: baseURL + "/photos?albumId=\(albumId)")!
		
		RequestManager.shared.makeRequest(url: url, method: .get) { (result: Result<[Photo], Error>) in
			completion(result)
		}
	}
}
