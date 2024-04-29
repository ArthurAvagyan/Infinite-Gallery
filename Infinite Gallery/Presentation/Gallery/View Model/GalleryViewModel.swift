//
//  GalleryViewModel.swift
//  Infinite Gallery
//
//  Created by Arthur Avagyan on 25.04.24.
//

import Foundation
import Combine
import RealmSwift

final class GalleryViewModel: ViewModel {
	
	private(set) var onReload = PassthroughSubject<Void, Never>()
	private(set) var onReloadWithOffset = PassthroughSubject<(CGFloat, IndexPath, IndexPath), Never>()

	var dataModels: [AlbumModel] = []
	private(set) var storedOffsets: [CGFloat?] = []
	private let useCase: GalleryUseCase
	
	init(useCase: GalleryUseCase = GalleryUseCase()) {
		self.useCase = useCase
		
		useCase.getAlbumModels { [weak self] albumModels in
			guard let self else { return }
			
			dataModels = albumModels
			storedOffsets = Array(repeating: nil, count: dataModels.count)
			
			onReload.send()
		}
	}
	
	func scrolled(by offset: CGFloat, with estimatedItemSize: CGFloat, _ offsetForIndexPath: (IndexPath) -> CGFloat?) {
		if offset > estimatedItemSize {
			updateOffsets(offsetForIndexPath)
			dataModels.move(fromOffsets: IndexSet(integer: 0), toOffset: dataModels.count)
			storedOffsets.move(fromOffsets: IndexSet(integer: 0), toOffset: dataModels.count)
			onReloadWithOffset.send((-estimatedItemSize, IndexPath(item: 0, section: 0), IndexPath(item: dataModels.count - 1, section: 0)))
		} else if offset < 0 {
			updateOffsets(offsetForIndexPath)
			dataModels.move(fromOffsets: IndexSet(integer: dataModels.count - 1), toOffset: 0)
			storedOffsets.move(fromOffsets: IndexSet(integer: dataModels.count - 1), toOffset: 0)
			onReloadWithOffset.send((estimatedItemSize, IndexPath(item: dataModels.count - 1, section: 0), IndexPath(item: 0, section: 0)))
		}
	}
	
	private func updateOffsets(_ offsetForIndexPath: (IndexPath) -> CGFloat?) {
		dataModels.indices.forEach {
			if let offset = offsetForIndexPath(IndexPath(item: $0, section: 0)) {
				storedOffsets[$0] = offset
			}
		}
	}
}
