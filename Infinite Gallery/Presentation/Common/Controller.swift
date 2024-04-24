//
//  Controller.swift
//  Infinite Gallery
//
//  Created by Arthur Avagyan on 24.04.24.
//

import UIKit
import Combine

class Controller<T: ViewModel, U: View<T>>: UIViewController, Bindable {
	
	let viewModel: T
	var contentView: U!
	
	var cancellables = Set<AnyCancellable>()
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	required init(viewModel: T) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}
	
	override func loadView() {
		super.loadView()
		contentView = U(frame: view.bounds, viewModel: viewModel)
		view = contentView
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupBindings()
	}
	
	func setupBindings() {}
}
