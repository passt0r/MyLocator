//
//  UIImage+Resize.swift
//  MyLocator
//
//  Created by Dmytro Pasinchuk on 26.06.17.
//  Copyright © 2017 Dmytro Pasinchuk. All rights reserved.
//

import UIKit

extension UIImage {
    func resizedImage(withBounds bounds: CGSize) -> UIImage {
        let horizontalRatio = bounds.width/size.width
        let verticalRatio = bounds.height/size.height
        let minSize = min(size.width, size.height)
        let ratio = max(horizontalRatio, verticalRatio)
        let newSize = CGSize(width: minSize*ratio, height: minSize*ratio)
        UIGraphicsBeginImageContextWithOptions(newSize, true, 0)
        draw(in: CGRect(origin: CGPoint.zero, size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}
