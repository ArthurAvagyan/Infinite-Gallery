//
//  ImageCell.swift
//  Infinite Gallery
//
//  Created by Arthur Avagyan on 24.04.24.
//

import UIKit

class ImageCell: UICollectionViewCell {
	static let identifier = "cell"
	
	private let imageView: UIImageView = {
		let imageView = UIImageView(frame: .zero)
		imageView.contentMode = .scaleAspectFill
		imageView.clipsToBounds = true
		imageView.layer.masksToBounds = true
		imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		return imageView
	}()
	
	override init(frame: CGRect){
		super.init(frame: frame)
		contentView.addSubview(imageView)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		imageView.frame = contentView.bounds
		contentView.layer.cornerRadius = 10
		contentView.layer.masksToBounds = true
		contentView.backgroundColor = .gray
	}
	
	override func prepareForReuse() {
		super.prepareForReuse()
		imageView.image = nil
	}
	
	func configure(with image: UIImage?) {
		image?.prepareForDisplay(completionHandler: { [weak self] preparedImage in
			DispatchQueue.main.async {
				self?.imageView.image = preparedImage
			}
		})
	}
}
