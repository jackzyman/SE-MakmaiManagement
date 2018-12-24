//
//  EX-UIImage.swift
//  YellowIsDad
//
//  Created by Jarukit Rungruang on 13/12/17.
//  Copyright © 2017 Jarukit Rungruang. All rights reserved.
//

import Foundation
import UIKit

public enum ImageFormat {
    case png
    case jpeg(CGFloat)
}

extension UIImage {
    
//    public func base64(format: ImageFormat) -> String? {
//        var imageData: Data?
//        switch format {
//        case .png: imageData = self.pngData()
//        case .jpeg(let compression): imageData = UIImageJPEGRepresentation(self, compression)
//        }
//        return imageData?.base64EncodedString()
//    }
    
    
    func getPixelColor(_ pos: CGPoint) -> UIColor {
        
        let pixelData = self.cgImage?.dataProvider?.data
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        
        let numberOfComponents = 4
        let pixelInfo: Int = ((Int(self.size.width) * Int(pos.y)) + Int(pos.x)) * numberOfComponents
        
        let r = CGFloat(data[pixelInfo]) / CGFloat(255.0)
        let g = CGFloat(data[pixelInfo+1]) / CGFloat(255.0)
        let b = CGFloat(data[pixelInfo+2]) / CGFloat(255.0)
        let a = CGFloat(data[pixelInfo+3]) / CGFloat(255.0)
        
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
}

extension UIImage {
    func YSDChangeColor(color: UIColor) -> UIImage? {
        let maskImage = cgImage!
        
        let width = size.width
        let height = size.height
        let bounds = CGRect(x: 0, y: 0, width: width, height: height)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)!
        
        context.clip(to: bounds, mask: maskImage)
        context.setFillColor(color.cgColor)
        context.fill(bounds)
        
        if let cgImage = context.makeImage() {
            let coloredImage = UIImage(cgImage: cgImage)
            return coloredImage
        } else {
            return nil
        }
    }
    
    func YSDResizeImage(maxSize: CGFloat) -> UIImage?{
        
        var size = CGSize()
        if self.size.height > self.size.width {
            size = YSDCalculateRatio(ratioWidth: self.size.width, ratioHeight: self.size.height , width: maxSize)
        } else {
            size = YSDCalculateRatio(ratioWidth: self.size.width, ratioHeight: self.size.height , height: maxSize)
        }
        
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }
    
//    func YSDCompressJpeg(_ quality: JPEGQuality) -> Data? {
//        return UIImageJPEGRepresentation(self, quality.rawValue)
//    }


}

