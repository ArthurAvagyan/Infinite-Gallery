//
//  GalleryViewModel.swift
//  Infinite Gallery
//
//  Created by Arthur Avagyan on 25.04.24.
//

import Foundation
import Combine
import RealmSwift

final class GalleryViewModel: ViewModel {
	
	private(set) var onReload = PassthroughSubject<Void, Never>()

	var dataModels: [AlbumModel] = []

	init() {
		let result = RealmManager.shared.getAllObjects(ofType: AlbumModel.self)
		if let result, !result.isEmpty {
			dataModels = Array(result)
			onReload.send()
			return
		}
		fetchAlbums { albums in
			albums.forEach { [weak self] album in
				guard let self else { return }
				fetchPhotos(albumId: album.id) { [weak self] photos in
					guard let self else { return }
					
					// I am not sure about the solution, but on the first execution app crashes because "Realm accessed from incorrect thread."
					// I guess the reason is data being written on background thread here, and later used in the main thread in AlbumViewModel.swift: 29
					// An on the second execution GalleryViewModel.swift:19 runs on the main thread, and that's why it works the second time
					DispatchQueue.main.async {
						let albumModel = AlbumModel()
						albumModel.update(with: album, photos: photos)
						
						RealmManager.shared.saveObject(albumModel)
						
						if let index = self.dataModels.firstIndex(where: { $0.id > albumModel.id }) {
							self.dataModels.insert(albumModel, at: index)
						} else {
							self.dataModels.append(albumModel)
						}
						
						if self.dataModels.count == albums.count {
							self.onReload.send()
						}
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
