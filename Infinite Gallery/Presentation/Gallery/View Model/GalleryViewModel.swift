//
//  GalleryViewModel.swift
//  Infinite Gallery
//
//  Created by Arthur Avagyan on 25.04.24.
//

import Foundation
import Combine


final class GalleryViewModel: ViewModel {
	
	private(set) var onReload = PassthroughSubject<Void, Never>()

	var dataModels: [AlbumModel] = []
	
	init() {
		fetchAlbums { albums in
			albums.forEach { [weak self] album in
				guard let self else { return }
				fetchPhotos(albumId: album.id) { [weak self] photos in
					guard let self else { return }
					
					let albumModel = AlbumModel(album: album, photos: photos)
					
					if let index = self.dataModels.firstIndex(where: { $0.id > albumModel.id }) {
						self.dataModels.insert(albumModel, at: index)
					} else {
						self.dataModels.append(albumModel)
					}
					
					if dataModels.count == albums.count {
						onReload.send()
					}
				}
			}
		}
	}
}

extension GalleryViewModel {
	
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
