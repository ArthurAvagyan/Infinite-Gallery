//
//  AlbumCell.swift
//  Infinite Gallery
//
//  Created by Arthur Avagyan on 25.04.24.
//

import UIKit

final class AlbumCell: UICollectionViewCell {
	static let identifier = "cell"
	
	var contentOffset: CGFloat {
		set {
			containerView.contentOffset = newValue
		}
		get {
			containerView.contentOffset
		}
	}

	private let label: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.textColor = .black
		label.textAlignment = .center
		label.font = .systemFont(ofSize: 20, weight: .medium)
		return label
	}()
	
	private let containerView: AlbumView = {
		let view = AlbumView(frame: .zero, viewModel: AlbumViewModel())
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
		
	override init(frame: CGRect) {
		super.init(frame: frame)
		contentView.addSubview(label)
		contentView.addSubview(containerView)
		NSLayoutConstraint.activate([
			label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
			label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
			
			containerView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 8),
			containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
			containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
			containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
		])
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		contentView.layer.cornerRadius = 10
	}
	
	override func prepareForReuse() {
		super.prepareForReuse()
		containerView.collectionView.reloadData()
	}
	
	func configure(with model: AlbumModel) {
		containerView.viewModel.update(with: model)
		label.text = model.title
	}
}
