//
//  AlbumViewModel.swift
//  Infinite Gallery
//
//  Created by Arthur Avagyan on 24.04.24.
//

import Foundation
import UIKit.UIImage
import Combine

final class AlbumViewModel: ViewModel {
	
	private var cancellables = Set<AnyCancellable>()

	private(set) var onReload = PassthroughSubject<Void, Never>()
	private(set) var onReloadAtIndex = PassthroughSubject<Int, Never>()
	
	private var photoModels: [Photo] = []
	var photos: [UIImage?] = []
	
	func update(with model: AlbumModel) {
		photoModels = model.photos
		guard photos.isEmpty else { return }
		photoModels.enumerated().forEach { (index, photo) in
			photos.append(nil)
			
			URLSession.shared.dataTaskPublisher(for: photo.url)
				.map { UIImage(data: $0.data) }
				.replaceError(with: nil)
				.receive(on: DispatchQueue.main)
				.sink(receiveValue: { [weak self] image in
					guard let self else { return }
					photos[index] = image
					onReloadAtIndex.send(index)
				})
				.store(in: &cancellables)
		}
	}
}
