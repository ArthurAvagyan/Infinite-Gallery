//
//  GalleryUseCase.swift
//  Infinite Gallery
//
//  Created by Arthur Avagyan on 26.04.24.
//

import Foundation

final class GalleryUseCase {
	
	func getAlbumModels(_ completion: @escaping ([AlbumModel]) -> Void) {
		let result = RealmManager.shared.getAllObjects(ofType: AlbumModel.self)
		if !result.isEmpty {
			completion(Array(result))
			return
		}
		
		var dataModels: [AlbumModel] = []
		fetchAlbums { albums in
			albums.forEach { [weak self] album in
				guard let self else { return }
				fetchPhotos(albumId: album.id) { photos in
					DispatchQueue.main.async {
						let albumModel = AlbumModel()
						albumModel.update(with: album, photos: photos)
						RealmManager.shared.saveObject(albumModel)
						
						if let index = dataModels.firstIndex(where: { $0.id > albumModel.id }) {
							dataModels.insert(albumModel, at: index)
						} else {
							dataModels.append(albumModel)
						}
						
						if dataModels.count == albums.count {
							completion(dataModels)
						}
					}
				}
			}
		}
	}
}


extension GalleryUseCase {
	
	private func fetchAlbums(completion: @escaping ([Album]) -> Void) {
		APIManager.shared.getAlbums { result in
			switch result {
			case .success(let albums):
				completion(Array(albums.prefix(3)))
			case .failure(let error):
				print(error)
			}
		}
	}
	
	private func fetchPhotos(albumId: Int, completion: @escaping ([Photo]) -> Void) {
		APIManager.shared.getPhotos(albumId: albumId) { result in
			switch result {
			case .success(let photos):
				completion(Array(photos.prefix(3)))
			case .failure(let error):
				print(error)
			}
		}
	}
}
