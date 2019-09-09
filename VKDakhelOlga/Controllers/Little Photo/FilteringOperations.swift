//
//  FilteringOperations.swift
//  VKDakhelOlga
//
//  Created by MacBook on 10/07/2019.
//  Copyright © 2019 MacBook. All rights reserved.
//

import UIKit

protocol FilteredImageProvider{
    var outputImage: UIImage? { get }
}

class SepiaFilterOperation: Operation, FilteredImageProvider {
    
    var outputImage: UIImage? {
        if imageState == .filtered {
            return image
        } else {
            return nil
        }
    }
    
    
    enum ImageState {
        case new
        case filtered
    }
    var image: UIImage
    var imageState: ImageState = .new
    
    init(_ image: UIImage) {
        self.image = image
    }
    
    override func main() {
        if isCancelled { return }
        
        if let filteredImage = applySepiaFilter(to: self.image){
            image = filteredImage
            imageState = .filtered
        }
    }
    
    private func applySepiaFilter(to image: UIImage) -> UIImage? {
        guard let data = image.pngData() else { return nil }
        
        if isCancelled { return nil }
        
        let inputimage = CIImage(data: data)
        let context = CIContext(options: nil)
        guard let filter = CIFilter(name: "CISepiaTone") else { return nil }
        filter.setValue(inputimage, forKey: kCIInputImageKey)
        filter.setValue(0.8, forKey: "inputIntensity")
        
        if isCancelled { return nil }
        
        guard let outputImage = filter.outputImage,
            let outImage = context.createCGImage(outputImage, from: outputImage.extent) else { return nil }
        return UIImage(cgImage: outImage)
    }
}

class VignetteFilterOperation: Operation{
    
    enum ImageState {
        case new
        case filtered
    }
    var image: UIImage?
    var imageState: ImageState = .new
    
    
    
    override func main() {
        if isCancelled { return }
        
        guard let dependency = dependencies
            .filter ({ $0 is FilteredImageProvider})
            .first as? FilteredImageProvider,
            let image = dependency.outputImage else { return }
        
        if let filteredImage = applyVignetteFilter(to: image){
            self.image = filteredImage
            imageState = .filtered
        }
    }
    
    private func applyVignetteFilter(to image: UIImage) -> UIImage? {
        guard let data = image.pngData() else { return nil }
        
        if isCancelled { return nil }
        
        let inputimage = CIImage(data: data)
        let context = CIContext(options: nil)
        guard let filter = CIFilter(name: "CIVignette") else { return nil }
        filter.setValue(inputimage, forKey: kCIInputImageKey)
        filter.setValue(-5, forKey: "inputIntensity")
        filter.setValue(10, forKey: "inputRadius")
        
        if isCancelled { return nil }
        
        guard let outputImage = filter.outputImage,
            let outImage = context.createCGImage(outputImage, from: outputImage.extent) else { return nil }
        return UIImage(cgImage: outImage)
    }
}

