//
//  RequestManager.swift
//  Infinite Gallery
//
//  Created by Arthur Avagyan on 25.04.24.
//

import Foundation

import Foundation

enum HTTPMethod: String {
	case get = "GET"
	case post = "POST"
	// Add more HTTP methods as needed
}

final class RequestManager {
	
	static let shared = RequestManager()
	private let session: URLSession
	
	private init() {
		let configuration = URLSessionConfiguration.default
		configuration.timeoutIntervalForRequest = 30
		session = URLSession(configuration: configuration)
	}
	
	func makeRequest<T: Codable>(url: URL, method: HTTPMethod, body: Data? = nil, completion: @escaping (Result<T, Error>) -> Void) {
		
		var request = URLRequest(url: url)
		request.httpMethod = method.rawValue
		request.httpBody = body
		
		let task = session.dataTask(with: request) { data, response, error in
			guard let data = data, let response = response as? HTTPURLResponse, error == nil else {
				completion(.failure(error ?? NSError(domain: "RequestManager", code: -1, userInfo: nil)))
				return
			}
			
			guard (200...299).contains(response.statusCode) else {
				let statusCode = response.statusCode
				completion(.failure(NSError(domain: "RequestManager", code: statusCode, userInfo: nil)))
				return
			}
			
			do {
				let decodedData = try JSONDecoder().decode(T.self, from: data)
				completion(.success(decodedData))
			} catch {
				completion(.failure(error))
			}
		}
		
		task.resume()
	}
}
