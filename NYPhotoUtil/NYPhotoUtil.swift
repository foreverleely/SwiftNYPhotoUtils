//
//  NYPhotoUtil.swift
//  SwiftNYPhotoDemo
//
//  Created by liyangly on 2018/10/9.
//  Copyright © 2018 liyang. All rights reserved.
//

import Foundation
import UIKit
import Photos

struct NYPhotoUtil {

    static func getAllAssetWithAssetCollection(_ assetCollection: PHAssetCollection, _ ascending: Bool) -> [PHAsset] {
        var assets = [PHAsset]()
        let option = PHFetchOptions()
        let descriptor: NSSortDescriptor = NSSortDescriptor(key: "creationDate", ascending: true)
//        var sortedResults: NSArray = results.sortedArrayUsingDescriptors([descriptor])
        option.sortDescriptors = [descriptor]//sortedResults
        
        let result = PHAsset.fetchAssets(in: assetCollection, options: option)
        result.enumerateObjects { (asset, idx, stop) in
            if asset.mediaType == PHAssetMediaType.image {
                assets.append(asset)
            }
        }
        
        return assets
    }
    
    static func getImageWithAsset(_ asset: PHAsset, _ size: CGSize, completion: @escaping (UIImage) -> ()) {
        let option = PHImageRequestOptions()
        option.deliveryMode = .opportunistic
        option.isNetworkAccessAllowed = true
        
        PHCachingImageManager.default().requestImage(for: asset, targetSize: size, contentMode: .default, options: option) { (image, info) in
            if let image = image {
                completion(image)
            }
        }
    }
    
    static func getImageWithAsset(_ asset: PHAsset, completion: @escaping (UIImage) -> ()) {
        let option = PHImageRequestOptions()
        option.deliveryMode = .opportunistic
        option.isNetworkAccessAllowed = true
        
        PHCachingImageManager.default().requestImageData(for: asset, options: option) { (imageData, dataUTI, imageOrientation, info) in
            if let image = UIImage(data: imageData ?? Data()) {
                completion(image)
            }
            
        }
    }
    
}
