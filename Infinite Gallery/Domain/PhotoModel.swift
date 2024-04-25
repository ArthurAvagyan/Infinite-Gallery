//
//  PhotoModel.swift
//  Infinite Gallery
//
//  Created by Arthur Avagyan on 26.04.24.
//

import Foundation
import RealmSwift

class PhotoModel: Object {
	@Persisted var albumId: Int
	@Persisted var id: Int
	@Persisted var title: String
	@Persisted var url: String
	@Persisted var image: Data? = nil
}
