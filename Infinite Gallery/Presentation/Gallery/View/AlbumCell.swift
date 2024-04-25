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
	
	private let containerView: AlbumView = {
		let view = AlbumView(frame: .zero, viewModel: AlbumViewModel())
		return view
	}()
		
	override init(frame: CGRect) {
		super.init(frame: frame)
		contentView.addSubview(containerView)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		containerView.frame = contentView.bounds
		contentView.layer.cornerRadius = 10
	}
	
	override func prepareForReuse() {
		super.prepareForReuse()

	}
	
	func configure(with model: AlbumModel) {
		containerView.viewModel.update(with: model)
	}
	
}
