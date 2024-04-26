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
	
	func setupViews() {
		collectionView.delegate = self
		collectionView.dataSource = self
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
				collectionView.reloadData()
			}
			.store(in: &cancellables)
		
		viewModel.onReloadWithOffset
			.sink { [weak self] offset in
				guard let self else { return }
				collectionView.contentOffset.y += offset
				collectionView.reloadData()
			}
			.store(in: &cancellables)
	}
}

extension GalleryView: UICollectionViewDelegate {
	
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		let estimatedItemSize = collectionView.contentSize.height / CGFloat(viewModel.dataModels.count)
		
		viewModel.scrolled(by: scrollView.contentOffset.y, with: estimatedItemSize) { indexPath in
			(collectionView.cellForItem(at: indexPath) as? AlbumCell)?.contentOffset
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
		let cell = cell as! AlbumCell
		cell.contentOffset = viewModel.storedOffsets[indexPath.item] ?? 0
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
