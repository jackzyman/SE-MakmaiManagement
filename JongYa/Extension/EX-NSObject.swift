//
//  EX-NSObject.swift
//  YellowIsDad
//
//  Created by Jarukit Rungruang on 13/12/17.
//  Copyright © 2017 Jarukit Rungruang. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

extension NSObject {
    
}

extension NSObject {
    
    func isValidEmail(_ testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    
}

extension NSObject {
    func YSDregisterTableViewCellNib(_ tableView: UITableView, nibName: String, identifier: String = "", indexPath: IndexPath) ->  UITableViewCell {
        var id = identifier
        if id == "" {
            id = nibName
        }
        tableView.register(UINib(nibName: nibName, bundle: nil), forCellReuseIdentifier: id)
        return tableView.dequeueReusableCell(withIdentifier: id, for: indexPath)
    }
    
    func YSDregisterCollectionViewCellNib(_ collectionView: UICollectionView, nibName: String, identifier: String = "", indexPath: IndexPath) ->  UICollectionViewCell {
        var id = identifier
        if id == "" {
            id = nibName
        }
        collectionView.register(UINib(nibName: nibName, bundle: nil), forCellWithReuseIdentifier: id)
        return collectionView.dequeueReusableCell(withReuseIdentifier: id, for: indexPath)
    }
}

extension NSObject {
    func imageRotatedByDegrees(_ oldImage: UIImage, deg degrees: CGFloat) -> UIImage {
        //Calculate the size of the rotated view's containing box for our drawing space
        let rotatedViewBox: UIView = UIView(frame: CGRect(x: 0, y: 0, width: oldImage.size.width, height: oldImage.size.height))
        let t: CGAffineTransform = CGAffineTransform(rotationAngle: degrees * CGFloat(Double.pi / 180))
        rotatedViewBox.transform = t
        let rotatedSize: CGSize = rotatedViewBox.frame.size
        //Create the bitmap context
        UIGraphicsBeginImageContext(rotatedSize)
        let bitmap: CGContext = UIGraphicsGetCurrentContext()!
        //Move the origin to the middle of the image so we will rotate and scale around the center.
        bitmap.translateBy(x: rotatedSize.width / 2, y: rotatedSize.height / 2)
        //Rotate the image contexts
        bitmap.rotate(by: (degrees * CGFloat(Double.pi / 180)))
        //Now, draw the rotated/scaled image into the context
        bitmap.scaleBy(x: 1.0, y: -1.0)
        bitmap.draw(oldImage.cgImage!, in: CGRect(x: -oldImage.size.width / 2, y: -oldImage.size.height / 2, width: oldImage.size.width, height: oldImage.size.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    // คำนวน size ตาม ratio
    func YSDCalculateRatio(ratioWidth: CGFloat, ratioHeight: CGFloat, 
                        width: CGFloat? = nil, height: CGFloat? = nil) -> CGSize {
        if width != nil {
            let _width = width!
            let _height = (_width / ratioWidth) * ratioHeight
            return CGSize(width: _width.rounded() , height: _height.rounded())
        } else {
            let _height = height!
            let _width = (_height / ratioHeight) * ratioWidth
            return CGSize(width: _width.rounded() , height: _height.rounded())
            
        }
    }
}


extension NSObject {
    
    
//    
//    func encodeVideo(_ videoURL: URL, completion: @escaping (URL) -> ()){
//        var exportSession : AVAssetExportSession? = nil
//        
//        let avAsset = AVURLAsset(url: videoURL, options: nil)
//        
//        let startDate = Foundation.Date()
//        
//        //Create Export session
//        exportSession = AVAssetExportSession(asset: avAsset, presetName: AVAssetExportPresetPassthrough)
//        
//        // exportSession = AVAssetExportSession(asset: composition, presetName: mp4Quality)
//        //Creating temp path to save the converted video
//        
//        
//        let documentsDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
//        let myDocumentPath = URL(fileURLWithPath: documentsDirectory).appendingPathComponent("temp.mp4").absoluteString
//        //let url = URL(fileURLWithPath: myDocumentPath)
//        
//        let documentsDirectory2 = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0] as URL
//        
//        let filePath = documentsDirectory2.appendingPathComponent("rendered-Video.mp4")
//        deleteFile(filePath)
//        
//        //Check if the file already exists then remove the previous file
//        if FileManager.default.fileExists(atPath: myDocumentPath) {
//            do {
//                try FileManager.default.removeItem(atPath: myDocumentPath)
//            }
//            catch let error {
//                print(error)
//            }
//        }
//        
//        exportSession!.outputURL = filePath
//        exportSession!.outputFileType = AVFileType.mp4
//        exportSession!.shouldOptimizeForNetworkUse = true
//        let start = CMTimeMakeWithSeconds(0.0, 0)
//        let range = CMTimeRangeMake(start, avAsset.duration)
//        exportSession?.timeRange = range
//        
//        exportSession!.exportAsynchronously(completionHandler: {() -> Void in
//            switch exportSession!.status {
//            case .failed:
//                if let error = exportSession?.error {
//                print("\(error)")
//                }
//            case .cancelled:
//                print("Export canceled")
//            case .completed:
//                //Video conversion finished
//                let endDate = Foundation.Date()
//                let time = endDate.timeIntervalSince(startDate)
//                if let outputURL = exportSession?.outputURL {
//                    print(time)
//                    print("Successful!")
//                    print(outputURL)
//                    completion(outputURL)
//                }
//                
//            default:
//                break
//            }
//            
//        })
//        
//        
//    }
    
    func deleteFile(_ filePath: URL) {
        guard FileManager.default.fileExists(atPath: filePath.path) else {
            return
        }
        
        do {
            try FileManager.default.removeItem(atPath: filePath.path)
        }catch{
            fatalError("Unable to delete file: \(error) : \(#function).")
        }
    }
}



