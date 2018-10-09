//
//  ViewController.swift
//  SwiftNYPhotoDemo
//
//  Created by liyangly on 2018/10/9.
//  Copyright © 2018 liyang. All rights reserved.
//

import UIKit
import Photos
import Dispatch

class ViewController: UIViewController {
    
    

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        photosManager()
    }
    
    // MARK: - Photos
    
    func photosManager() {
        // 注意配置 info.plist 权限
        PHPhotoLibrary.requestAuthorization { (status) in
            DispatchQueue.main.async {
                switch status {
                    case .notDetermined:
                        break
                    case .restricted:
                        break
                    case .denied:
                        break
                    case .authorized:
                        self.loadAlbumData()
                        break
                }
            }
        }
    }
    
    func loadAlbumData() {
        var photoAlbums = [[PHAsset]]()
        // 获取智能相册
        let smartAlbums = PHAssetCollection.fetchAssetCollections(with: PHAssetCollectionType.smartAlbum, subtype: PHAssetCollectionSubtype.albumRegular, options: nil)
        smartAlbums.enumerateObjects { (collection, idx, stop) in
            // 过滤掉已隐藏、视频、最近删除
            if collection.assetCollectionSubtype != PHAssetCollectionSubtype.smartAlbumAllHidden && collection.assetCollectionSubtype != PHAssetCollectionSubtype.smartAlbumVideos && collection.assetCollectionSubtype != PHAssetCollectionSubtype.init(rawValue: 1000000201) {
                let assets = NYPhotoUtil.getAllAssetWithAssetCollection(collection, false)
                if !assets.isEmpty {
                    photoAlbums.append(assets)
                }
            }
        }
        // 获取用户创建相册
        let userAlbums = PHAssetCollection .fetchAssetCollections(with: PHAssetCollectionType.album, subtype: PHAssetCollectionSubtype.smartAlbumUserLibrary, options: nil)
        userAlbums.enumerateObjects { (collection, idx, stop) in
            let assets = NYPhotoUtil.getAllAssetWithAssetCollection(collection, false)
            if !assets.isEmpty {
                photoAlbums.insert(assets, at: 0)
            }
        }
        
        print(photoAlbums)
    }


}

