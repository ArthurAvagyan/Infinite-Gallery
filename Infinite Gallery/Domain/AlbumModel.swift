//
//  AlbumModel.swift
//  Infinite Gallery
//
//  Created by Arthur Avagyan on 25.04.24.
//

import Foundation

struct AlbumModel {
	let userId: Int
	let id: Int
	let title: String
	let photos: [Photo]
	
	init(album: Album, photos: [Photo]) {
		userId = album.userId
		id = album.id
		title = album.title
		self.photos = photos
	}
}
