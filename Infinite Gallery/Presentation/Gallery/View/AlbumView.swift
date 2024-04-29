//
//  AlbumView.swift
//  Infinite Gallery
//
//  Created by Arthur Avagyan on 24.04.24.
//

import UIKit

final class AlbumView: View<AlbumViewModel> {
	
	var contentOffset: CGFloat {
		set {
			collectionView.contentOffset.x = newValue
		}
		get {
			collectionView.contentOffset.x
		}
	}
	
	let collectionView: UICollectionView = {
		let layout = UICollectionViewFlowLayout()
		layout.scrollDirection = .horizontal
		layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
		layout.minimumInteritemSpacing = 10
		layout.minimumLineSpacing = 10
		layout.itemSize = CGSize(width: (UIScreen.main.bounds.size.width - 40) / 3, height: ((UIScreen.main.bounds.size.height / 4)))
		
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
		collectionView.translatesAutoresizingMaskIntoConstraints = false
		collectionView.showsHorizontalScrollIndicator = false
		collectionView.showsVerticalScrollIndicator = false
		collectionView.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.identifier)
		collectionView.bounces = true
		collectionView.bouncesHorizontally = true
		collectionView.alwaysBounceHorizontal = true
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
		viewModel.onReloadAtIndex
			.receive(on: DispatchQueue.main)
			.sink { [weak self] index in
				UIView.performWithoutAnimation {
					self?.collectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
				}
			}
			.store(in: &cancellables)
		
		viewModel.onReloadWithOffset
			.sink { [weak self] offset in
				guard let self else { return }
				collectionView.contentOffset.x += offset
				collectionView.reloadData()
			}
			.store(in: &cancellables)
	}
}

extension AlbumView: UICollectionViewDelegate {
	
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		let estimatedItemSize = collectionView.contentSize.width / CGFloat(viewModel.photoModels.count)
		viewModel.scrolled(by: scrollView.contentOffset.x, with: estimatedItemSize)
	}
}

extension AlbumView: UICollectionViewDataSource {
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		viewModel.photoModels.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.identifier, for: indexPath) as! ImageCell
		cell.configure(with: viewModel.photos[indexPath.item])
		return cell
	}
}
