//
//  MarsPhotoCollectionViewCell.swift
//  MarsRoversFloSportsCodingAssn
//
//  Created by Suhaib Mahmood on 10/30/19.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

class MarsPhotoCollectionViewCell: UICollectionViewCell{
    
    let marsPhotoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
//        imageView.backgroundColor = .yellow
        imageView.image = UIImage(named: "placeholder_image")
        imageView.clipsToBounds = true
        return imageView
    }()
    
    var request: AnyObject?
    
    var marsPhotoUrl: String? {
        didSet{
//            self.marsPhotoImageView.image =
            guard let safeUrl = marsPhotoUrl else{return}
//            print(safeUrl)
            let avatarRequest = ImageRequest(url: URL(string: safeUrl)!)
            self.request = avatarRequest
            avatarRequest.load(withCompletion: { [weak self] (avatar: UIImage?) in
                guard let avatar = avatar else {
                    return
                }
                self?.marsPhotoImageView.image = avatar
            })
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .red
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
