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
		}
		
		fetchAlbums { albums in
			DispatchQueue.main.async {
				completion(
					albums.map({ album in
						let albumModel = AlbumModel()
						albumModel.update(with: album)
						RealmManager.shared.saveObject(albumModel)
						return albumModel
					})
				)
				
				albums.forEach { [weak self] album in
					guard let self else { return }
					fetchPhotos(albumId: album.id) { photos in
						DispatchQueue.main.async {
							guard let albumModel = RealmManager.shared.getObject(ofType: AlbumModel.self, primaryKey: album.id) else { return }
							
							RealmManager.shared.write {
								albumModel.update(photos: photos)
							}
							
							completion([albumModel])
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
				completion(Array(albums))
			case .failure(let error):
				print(error)
			}
		}
	}
	
	private func fetchPhotos(albumId: Int, completion: @escaping ([Photo]) -> Void) {
		APIManager.shared.getPhotos(albumId: albumId) { result in
			switch result {
			case .success(let photos):
				completion(Array(photos))
			case .failure(let error):
				print(error)
			}
		}
	}
}
