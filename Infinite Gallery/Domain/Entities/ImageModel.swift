//
//  ImageModel.swift
//  Infinite Gallery
//
//  Created by Arthur Avagyan on 26.04.24.
//

import Foundation
import RealmSwift

class ImageModel: Object {
	@Persisted(primaryKey: true) var url: String
	@Persisted var data: Data
}
