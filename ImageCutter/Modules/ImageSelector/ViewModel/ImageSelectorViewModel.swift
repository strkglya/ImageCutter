//
//  ImageSelectorViewModel.swift
//  ImageCutter
//
//  Created by Александра Среднева on 6.08.24.
//

import Foundation
import UIKit

protocol ImageSelectorViewModelProtocol: ViewModelGestureManagerProtocol {
    func getImageSelectionState() -> Bool
    func selectImage()
    func saveCroppedImage(from imageView: UIImageView, cropFrame: UIView)
    func applyFilter(to image: UIImage, filterIndex: Int) -> UIImage
    func cancelSelection()
    var didSelectImage: ((Bool) -> Void)? { get set }
}

protocol ViewModelGestureManagerProtocol {
    func createTapGesture(action: @escaping () -> Void) -> UITapGestureRecognizer
    func createPanGesture() -> UIPanGestureRecognizer
    func createRotationGesture() -> UIRotationGestureRecognizer
    func createPinchGesture() -> UIPinchGestureRecognizer
    func updateMask()
}

final class ImageSelectorViewModel: ImageSelectorViewModelProtocol {

    // MARK: - Constants

    private enum Constants {
        static let grayscaleFilterName = "CIPhotoEffectMono"
    }

    // MARK: - Properties

    private var gestureManager: GestureManagerProtocol
    private var imageWasSelected = false {
        didSet {
            didSelectImage?(imageWasSelected)
        }
    }
    var didSelectImage: ((Bool) -> Void)?

    // MARK: - Initializer

    init(gestureManager: GestureManagerProtocol) {
        self.gestureManager = gestureManager
    }

    // MARK: - Methods

    func getImageSelectionState() -> Bool {
        return imageWasSelected
    }

    func selectImage() {
        imageWasSelected = true
    }

    func cancelSelection() {
        imageWasSelected = false
    }

    func saveCroppedImage(from imageView: UIImageView, cropFrame: UIView) {
        guard let image = imageView.image else { return }

        let imageViewSize = imageView.bounds.size
        let imageSize = image.size
        let imageScale = max(
            imageViewSize.width / imageSize.width,
            imageViewSize.height / imageSize.height
        )
        let scaledImageSize = CGSize(
            width: imageSize.width * imageScale,
            height: imageSize.height * imageScale
        )
        let offsetX = (imageViewSize.width - scaledImageSize.width) / 2
        let offsetY = (imageViewSize.height - scaledImageSize.height) / 2
        let frameInImageViewCoordinates = cropFrame.convert(
            cropFrame.bounds,
            to: imageView
        )
        let cropRect = CGRect(
            x: (frameInImageViewCoordinates.origin.x - offsetX) / imageScale,
            y: (frameInImageViewCoordinates.origin.y - offsetY) / imageScale,
            width: frameInImageViewCoordinates.size.width / imageScale,
            height: frameInImageViewCoordinates.size.height / imageScale
        )

        guard let croppedCGImage = image.cgImage?.cropping(to: cropRect) else { return }
        let croppedImage = UIImage(
            cgImage: croppedCGImage,
            scale: image.scale,
            orientation: image.imageOrientation
        )

        UIImageWriteToSavedPhotosAlbum(croppedImage, nil, nil, nil)
    }

    func applyFilter(to image: UIImage, filterIndex: Int) -> UIImage {
        switch filterIndex {
        case 1:
            return grayscaleImage(image: image)
        default:
            return image
        }
    }

    // MARK: - Private Methods
    
    private func grayscaleImage(image: UIImage) -> UIImage {
        let ciImage = CIImage(image: image)
        guard let grayscale = ciImage?.applyingFilter(Constants.grayscaleFilterName, parameters: [:]) else {
            return UIImage()
        }
        let context = CIContext()
        guard let cgImage = context.createCGImage(grayscale, from: grayscale.extent) else {
            return UIImage()
        }
        return UIImage(cgImage: cgImage)
    }
}

// MARK: - Extension ViewModelGestureManagerProtocol

extension ImageSelectorViewModel: ViewModelGestureManagerProtocol {
    
    func createTapGesture(action: @escaping () -> Void) -> UITapGestureRecognizer {
        gestureManager.createTapGesture(action: action)
    }

    func createPanGesture() -> UIPanGestureRecognizer {
        return gestureManager.createPanGesture()
    }

    func createRotationGesture() -> UIRotationGestureRecognizer {
        return gestureManager.createRotationGesture()
    }

    func createPinchGesture() -> UIPinchGestureRecognizer {
        return gestureManager.createPinchGesture()
    }
    
    func updateMask() {
        gestureManager.updateMask()
    }
}
