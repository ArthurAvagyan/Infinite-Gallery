//
//  AlbumViewModel.swift
//  Infinite Gallery
//
//  Created by Arthur Avagyan on 24.04.24.
//

import Foundation
import UIKit.UIImage
import Combine
import RealmSwift

final class AlbumViewModel: ViewModel {
	
	private var cancellables = Set<AnyCancellable>()

	private(set) var onReload = PassthroughSubject<Void, Never>()
	private(set) var onReloadAtIndex = PassthroughSubject<Int, Never>()
	
	var photoModels: [PhotoModel] = []
	var photos: [UIImage?] {
		photoModels.map { photo in
			guard let data = photo.image else { return nil }
			return UIImage(data: data)
		}
	}
	
	func update(with model: AlbumModel) {
		photoModels = Array(model.photos)

		photoModels.enumerated().forEach { (index, photo) in
			guard let url = URL(string: photo.url),
				  photo.image == nil else { return }
			URLSession.shared.dataTaskPublisher(for: url)
				.map { UIImage(data: $0.data) }
				.replaceError(with: nil)
				.receive(on: DispatchQueue.main)
				.sink(receiveValue: { [weak self] image in
					guard let self else { return }
					RealmManager.shared.write {
						self.photoModels[index].image = image?.pngData()
						self.onReloadAtIndex.send(index)
					}
				})
				.store(in: &cancellables)
		}
	}
}
