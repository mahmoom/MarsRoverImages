//
//  MarsPhotoCollectionView.swift
//  MarsRoversFloSportsCodingAssn
//
//  Created by Suhaib Mahmood on 11/4/19.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit
class MarsPhotoCollectionView: UICollectionView{
    
    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
        if #available(iOS 13.0, *) {
            indicator.style = .large
        } else {
            // Fallback on earlier versions
            indicator.style = .whiteLarge
        }
        indicator.color = .gray
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.startAnimating()
        return indicator
    }()

    let emptyCollectionLabel: UILabel = {
        let l = UILabel()
        l.sizeToFit()
        l.numberOfLines = 0
        l.isHidden = true
        l.textAlignment = .center
        l.textColor = .white
        l.text = "There's no data to display right now, try different search parameters!"
        return l
    }()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        createSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createSubviews(){
        backgroundColor = .black
        addSubview(emptyCollectionLabel)
        addSubview(activityIndicator)
        
        activityIndicator.anchorCenterSuperview()
        emptyCollectionLabel.anchorCenterSuperview()
        emptyCollectionLabel.widthAnchor.constraint(equalToConstant: 250).isActive = true
    }
}

