//
//  GestureManager.swift
//  ImageCutter
//
//  Created by Александра Среднева on 7.08.24.
//

import UIKit

protocol GestureManagerProtocol {
    func createTapGesture(action: @escaping () -> Void) -> UITapGestureRecognizer
    func createPanGesture() -> UIPanGestureRecognizer
    func createPinchGesture() -> UIPinchGestureRecognizer
    func createRotationGesture() -> UIRotationGestureRecognizer
    func updateMask()
    func removeMask()
}

final class GestureManager: GestureManagerProtocol {
    
    // MARK: - Properties
    
    private var tapAction: (() -> Void)?
    
    var frameToCut: UIView
    var imageToCut: UIImageView

    // MARK: - Initializer

    init(frameToCut: UIView, imageToCut: UIImageView) {
        self.frameToCut = frameToCut
        self.imageToCut = imageToCut
    }

    // MARK: - Methods
    
    func createTapGesture(action: @escaping () -> Void) -> UITapGestureRecognizer {
        self.tapAction = action
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(handleTapGesture)
        )
        return tapGesture
    }
    
    func createPanGesture() -> UIPanGestureRecognizer {
        let panGesture = UIPanGestureRecognizer(
            target: self,
            action: #selector(handlePanGesture(_:))
        )
        return panGesture
    }
    
    func createPinchGesture() -> UIPinchGestureRecognizer {
        let pinchGesture = UIPinchGestureRecognizer(
            target: self,
            action: #selector(handlePinchGesture(_:))
        )
        return pinchGesture
    }
    
    func createRotationGesture() -> UIRotationGestureRecognizer {
        let rotationGesture = UIRotationGestureRecognizer(
            target: self,
            action: #selector(handleRotationGesture(_:))
        )
        return rotationGesture
    }
    
    func updateMask() {
        let maskLayer = CAShapeLayer()
        let transformedFrame = frameToCut.convert(frameToCut.bounds, to: imageToCut)
        let path = UIBezierPath(rect: transformedFrame)
        maskLayer.path = path.cgPath
        imageToCut.layer.mask = maskLayer
    }
    
    func removeMask() {
        imageToCut.transform = .identity
        imageToCut.layer.mask = nil
    }

    // MARK: - Private Methods
    
    @objc private func handleTapGesture() {
        tapAction?()
    }
    
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        guard let view = gesture.view else { return }
        let translation = gesture.translation(in: view.superview)
        view.center = CGPoint(x: view.center.x + translation.x, y: view.center.y + translation.y)
        gesture.setTranslation(.zero, in: view.superview)
        updateMask()
    }
    
    @objc private func handlePinchGesture(_ gesture: UIPinchGestureRecognizer) {
        guard let view = gesture.view else { return }
        view.transform = view.transform.scaledBy(x: gesture.scale, y: gesture.scale)
        gesture.scale = 1
        updateMask()
    }
    
    @objc private func handleRotationGesture(_ gesture: UIRotationGestureRecognizer) {
        guard let view = gesture.view else { return }
        view.transform = view.transform.rotated(by: gesture.rotation)
        gesture.rotation = 0
        updateMask()
    }
}
