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
        // mind the info.plist authority
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
        // smartAlbum
        let smartAlbums = PHAssetCollection.fetchAssetCollections(with: PHAssetCollectionType.smartAlbum, subtype: PHAssetCollectionSubtype.albumRegular, options: nil)
        smartAlbums.enumerateObjects { (collection, idx, stop) in
            // filter the hiddens, videos, and removes
            if collection.assetCollectionSubtype != PHAssetCollectionSubtype.smartAlbumAllHidden && collection.assetCollectionSubtype != PHAssetCollectionSubtype.smartAlbumVideos && collection.assetCollectionSubtype != PHAssetCollectionSubtype.init(rawValue: 1000000201) {
                let assets = NYPhotoUtil.getAllAssetWithAssetCollection(collection, false)
                // forin the assets, then using "NYPhotoUtil.getImageWithAsset", you can also get photos
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
        // userAlbum
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
        // get photos in specific album
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
    // album name
    var name = ""
    // photo count
    var assetCount = 0
    // cover asset
    var coverAsset = PHAsset()
    // asset collection
    var assets = [PHAsset]()
    
    override init() {
        super.init()
    }
}

