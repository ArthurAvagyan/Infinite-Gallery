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
	
	private let collectionView: UICollectionView = {
		
		let layout = UICollectionViewFlowLayout()
		layout.scrollDirection = .horizontal
		layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
		layout.minimumInteritemSpacing = 10
		layout.minimumLineSpacing = 10
		layout.itemSize = CGSize(width: (UIScreen.main.bounds.size.width - 40) / 1.5, height: ((UIScreen.main.bounds.size.height / 2)))
		
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
		viewModel.onReload
			.receive(on: DispatchQueue.main)
			.sink { [weak self] _ in
				self?.collectionView.reloadData()
			}
			.store(in: &cancellables)
		
		viewModel.onReloadAtIndex
			.receive(on: DispatchQueue.main)
			.sink { [weak self] index in
				self?.collectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
			}
			.store(in: &cancellables)
	}
}

extension AlbumView: UICollectionViewDelegate {
	
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		let itemSize = collectionView.contentSize.width / CGFloat(viewModel.photos.count)
		
		if scrollView.contentOffset.x > itemSize {
			
			if let firstItem = viewModel.photos.first {
				viewModel.photos.removeFirst()
				viewModel.photos.append(firstItem)
				collectionView.contentOffset.x -= itemSize
				collectionView.reloadData()
			}
		}
		if scrollView.contentOffset.x < 0 {
			
			if let lastItem = viewModel.photos.last {
				viewModel.photos.removeLast()
				viewModel.photos.insert(lastItem, at: 0)
				collectionView.contentOffset.x += itemSize
				collectionView.reloadData()
			}
		}
	}
}

extension AlbumView: UICollectionViewDataSource {
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		viewModel.photos.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.identifier, for: indexPath) as! ImageCell
		
		let index = indexPath.row % viewModel.photos.count

		cell.configure(with: viewModel.photos[index])
		return cell
	}
}
