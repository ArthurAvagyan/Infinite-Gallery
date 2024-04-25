//
//  AlbumViewModel.swift
//  Infinite Gallery
//
//  Created by Arthur Avagyan on 24.04.24.
//

import Foundation

final class AlbumViewModel: ViewModel {
	
	let models: [Model] = [
		Model(text: "Facebook", backgroundColour: .systemBlue),
		Model(text: "Amazon", backgroundColour: .systemYellow),
		Model(text: "Netflix", backgroundColour: .systemRed),
//		Model(text: "Google", backgroundColour: .systemGreen),
	]
	
}
