//
//  ImageUtils.swift
//  Alamofire
//
//  Created by Fennoma on 02/12/2020.
//

import Foundation
import AlamofireImage

class PmzImageUtils {
    
    static func loadImage(_ imageUrl: String?, imageView: UIImageView) {
        if let iUrl = imageUrl {
            let url = URL(string: iUrl)!
            let placeholderImage = UIImage(named: "placeholder")
            let filter = AspectScaledToFillSizeWithRoundedCornersFilter(size: imageView.frame.size,radius: 0)
                
            imageView.af.setImage(
                withURL: url,
                placeholderImage: placeholderImage,
                filter: filter,
                imageTransition: .crossDissolve(0.2)
            )
        }
    }
}
