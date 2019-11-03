//
//  MarsPhotoCollectionDetailVC.swift
//  MarsRoversFloSportsCodingAssn
//
//  Created by Suhaib Mahmood on 11/3/19.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

class MarsPhotoCollectionDetailVC: UIViewController, UIScrollViewDelegate {
    
    let roverImageObject: RoverImageData!
    let marsDetailPhotoScrollView = MarsDetailPhotoView()
    
    unowned var marsImageView: UIImageView {return marsDetailPhotoScrollView.marsImageView}
    unowned var idLabel: UILabel {return marsDetailPhotoScrollView.idLabel}
    unowned var solLabel: UILabel {return marsDetailPhotoScrollView.solLabel}
    unowned var eartDateLabel: UILabel {return marsDetailPhotoScrollView.earthDateLabel}
    
    init(marsRoverImageObject: RoverImageData) {
        self.roverImageObject = marsRoverImageObject
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        setupViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        marsDetailPhotoScrollView.delegate = self
    }
    
    func setupViews(){
        view.addSubview(marsDetailPhotoScrollView)
        marsDetailPhotoScrollView.fillSuperView()
        
        let marsDetailPhotoViewModel = MarsDetailPhotoViewModel(roverData: roverImageObject)
        marsDetailPhotoScrollView.setupViews(with: marsDetailPhotoViewModel)
        
        guard let imageUrl = roverImageObject.imageUrl else{return}
        let imageDownloader = ImageDownloader()
        imageDownloader.downloadImageCacheAndAssignToImageView(imageUrl: imageUrl, imageView: marsImageView)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
      return marsImageView
    }
}

