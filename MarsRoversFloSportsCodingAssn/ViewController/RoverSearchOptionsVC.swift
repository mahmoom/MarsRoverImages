//
//  RoverSearchOptionsVC.swift
//  MarsRoversFloSportsCodingAssn
//
//  Created by Suhaib Mahmood on 11/3/19.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit
import DropDown

class RoverSearchOptionsVC: UIViewController {
    
    //MARK: Outlet variables
    var roverSearchOptionsView: RoverSearchOptionsView!
    unowned var dateTextField: UITextField {return roverSearchOptionsView.dateTextField}
    unowned var roverSelectionLabel: UILabel {return roverSearchOptionsView.roverSelectionLabel}
    unowned var cameraSelectionLabel: UILabel {return roverSearchOptionsView.cameraSelectionLabel}
    unowned var searchButton: UIButton {return roverSearchOptionsView.searchButton}
    unowned var datePicker: UIDatePicker {return roverSearchOptionsView.datePicker}
    unowned var cameraSeletionDropDown: DropDown {return roverSearchOptionsView.cameraSeletionDropDown}
    unowned var roverSeletionDropDown: DropDown {return roverSearchOptionsView.roverSeletionDropDown}
    
    
    
    //MARK: Variables
    var cameraDropDownDataSource = [String]()
    var roverDropDownDataSource = [String]()
    let allCameras: [String] = {
        var cameras = [String]()
        for camera in AllCameras.allCases{
            cameras.append(camera.rawValue)
        }
        return cameras
    }()
    
    let curiosityCameras: [String] = {
        var cameras = [String]()
        for camera in CuriosityCameras.allCases{
            cameras.append(camera.rawValue)
        }
        return cameras
    }()
    
    let spiritOpportunityCameras: [String] = {
        var cameras = [String]()
        for camera in SpiritOpportunityCameras.allCases{
            cameras.append(camera.rawValue)
        }
        return cameras
    }()
    
    //MARK: VC Lifecycle
    override func loadView() {
        super.loadView()
        roverSearchOptionsView = RoverSearchOptionsView(frame: view.frame)
        view = roverSearchOptionsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActions()
    }
    
    //MARK: Helper Functions
    func setupActions(){
        self.title = "Choose Search Options"
        self.hideKeyboardWhenTappedAround()
        
        cameraSeletionDropDown.selectionAction = { [weak self] (index, selection) in
            self?.generateRoverSelectionDataSource(cameraSelection: selection)
            self?.cameraSelectionLabel.text = selection
        }
        roverSeletionDropDown.selectionAction = { [weak self] (index, selection) in
            self?.generateCameraSelectionDataSource(roverSelection: selection)
            self?.roverSelectionLabel.text = selection
        }

        //defaults
        generateCameraSelectionDataSource(roverSelection: Rovers.curiosity.rawValue)
        generateRoverSelectionDataSource(cameraSelection: AllCameras.NONE.rawValue)
        
        searchButton.addTarget(self, action: #selector(showPhotoGallery), for: .touchUpInside)
        datePicker.addTarget(self, action: #selector(dateChanged), for: UIControl.Event.valueChanged)
        
        let tappedGesture = UITapGestureRecognizer(target: self, action: #selector(displayDropDowns))
        let secondTappedGesture = UITapGestureRecognizer(target: self, action: #selector(displayDropDowns))
        
        cameraSelectionLabel.addGestureRecognizer(tappedGesture)
        roverSelectionLabel.addGestureRecognizer(secondTappedGesture)
    }
    
    func generateCameraSelectionDataSource(roverSelection: String){
        var dataSource = [String]()
        switch roverSelection {
        case Rovers.curiosity.rawValue:
            for camera in CuriosityCameras.allCases{
                dataSource.append(camera.rawValue)
            }
        default:
            for camera in SpiritOpportunityCameras.allCases{
                dataSource.append(camera.rawValue)
            }
        }
        cameraSeletionDropDown.dataSource = dataSource
    }
    
    func generateRoverSelectionDataSource(cameraSelection: String){
        var dataSource = [String]()
        if curiosityCameras.contains(cameraSelection){
            dataSource.append(Rovers.curiosity.rawValue)
        }
        if spiritOpportunityCameras.contains(cameraSelection){
            dataSource.append(Rovers.spirit.rawValue)
            dataSource.append(Rovers.opportunity.rawValue)
        }
        roverSeletionDropDown.dataSource = dataSource
    }
    
    @objc func displayDropDowns(_ sender: UITapGestureRecognizer){
        switch sender.view?.tag {
        case 1:
            roverSeletionDropDown.show()
        case 2:
            cameraSeletionDropDown.show()
        default:
            return
        }
    }
    
    @objc func dateChanged(){
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.medium
        formatter.timeStyle = .none
        dateTextField.text = formatter.string(from: datePicker.date)
    }

    @objc func showPhotoGallery(){
        guard let roverText = roverSelectionLabel.text, let roverEnumVal = Rovers(rawValue: roverText), let cameraText = cameraSelectionLabel.text, let cameraEnumVal = AllCameras(rawValue: cameraText), let dateText = dateTextField.text else{
            Alert.showBasic(title: "Sorry", message: "You entered some information we are unable to process", vc: self)
            return
        }
        let marsCollectionVC = MarsPhotoCollectionVC(collectionViewLayout: UICollectionViewFlowLayout())
        marsCollectionVC.roverToSearch = roverEnumVal
        marsCollectionVC.cameraToSearch = cameraEnumVal
        marsCollectionVC.date = convertDateToAPIFormat(dateText)
        self.navigationController?.pushViewController(marsCollectionVC, animated: true)
    }
    
    func convertDateToAPIFormat(_ dateString: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd,yyyy"
        guard let date = dateFormatter.date(from: dateString) else{
            return Constants.defaultEarthDate
        }
        dateFormatter.dateFormat = "yyyy-MM-DD"
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
}
