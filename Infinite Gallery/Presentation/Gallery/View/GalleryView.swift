//
//  GalleryView.swift
//  Infinite Gallery
//
//  Created by Arthur Avagyan on 25.04.24.
//

import UIKit

final class GalleryView: View<GalleryViewModel> {
	
	private let collectionView: UICollectionView = {
		let layout = UICollectionViewFlowLayout()
		layout.scrollDirection = .vertical
		layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
		layout.minimumInteritemSpacing = 10
		layout.minimumLineSpacing = 10
		layout.itemSize = CGSize(width: (UIScreen.main.bounds.size.width - 20), height: ((UIScreen.main.bounds.size.height) / 1.5))
		
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
		collectionView.translatesAutoresizingMaskIntoConstraints = false
		collectionView.showsHorizontalScrollIndicator = false
		collectionView.showsVerticalScrollIndicator = false
		collectionView.register(AlbumCell.self, forCellWithReuseIdentifier: AlbumCell.identifier)
		collectionView.bounces = true
		collectionView.bouncesVertically = true
		collectionView.alwaysBounceVertical = true
		return collectionView
	}()
	
	private var storedOffsets: [CGFloat?] = []

	func setupViews() {
		collectionView.delegate = self
		collectionView.dataSource = self
		storedOffsets = Array(repeating: nil, count: viewModel.dataModels.count)
		addSubview(collectionView)
	}
	
	func setupConstraints() {
		NSLayoutConstraint.activate([
			collectionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
			collectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
			collectionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
			collectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
		])
	}
	
	func setupBindings() {
		viewModel.onReload
			.receive(on: DispatchQueue.main)
			.sink { [weak self] _ in
				guard let self else { return }
				storedOffsets = Array(repeating: nil, count: viewModel.dataModels.count)
				collectionView.reloadData()
			}
			.store(in: &cancellables)
	}
}

extension GalleryView: UICollectionViewDelegate {
	
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		let itemSize = collectionView.contentSize.height / CGFloat(viewModel.dataModels.count)
	
		if scrollView.contentOffset.y > itemSize {
			viewModel.dataModels.move(fromOffsets: IndexSet(integer: 0), toOffset: viewModel.dataModels.count)
			updateOffsets()
			storedOffsets.move(fromOffsets: IndexSet(integer: 0), toOffset: viewModel.dataModels.count)
			collectionView.contentOffset.y -= itemSize
			collectionView.reloadData()
		}
		if scrollView.contentOffset.y < 0 {
			viewModel.dataModels.move(fromOffsets: IndexSet(integer: viewModel.dataModels.count - 1), toOffset: 0)
			updateOffsets()
			storedOffsets.move(fromOffsets: IndexSet(integer: viewModel.dataModels.count - 1), toOffset: 0)
			collectionView.contentOffset.y += itemSize
			collectionView.reloadData()
		}
	}
	
	func updateOffsets() {
		(0..<viewModel.dataModels.count).forEach {
			if let cell = collectionView.cellForItem(at: IndexPath(item: $0, section: 0)) {
				storedOffsets[$0] = (cell as! AlbumCell).contentOffset
			}
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
		let cell = cell as! AlbumCell
		cell.contentOffset = storedOffsets[indexPath.item] ?? 0
	}
}

extension GalleryView: UICollectionViewDataSource {
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		viewModel.dataModels.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlbumCell.identifier, for: indexPath) as! AlbumCell
		cell.configure(with: viewModel.dataModels[indexPath.item])
		return cell
	}
}
