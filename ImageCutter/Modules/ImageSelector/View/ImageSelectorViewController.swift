//
//  ImageSelectorViewController.swift
//  ImageCutter
//
//  Created by Александра Среднева on 6.08.24.
//

import UIKit
import SnapKit
import PhotosUI

class ImageSelectorViewController: UIViewController {

    // MARK: - Constants

    private enum Constants {
        static let cropperFrameWidth: CGFloat = 2
        static let selectionLimit = 1
        static let imagePadding: CGFloat = 6
        static let yellowFrameWidthHeight = 300
        static let selectedImageWidthHeight = 400
        static let segmentedControlLeadingTrailingOffset = 16
        static let segmentedControlBottomOffset = 15
    }

    // MARK: - Properties

    private lazy var selectedImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Resources.Images.ImageSelector.plusImage.image
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    private lazy var yellowFrame: UIView = {
        let frame = UIView()
        frame.layer.borderColor = UIColor.yellow.cgColor
        frame.layer.borderWidth = Constants.cropperFrameWidth
        frame.isUserInteractionEnabled = false
        return frame
    }()

    private lazy var imagePicker: PHPickerViewController = {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = Constants.selectionLimit
        let imagePicker = PHPickerViewController(configuration: configuration)
        imagePicker.delegate = self
        return imagePicker
    }()

