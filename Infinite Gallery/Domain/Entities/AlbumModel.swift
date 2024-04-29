//
//  AlbumModel.swift
//  Infinite Gallery
//
//  Created by Arthur Avagyan on 25.04.24.
//

import Foundation
import RealmSwift

class AlbumModel: Object {
	@Persisted(primaryKey: true) var id: Int
	@Persisted var title: String
	@Persisted var photos: List<PhotoModel>
	
	func update(with album: Album) {
		id = album.id
		title = album.title
	}
	
	func update( photos: [Photo]) {
		let photoModels = photos.map { photo in
			let model = PhotoModel()
			model.albumId = photo.albumId
			model.id = photo.id
			model.title = photo.title
			model.url = photo.url.absoluteString
			return model
		}
		self.photos.append(objectsIn: photoModels)
	}
}
