//
//  GalleryViewModel.swift
//  Infinite Gallery
//
//  Created by Arthur Avagyan on 25.04.24.
//

import Foundation

final class GalleryViewModel: ViewModel {
	
	
	let models: [Model] = [
		Model(text: "Facebook", backgroundColour: .systemBlue),
		Model(text: "Amazon", backgroundColour: .systemYellow),
		Model(text: "Netflix", backgroundColour: .systemRed),
		//		Model(text: "Google", backgroundColour: .systemGreen),
	]
}
