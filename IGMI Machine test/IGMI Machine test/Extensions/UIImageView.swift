//
//  UIImageView.swift
//  IGMI Machine test
//
//  Created by Brijesh Ajudia on 02/09/22.
//

import Foundation
import UIKit
import SDWebImage

extension UIImageView {
    
    func loadImageFromURL(themeURLString: String?, placeholderImage: UIImage? = nil, placeHolderErrorImage: UIImage? = nil){
        guard let themeURL = themeURLString, let imageURL = URL.init(string: themeURL) else {
            image = placeholderImage ?? UIImage(named: "placeholder")
            return
        }
        
        self.image = placeholderImage
        sd_setImage(with: imageURL, placeholderImage: UIImage(named: "placeholder"), options: .refreshCached) { (image, error, cacheType, url) in
            if error != nil {
                self.image = placeHolderErrorImage ?? UIImage(named: "placeholder")
            }
            else {
                if image != nil {
                    self.image = image
                }
                else {
                    self.image = placeholderImage ?? UIImage(named: "placeholder")
                }
            }
        }
    }
    
    func setImageFromURL(imageString: String, placeHolderImage: UIImage? = nil, placeHolderErrorImage: UIImage? = nil, _ callback: ((_ imageFromURL: UIImage?) -> Void)?) {
        guard let imageURL = URL(string: imageString) else {
            callback?(placeHolderImage)
            return
        }
        
        sd_setImage(with: imageURL) { sdImage, error, cacheType, url in
            if error != nil {
                callback?(placeHolderErrorImage)
            }
            else {
                if sdImage != nil {
                    callback?(sdImage)
                }
                else {
                    callback?(placeHolderImage)
                }
            }
        }
    }
    
    
    func setNetworkImage(url: URL, placeHolderImage: UIImage? = nil, indexPath: IndexPath? = nil, callback: ((_ image: UIImage?, _ indexPath: IndexPath?, _ error: Error?) -> Void)?) {
        let DOCUMENT_DIRECTORY = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let localFileURL = DOCUMENT_DIRECTORY.appendingPathComponent(url.lastPathComponent)
        
        if FileManager.default.fileExists(atPath: localFileURL.path) {
            if let data = try? Data(contentsOf: localFileURL) {
                let localImage = UIImage(data: data)
                self.image = localImage
                callback?(localImage, indexPath, nil)
            }
            else {
                self.sd_setImage(with: url,
                                 placeholderImage: placeHolderImage,
                                 options: indexPath == nil ? .highPriority : SDWebImageOptions.avoidAutoSetImage,
                                 context: nil,
                                 progress: nil,
                                 completed: { (image: UIImage?, error: Error?, SDImageCacheType, url: URL?) in
                                    if let i = image {
                                        if let data = i.pngData() {
                                            try? data.write(to: localFileURL, options: Data.WritingOptions.atomic)
                                        }
                                    }
                                    callback?(image, indexPath, error)
                                 })
            }
            
        }
        else {
            self.sd_setImage(with: url,
                             placeholderImage: placeHolderImage,
                             options: indexPath == nil ? .highPriority : SDWebImageOptions.avoidAutoSetImage,
                             context: nil,
                             progress: nil,
                             completed: { (image: UIImage?, error: Error?, SDImageCacheType, url: URL?) in
                                if let i = image {
                                    if let data = i.pngData() {
                                        try? data.write(to: localFileURL, options: Data.WritingOptions.atomic)
                                    }
                                }
                                callback?(image, indexPath, error)
                             })
        }
    }
    
    func getImage(url: URL, placeholderImage: UIImage? = nil, shouldShowFullScreenProgrss: Bool = false, callback: ((_ success: Bool, _ url: URL?, _ image: UIImage?) -> Void)?) {
        DispatchQueue.global(qos: .background).async {
            let tempDirectoyURL = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
            let path = tempDirectoyURL.appendingPathComponent(url.lastPathComponent)
            
            let fileManger = FileManager.default
            let isFileExist = fileManger.fileExists(atPath: path.path)
            if !isFileExist {
                if shouldShowFullScreenProgrss {
                    DispatchQueue.main.async {
                        //Utils.showProgress()
                    }
                }
                self.sd_cancelCurrentImageLoad()
                self.sd_setImage(with: url, placeholderImage: placeholderImage, options: SDWebImageOptions.lowPriority) { (image: UIImage?, error: Error?, cacheType: SDImageCacheType, url: URL?) in
                    DispatchQueue.global(qos: .background).async {
                        if(image != nil && url != nil) {
                            let data = image!.pngData()!
                            let _ = try? data.write(to: path)
                        }
                        DispatchQueue.main.async {
                            //Utils.dismissProgress()
                            callback?(image != nil, url, image)
                        }
                    }
                }
            }
            else {
                let data = try? Data(contentsOf: path)
                let image = data != nil ? UIImage(data: data!) : nil
                DispatchQueue.main.async {
                    callback?(image != nil, url, image)
                }
            }
        }
    }
}
