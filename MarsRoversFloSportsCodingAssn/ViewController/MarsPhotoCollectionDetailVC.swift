//
//  MarsPhotoCollectionDetailVC.swift
//  MarsRoversFloSportsCodingAssn
//
//  Created by Suhaib Mahmood on 11/3/19.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit
import Kingfisher

class MarsPhotoCollectionDetailVC: UIViewController, UIScrollViewDelegate {
    
    let roverImageObject: RoverImageData!
    let marsDetailPhotoScrollView = MarsDetailPhotoView()
    
    unowned var marsImageView: UIImageView {return marsDetailPhotoScrollView.marsImageView}
    
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
        
        guard let imageUrlString = roverImageObject.imageUrl, let imageUrl = URL(string: imageUrlString) else{return}
//        let imageDownloader = ImageDownloader()
//        imageDownloader.downloadImageCacheAndAssignToImageView(imageUrl: imageUrl, imageView: marsImageView)
        marsImageView.kf.setImage(with: imageUrl,
        placeholder: UIImage(named: "placeholder_image"))
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
      return marsImageView
    }
}