    private lazy var filterSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: [
            LocalizedString.ImageSelector.noFilterOption,
            LocalizedString.ImageSelector.grayScaleOption
        ])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(filterChanged), for: .valueChanged)
        return segmentedControl
    }()

    private lazy var customNavigationBar: UINavigationBar = {
        let navbar = UINavigationBar()
        navbar.backgroundColor = .white
        navbar.isTranslucent = false
        return navbar
    }()

    private lazy var titleNavigationItem: UINavigationItem = {
        let navigationItem = UINavigationItem()
        navigationItem.title = LocalizedString.MainTabBar.imageSelectorTitle
        return navigationItem
    }()

    private lazy var saveButton: UIButton = {
        var buttonConfig = UIButton.Configuration.plain()
        buttonConfig.title = LocalizedString.ImageSelector.saveButtonTitle
        buttonConfig.image = Resources.Images.ImageSelector.saveButtonImage.image
        buttonConfig.imagePadding = Constants.imagePadding
        buttonConfig.baseForegroundColor = .black
        let button = UIButton(configuration: buttonConfig)
        button.addTarget(
            self,
            action: #selector(saveCroppedImage),
            for: .touchUpInside
        )
        return button
    }()

    private lazy var saveButtonItem: UIBarButtonItem = {
        let barButton = UIBarButtonItem()
        barButton.customView = saveButton
        return barButton
    }()
    
    private lazy var cancelButtonItem: UIBarButtonItem = {
        let barButton = UIBarButtonItem(systemItem: .cancel)
        barButton.action = #selector(cancelAction)
        return barButton
    }()
    
    private lazy var customAlert: UIAlertController = {
        let alert = CustomAlertController(
            title: LocalizedString.ImageSelector.alertTitle,
            message: LocalizedString.ImageSelector.alertMessage,
            actionTitle: LocalizedString.ImageSelector.alertActionTitle
        )
        return alert
    }()

    private var viewModel: ImageSelectorViewModelProtocol?
    private var originalImage: UIImage?

    // MARK: - Override

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeProperties()
        setUpView()
        setupGestures()
        addSubviews()
        setUpNavBar()
        setUpNotificationCenter()
        setUpConstraints()
        updateView(for: viewModel?.getImageSelectionState() ?? false)
    }

    // MARK: - Private Methods

    private func initializeProperties() {
        let gestureManager = GestureManager(
            frameToCut: yellowFrame,
            imageToCut: selectedImage
        )
        viewModel = ImageSelectorViewModel(gestureManager: gestureManager)
        viewModel?.didSelectImage = { [weak self] imageSelected in
            self?.updateView(for: imageSelected)
        }
    }
    
    private func setUpView() {
        view.backgroundColor = .white
    }
    
    private func addSubviews() {
        view.addSubview(customNavigationBar)
        view.addSubview(selectedImage)
        view.addSubview(yellowFrame)
        view.addSubview(filterSegmentedControl)
    }

    private func setUpNavBar() {
        titleNavigationItem.rightBarButtonItem = saveButtonItem
        titleNavigationItem.leftBarButtonItem = cancelButtonItem
        customNavigationBar.items = [titleNavigationItem]
    }

    private func setupGestures() {
        guard let viewModel = viewModel else { return }
        
        let tapGesture = viewModel.createTapGesture { [weak self] in
            guard let self = self else { return }
            self.present(self.imagePicker, animated: true)
        }
    
        let panGesture = viewModel.createPanGesture()
        let pinchGesture = viewModel.createPinchGesture()
        let rotationGesture = viewModel.createRotationGesture()

        selectedImage.addGestureRecognizer(tapGesture)
        selectedImage.addGestureRecognizer(panGesture)
        selectedImage.addGestureRecognizer(pinchGesture)
        selectedImage.addGestureRecognizer(rotationGesture)
    }
    
    private func setUpNotificationCenter() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(centerAfterReopening),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
    }
    
    private func updateView(for imageSelected: Bool) {
        saveButton.isHidden = !imageSelected
        cancelButtonItem.isHidden = !imageSelected
        yellowFrame.isHidden = !imageSelected
        filterSegmentedControl.isHidden = !imageSelected
        
        if imageSelected {
            centerImage()
        }
    }
    
    private func centerImage() {
        guard let image = selectedImage.image else { return }
        selectedImage.image = image
        selectedImage.snp.remakeConstraints { make in
            make.center.equalTo(yellowFrame.snp.center)
            make.height.width.equalTo(Constants.selectedImageWidthHeight)
        }
        view.layoutIfNeeded()
    }
    
    private func presentAlert() {
        present(
            customAlert,
            animated: true
        )
    }
    
    private func setUpConstraints() {
        customNavigationBar.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }

        yellowFrame.snp.makeConstraints { make in
            make.width.height.equalTo(Constants.yellowFrameWidthHeight)
            make.center.equalToSuperview()
        }

        selectedImage.snp.makeConstraints { make in
            make.center.equalTo(yellowFrame.snp.center)
            make.height.width.equalTo(Constants.selectedImageWidthHeight)
        }

        filterSegmentedControl.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(Constants.segmentedControlBottomOffset)
            make.trailing.equalToSuperview().inset(Constants.segmentedControlLeadingTrailingOffset)
            make.leading.equalToSuperview().offset(Constants.segmentedControlLeadingTrailingOffset)
        }
    }
    
    @objc private func startSelection() {
        present(imagePicker, animated: true)
    }
    
    @objc private func saveCroppedImage() {
        viewModel?.saveCroppedImage(from: selectedImage, cropFrame: yellowFrame)
        presentAlert()
    }
    
    @objc private func cancelAction () {
        viewModel?.removeMask()
        selectedImage.image = Resources.Images.ImageSelector.plusImage.image
        originalImage = nil
        viewModel?.cancelSelection()
    }
    
    @objc private func filterChanged() {
        guard let originalImage = originalImage else { return }
        if let viewModel = viewModel {
            selectedImage.image = viewModel.applyFilter(to: originalImage, filterIndex: filterSegmentedControl.selectedSegmentIndex)
        }
    }
    
    @objc func centerAfterReopening() {
        if originalImage != nil {
            viewModel?.updateMask()
        }
    }
}

// MARK: - Extension PHPickerViewControllerDelegate

extension ImageSelectorViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        if let itemprovider = results.first?.itemProvider {
            if itemprovider.canLoadObject(ofClass: UIImage.self) {
                itemprovider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                    if let selectedImage = image as? UIImage {
                        DispatchQueue.main.async {
                            self?.originalImage = selectedImage
                            self?.selectedImage.image = selectedImage
                            self?.viewModel?.selectImage()
                            self?.viewModel?.updateMask()
                        }
                    }
                }
            }
        }
        picker.dismiss(animated: true)
    }
}
