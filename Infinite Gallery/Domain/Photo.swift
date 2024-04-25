//
//  Photo.swift
//  Infinite Gallery
//
//  Created by Arthur Avagyan on 25.04.24.
//

import Foundation

class Photo: Codable {
	let albumId: Int
	let id: Int
	let title: String
	let url: URL
}
