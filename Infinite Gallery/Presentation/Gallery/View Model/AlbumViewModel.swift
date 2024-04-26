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
	
	private(set) var onReloadWithOffset = PassthroughSubject<CGFloat, Never>()
	private(set) var onReloadAtIndex = PassthroughSubject<Int, Never>()
	
	private(set) var photoModels: [PhotoModel] = []
	private(set) var photos: [UIImage?] = []
	
	private let useCase: AlbumUseCase
	
	init(useCase: AlbumUseCase = AlbumUseCase()) {
		self.useCase = useCase
	}
}

extension AlbumViewModel {
	
	func update(with model: AlbumModel) {
		photoModels = Array(model.photos)
		photos = Array(repeating: nil, count: photoModels.count)
		
		useCase.getImages(for: photoModels.map { $0.url } ) { [weak self] index, image in
			guard let self else { return }
			
			photos[index] = image
			self.onReloadAtIndex.send(index)
		}
	}
	
	func scrolled(by offset: CGFloat, with estimatedItemSize: CGFloat) {
		if offset > estimatedItemSize {
			moveDataToRight()
			onReloadWithOffset.send(-estimatedItemSize)
		} else if offset < 0 {
			moveDataToLeft()
			onReloadWithOffset.send(estimatedItemSize)
		}
	}
}

extension AlbumViewModel {
	
	private func moveDataToRight() {
		photoModels.move(fromOffsets: IndexSet(integer: 0), toOffset: photoModels.count)
		photos.move(fromOffsets: IndexSet(integer: 0), toOffset: photoModels.count)
	}
	
	private func moveDataToLeft() {
		photoModels.move(fromOffsets: IndexSet(integer: photoModels.count - 1), toOffset: 0)
		photos.move(fromOffsets: IndexSet(integer: photoModels.count - 1), toOffset: 0)
	}
}
