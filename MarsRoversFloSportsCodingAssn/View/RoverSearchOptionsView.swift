//
//  RoverSearchOptionsView.swift
//  MarsRoversFloSportsCodingAssn
//
//  Created by Suhaib Mahmood on 11/4/19.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit
import DropDown

class RoverSearchOptionsView: UIView {
    let cameraSelectionLabel: UILabel = {
        let label = UILabel()
        label.text = AllCameras.NONE.rawValue
        label.isUserInteractionEnabled = true
        label.tag = 2
        label.textAlignment = .center
        return label
    }()
    
    let roverSelectionLabel: UILabel = {
        let label = UILabel()
        label.text = Rovers.curiosity.rawValue
        label.isUserInteractionEnabled = true
        label.textAlignment = .center
        label.tag = 1
        return label
    }()
    
    let dateTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "xx/xx/xxxx"
        tf.tintColor = .clear
        tf.text = Constants.defaultEarthDate
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.adjustsFontSizeToFitWidth = true
        return tf
    }()
    
    let cameraLabel: UILabel = {
        let label = UILabel()
        label.text = "Camera"
        label.textAlignment = .center
        return label
    }()
    
    let roverLabel: UILabel = {
        let label = UILabel()
        label.text = "Rover"
        label.textAlignment = .center
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "Date"
        label.textAlignment = .center
        return label
    }()
    
    let instructionsLabel: UILabel = {
        let label = UILabel()
        label.text = "Select your search parameters and then press the button below to view some photos that are out of this world!"
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        return label
    }()
    
    let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        let userCalendar = NSCalendar.current
        picker.maximumDate = Date()
        return picker
    }()
    
    
    let overallStackView: UIStackView = {
        let sV = UIStackView()
        sV.distribution = .equalSpacing
        sV.alignment = .center
        sV.axis = .horizontal
        return sV
    }()
    
    let cameraStackView: UIStackView = {
        let sV = UIStackView()
        sV.distribution = .equalSpacing
        sV.alignment = .center
        sV.axis = .vertical
        return sV
    }()
    
    let roverStackView: UIStackView = {
        let sV = UIStackView()
        sV.distribution = .equalSpacing
        sV.alignment = .center
        sV.axis = .vertical
        return sV
    }()
    
    let dateStackView: UIStackView = {
        let sV = UIStackView()
        sV.distribution = .equalSpacing
        sV.alignment = .center
        sV.axis = .vertical
        return sV
    }()
    
    let searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Search!", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var cameraSeletionDropDown = DropDown()
    
    var roverSeletionDropDown = DropDown()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(){
        backgroundColor = .white
        addSubview(instructionsLabel)
        
        addSubview(overallStackView)
        overallStackView.addArrangedSubview(roverStackView)
        overallStackView.addArrangedSubview(cameraStackView)
        overallStackView.addArrangedSubview(dateStackView)
        roverStackView.addArrangedSubview(roverLabel)
        roverStackView.addArrangedSubview(roverSelectionLabel)
        cameraStackView.addArrangedSubview(cameraLabel)
        cameraStackView.addArrangedSubview(cameraSelectionLabel)
        dateStackView.addArrangedSubview(dateLabel)
        dateStackView.addArrangedSubview(dateTextField)
        addSubview(searchButton)
        
        let padding = CGFloat(25)
        let anchorPadding = frame.width/6
        
        instructionsLabel.anchorCenterXToSuperview()
        instructionsLabel.widthAnchor.constraint(equalToConstant: 250).isActive = true
        instructionsLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: frame.width/5).isActive = true
        overallStackView.anchor(top: instructionsLabel.bottomAnchor, paddingTop: anchorPadding, bottom: nil, paddingBottom: 0, left: safeAreaLayoutGuide.leftAnchor, paddingLeft: anchorPadding, right: safeAreaLayoutGuide.rightAnchor, paddingRight: anchorPadding, width: 0, height: 0)
        roverStackView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        cameraStackView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        dateStackView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        let searchButtonTopConstraint = searchButton.topAnchor.constraint(greaterThanOrEqualTo: overallStackView.bottomAnchor, constant: padding)
        searchButtonTopConstraint.priority = UILayoutPriority(rawValue: 900)
        searchButtonTopConstraint.isActive = true
        
        searchButton.topAnchor.constraint(lessThanOrEqualTo: safeAreaLayoutGuide.bottomAnchor, constant: -50).isActive = true
        searchButton.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -anchorPadding).isActive = true
        
        dateTextField.inputView = datePicker
        cameraSeletionDropDown.anchorView = cameraSelectionLabel 
        roverSeletionDropDown.anchorView = roverSelectionLabel
    }
}
