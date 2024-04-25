//
//  View.swift
//  Infinite Gallery
//
//  Created by Arthur Avagyan on 24.04.24.
//

import UIKit
import Combine

typealias View<T: ViewModel> = ViewClass<T> & Subviewable & Bindable

protocol Subviewable {
	func setupViews()
	func setupConstraints()
}

protocol Bindable {
	func setupBindings()
}

class ViewClass<T: ViewModel>: UIView {
	
	let viewModel: T
	
	var cancellables = Set<AnyCancellable>()
	
	required init(frame: CGRect, viewModel: T) {
		self.viewModel = viewModel
		super.init(frame: frame)
		
		if let self = self as? Subviewable {
			self.setupViews()
			self.setupConstraints()
		}
		if let self = self as? Bindable {
			self.setupBindings()
		}
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
