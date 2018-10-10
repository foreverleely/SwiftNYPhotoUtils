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

let ScreenWidth = UIScreen.main.bounds.width
let ScreenHeight = UIScreen.main.bounds.height

class ViewController: UIViewController {
    
    var photoAlbums = [PhotoModel]()

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
        // 获取智能相册
        let smartAlbums = PHAssetCollection.fetchAssetCollections(with: PHAssetCollectionType.smartAlbum, subtype: PHAssetCollectionSubtype.albumRegular, options: nil)
        smartAlbums.enumerateObjects { (collection, idx, stop) in
            // 过滤掉已隐藏、视频、最近删除
            if collection.assetCollectionSubtype != PHAssetCollectionSubtype.smartAlbumAllHidden && collection.assetCollectionSubtype != PHAssetCollectionSubtype.smartAlbumVideos && collection.assetCollectionSubtype != PHAssetCollectionSubtype.init(rawValue: 1000000201) {
                let assets = NYPhotoUtil.getAllAssetWithAssetCollection(collection, false)
                // 遍历 assets 使用 NYPhotoUtil.getImageWithAsset 方法即可获取相应照片
                if !assets.isEmpty {
                    let model = PhotoModel()
                    model.name = collection.localizedTitle ?? ""
                    model.assetCount = assets.count
                    model.coverAsset = assets.first ?? PHAsset()
                    model.assets = assets
                    self.photoAlbums.append(model)
                }
            }
        }
        // 获取用户创建相册
        let userAlbums = PHAssetCollection .fetchAssetCollections(with: PHAssetCollectionType.album, subtype: PHAssetCollectionSubtype.smartAlbumUserLibrary, options: nil)
        userAlbums.enumerateObjects { (collection, idx, stop) in
            let assets = NYPhotoUtil.getAllAssetWithAssetCollection(collection, false)
            if !assets.isEmpty {
                let model = PhotoModel()
                model.name = collection.localizedTitle ?? ""
                model.assetCount = assets.count
                model.coverAsset = assets.first ?? PHAsset()
                model.assets = assets
                self.photoAlbums.insert(model, at: 0)
            }
        }
        
        print(photoAlbums)
        
        getPhotos(photoAlbums.last ?? PhotoModel())
    }
    
    func getPhotos(_ model: PhotoModel) {
        // 对应相册分类下的照片
        var i = 0
        for asset in model.assets {
            let width = CGFloat(50.0)
            let y = CGFloat(i) * (width + 10)
            let imgView = UIImageView(frame: CGRect(x: 0.0, y: y, width: width, height: width))
            view.addSubview(imgView)
            NYPhotoUtil.getImageWithAsset(asset, CGSize(width: width, height: width)) { (image) in
                imgView.image = image
            }
            
            i = i + 1
        }
    }


}

class PhotoModel: NSObject {
    // 相册名
    var name = ""
    // 照片数
    var assetCount = 0
    // 照片集里第一个照片（封面照片）
    var coverAsset = PHAsset()
    // 照片集
    var assets = [PHAsset]()
    
    override init() {
        super.init()
    }
}

