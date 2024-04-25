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
		layout.itemSize = CGSize(width: (UIScreen.main.bounds.size.width - 20), height: ((UIScreen.main.bounds.size.height - 140) / 3))
		
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
	
	private var storedOffsets: [IndexPath: CGFloat] = [:]

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
		
	}
}

extension GalleryView: UICollectionViewDelegate {
	
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		let itemSize = collectionView.contentSize.height / CGFloat(viewModel.models.count + 3)
		
		if scrollView.contentOffset.y > itemSize * CGFloat(viewModel.models.count){
			collectionView.contentOffset.y -= itemSize * CGFloat(viewModel.models.count)
		}
		if scrollView.contentOffset.y < 0  {
			collectionView.contentOffset.y += itemSize * CGFloat(viewModel.models.count)
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
		let cell = cell as! AlbumCell
		cell.contentOffset = storedOffsets[indexPath] ?? 0
	}
	
	func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
		let cell = cell as! AlbumCell
		storedOffsets[indexPath] = cell.contentOffset
	}
}

extension GalleryView: UICollectionViewDataSource {
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		viewModel.models.count + 3
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlbumCell.identifier, for: indexPath) as! AlbumCell
		
		let index = indexPath.item % viewModel.models.count
		
		cell.configure(with: viewModel.models[index])
		return cell
	}
}
