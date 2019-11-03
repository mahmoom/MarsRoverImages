//
//  MarsPhotoDetailView.swift
//  MarsRoversFloSportsCodingAssn
//
//  Created by Suhaib Mahmood on 11/3/19.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

class MarsDetailPhotoView: UIScrollView {
    
        let marsImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.image = UIImage(named: "placeholder_image")
            imageView.contentMode = .scaleAspectFit
            return imageView
        }()
    
        let idLabel: UILabel = {
            let label = UILabel()
            label.text = "id: "
            label.font = UIFont.systemFont(ofSize: UIFont.systemFontSize * 1.2)
            label.textColor = .white
            label.adjustsFontSizeToFitWidth = true
            label.numberOfLines = 0
            return label
        }()
        
        let solLabel: UILabel = {
            let label = UILabel()
            label.text = "Sol: "
            label.font = UIFont.systemFont(ofSize: UIFont.systemFontSize * 1.2)
            label.textColor = .white
            label.adjustsFontSizeToFitWidth = true
            return label
        }()
        
        let earthDateLabel: UILabel = {
            let label = UILabel()
            label.text = "Earth date: "
            label.font = UIFont.systemFont(ofSize: UIFont.systemFontSize * 1.2)
            label.textColor = .white
            label.adjustsFontSizeToFitWidth = true
            return label
        }()
    
    let cameraNameLabel: UILabel = {
            let label = UILabel()
            label.text = "Camera: "
            label.font = UIFont.systemFont(ofSize: UIFont.systemFontSize * 1.2)
            label.textColor = .white
            label.adjustsFontSizeToFitWidth = true
            return label
        }()
    
    let roverNameLabel: UILabel = {
            let label = UILabel()
            label.text = "Rover Name: "
            label.font = UIFont.systemFont(ofSize: UIFont.systemFontSize * 1.2)
            label.textColor = .white
            label.adjustsFontSizeToFitWidth = true
            return label
        }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupScrollView()
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupScrollView(){
        alwaysBounceVertical = false
        alwaysBounceHorizontal = false
        showsVerticalScrollIndicator = true
        minimumZoomScale = 1.0
        maximumZoomScale = 10.0
        backgroundColor = .black
        isUserInteractionEnabled = true
    }
    
    func setupViews(){
        addSubview(marsImageView)
        marsImageView.fillSuperView()
        addSubview(idLabel)
        addSubview(solLabel)
        addSubview(earthDateLabel)
        addSubview(roverNameLabel)
        addSubview(cameraNameLabel)
        
        idLabel.anchor(top: safeAreaLayoutGuide.topAnchor, paddingTop: 25, bottom: nil, paddingBottom: 0, left: nil, paddingLeft: 0, right: safeAreaLayoutGuide.rightAnchor, paddingRight: 25, width: 0, height: 0)
        solLabel.anchor(top: idLabel.bottomAnchor, paddingTop: 10, bottom: nil, paddingBottom: 0, left: nil, paddingLeft: 0, right: idLabel.rightAnchor, paddingRight: 0, width: 0, height: 0)
        earthDateLabel.anchor(top: solLabel.bottomAnchor, paddingTop: 10, bottom: nil, paddingBottom: 0, left: nil, paddingLeft: 0, right: idLabel.rightAnchor, paddingRight: 0, width: 0, height: 0)
        roverNameLabel.anchor(top: earthDateLabel.bottomAnchor, paddingTop: 10, bottom: nil, paddingBottom: 0, left: nil, paddingLeft: 0, right: idLabel.rightAnchor, paddingRight: 0, width: 0, height: 0)
        cameraNameLabel.anchor(top: roverNameLabel.bottomAnchor, paddingTop: 10, bottom: nil, paddingBottom: 0, left: nil, paddingLeft: 0, right: idLabel.rightAnchor, paddingRight: 0, width: 0, height: 0)
    }
    
    func setupViews(with marsDetailPhotoViewModel: MarsDetailPhotoViewModel){
        self.earthDateLabel.text = marsDetailPhotoViewModel.eartDateLabelText
        self.idLabel.text = marsDetailPhotoViewModel.idLabelText
        self.solLabel.text = marsDetailPhotoViewModel.solLabelText
        self.roverNameLabel.text = marsDetailPhotoViewModel.roverLabelText
        self.cameraNameLabel.text = marsDetailPhotoViewModel.cameraLabelText
    }
}
