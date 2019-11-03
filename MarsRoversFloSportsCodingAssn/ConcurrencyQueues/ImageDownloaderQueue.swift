////
////  ImageDownloaderQueue.swift
////  MarsRoversFloSportsCodingAssn
////
////  Created by Suhaib Mahmood on 11/3/19.
////  Copyright © 2019 test. All rights reserved.
////
//
//import UIKit
//import Kingfisher
//
////class ImageDownloader: Operation {
////  //1
////  let roverImageObj: RoverImageData
////
////  //2
////  init(_ roverImageObj: RoverImageData) {
////    self.roverImageObj = roverImageObj
////  }
////
////  //3
////  override func main() {
////    //4
////    if isCancelled {
////      return
////    }
////
////    guard let safeUrlString = roverImageObj.imageUrl else{return}
////    guard let safeUrl = URL(string: safeUrlString) else{return}
////
////
////
////    roverImageObj.kf.setImage(with: safeUrl, placeholder: UIImage(named: "placeholder_image"), options: [.transition(.fade(1))], progressBlock: nil) { [weak self] result in
////        switch result{
////        case .success(let value):
////            if value.source.url != safeUrl{
////                self?.marsPhotoImageView.image = UIImage(named: "placeholder_image")
////            }
////        case .failure(let error):
////            print("Job failed: \(error.localizedDescription)")
////        }
////    }
////
////
////
////    //5
//////    guard let imageData = try? Data(contentsOf: photoRecord.imageUrl) else { return }
////
////    //6
////    if isCancelled {
////      return
////    }
////
//////    //7
//////    if !imageData.isEmpty {
//////      photoRecord.image = UIImage(data:imageData)
////////      photoRecord.state = .downloaded
//////    } else {
////////      photoRecord.state = .failed
////////      photoRecord.image = UIImage(named: "Failed")
//////    }
////  }
////}
//
//
////class DataLoadOperation: Operation {
////  // 1
////  var roverImageObj: RoverImageData?
////  var loadingCompleteHandler: ((RoverImageData) -> Void)?
////  
////  private let _roverImageObj: RoverImageData
////  
////  // 2
////  init(_ roverImageObj: RoverImageData) {
////    _roverImageObj = roverImageObj
////  }
////  
////  // 3
////  override func main() {
////    // 1
////    if isCancelled { return }
////        
////    // 2
//////    let randomDelayTime = Int.random(in: 500..<2000)
//////    usleep(useconds_t(randomDelayTime * 1000))
////
////    // 3
////    if isCancelled { return }
////
////    // 4
////    emojiRating = _emojiRating
////
////    // 5
////    if let loadingCompleteHandler = loadingCompleteHandler {
////      DispatchQueue.main.async {
////        loadingCompleteHandler(self._emojiRating)
////      }
////    }
////  }
////}
//
//
//// This enum contains all the possible states a photo record can be in
//enum PhotoRecordState {
//  case new, downloaded, failed
//}
//
//class PhotoRecord {
//  let name: String
//  let url: URL
//  var state = PhotoRecordState.new
//  var image = UIImage(named: "Placeholder")
//  
//  init(name:String, url:URL) {
//    self.name = name
//    self.url = url
//  }
//}
