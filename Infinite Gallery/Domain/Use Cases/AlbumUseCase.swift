//
//  AlbumUseCase.swift
//  Infinite Gallery
//
//  Created by Arthur Avagyan on 26.04.24.
//

import UIKit.UIImage
import Combine

final class AlbumUseCase {
	
	private var cancellables = Set<AnyCancellable>()
	
	func getImages(for paths: [String], _ completion: @escaping (Int, UIImage?) -> Void) {
		paths.enumerated().forEach { (index, path) in
			
			guard let url = URL(string: path) else { 
				completion(index, nil)
				return
			}
			
			if let savedImage = RealmManager.shared.getObject(ofType: ImageModel.self, primaryKey: path) {
				completion(index, UIImage(data: savedImage.data))
				return
			}
			
			URLSession.shared.dataTaskPublisher(for: url)
				.map(\.data)
				.receive(on: DispatchQueue.main)
				.sink {
					switch $0 {
					case .finished:
						break
					case .failure(_):
						completion(index, nil)
					}
				} receiveValue: { imageData in
					let imageModel = ImageModel()
					imageModel.url = path
					imageModel.data = imageData
					RealmManager.shared.saveObject(imageModel)
					
					completion(index, UIImage(data: imageData))
				}
				.store(in: &cancellables)
		}
	}
}
