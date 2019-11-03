//
//  MarsPhotoCollectionViewCell.swift
//  MarsRoversFloSportsCodingAssn
//
//  Created by Suhaib Mahmood on 10/30/19.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit
import Kingfisher

class MarsPhotoCollectionViewCell: UICollectionViewCell{
    
    let marsPhotoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "placeholder_image")
        imageView.kf.indicatorType = .activity
        imageView.clipsToBounds = true
        return imageView
    }()
    
    var marsPhotoUrl: String?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(){
        let padding = CGFloat(2)
        addSubview(marsPhotoImageView)
        marsPhotoImageView.anchor(top: safeAreaLayoutGuide.topAnchor, paddingTop: padding, bottom: safeAreaLayoutGuide.bottomAnchor, paddingBottom: padding, left: safeAreaLayoutGuide.leftAnchor, paddingLeft: padding, right: safeAreaLayoutGuide.rightAnchor, paddingRight: padding, width: 0, height: 0)
    }
    
}
