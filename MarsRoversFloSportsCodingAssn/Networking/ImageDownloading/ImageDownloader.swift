//
//  ImageDownloader.swift
//  MarsRoversFloSportsCodingAssn
//
//  Created by Suhaib Mahmood on 11/3/19.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit
import Kingfisher

struct ImageDownloader{
    func downloadImageCacheAndAssignToImageView(imageUrl: String, imageView: UIImageView){

        guard let safeUrl = URL(string: imageUrl) else{return}
        
        imageView.kf.setImage(with: safeUrl,
                                       placeholder: UIImage(named: "placeholder_image"),
                                       options: [
                                        .transition(.fade(1))//,
                                        //                                            .processor(DownsamplingImageProcessor(size: marsPhotoImageView.frame.size)),
                                        //                                            .scaleFactor(UIScreen.main.scale),
                                        //                                            .cacheOriginalImage
        ]) { [weak imageView] result in
            switch result{
            case .success(let value):
                if value.source.url != safeUrl{
                    imageView?.image = UIImage(named: "placeholder_image")
                }
            case .failure(let error):
                print("Job failed: \(error.localizedDescription)")
            }
        }
    }
}
