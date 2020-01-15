//
//  QRScannerViewController.swift
//  cuHacking
//
//  Created by Santos on 2019-06-28.
//  Copyright © 2019 cuHacking. All rights reserved.
//

import UIKit
import AVFoundation
import Firebase

class QRScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    private let qrScannerDataSource: QRScannerRepository
    private let scheduleDataSource: ScheduleRepository
    private var currentEventID: String?

    private let currenUser: User
    private var events: [MagnetonAPIObject.Event]?

    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var shouldScan = true
    var previousScan: String?
    var firstScanFailure = true
    private var currentlyAnimating: Bool = false
    private var resultImageViewWidthConstraint: NSLayoutConstraint!

    private let resultImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isHidden = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let eventPickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        return pickerView
    }()

    private let resultTextLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.backgroundColor = .white
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 21, weight: .bold)
        label.layer.opacity = 0
        label.isHidden = true
        return label
    }()
    
    init(qrScannerDataSource: QRScannerRepository = QRScannerDataSource(),
         scheduleDataSource: ScheduleRepository = ScheduleDataSource(),
         currentUser: User) {
        self.qrScannerDataSource = qrScannerDataSource
        self.scheduleDataSource = scheduleDataSource
        self.currenUser = currentUser
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.tabBarController?.tabBar.isHidden = true
        self.navigationController?.makeTransparent()
        if captureSession?.isRunning == false {
            captureSession.startRunning()
        }
        super.viewWillAppear(animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        view.backgroundColor =  Asset.Colors.background.color
        verifyCameraPermission()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupEventPicker()
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.tabBarController?.tabBar.isHidden = false
        self.navigationController?.undoTransparent()
        if captureSession?.isRunning == true {
            captureSession.stopRunning()
        }
        super.viewWillDisappear(animated)
    }

    func setup() {
        eventPickerView.dataSource = self
        eventPickerView.delegate = self

        resultImageView.translatesAutoresizingMaskIntoConstraints = false
        resultTextLabel.translatesAutoresizingMaskIntoConstraints = false

        view.addSubviews(views: resultImageView, resultTextLabel, eventPickerView)
        resultImageViewWidthConstraint = resultImageView.widthAnchor.constraint(equalToConstant: 0)
        resultImageViewWidthConstraint.isActive = true

        NSLayoutConstraint.activate([
            resultImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            resultImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            resultImageView.heightAnchor.constraint(equalTo: resultImageView.widthAnchor),
            resultTextLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            resultTextLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            resultTextLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),

            eventPickerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            eventPickerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            eventPickerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            eventPickerView.heightAnchor.constraint(equalToConstant: 100)
        ])

        resultTextLabel.layer.cornerRadius = resultTextLabel.frame.height/2
    }
    
    private func setupEventPicker() {
        scheduleDataSource.getEvents { [weak self] (events, error) in
            guard let self = self else {
                return
            }
            if error != nil {
                print(error)
                return
            }
            guard let events = events else {
                print("Failed to get events")
                return
            }
            self.events = events.scannableEvents
            self.currentEventID = events.scannableEvents[0].id
            DispatchQueue.main.async {
                self.eventPickerView.reloadAllComponents()
            }
            
        }
    }

    private func setupCamera() {
        captureSession = AVCaptureSession()
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            showCameraSetupFailedAlert(title: "QR Scanning not Supported", message: "Permission to use the camera was denied. Please go to your system settings and give cuHacking permission inorder to scan QR codes. ")
            return
        }
        let videoInput: AVCaptureDeviceInput
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            print(error.localizedDescription)
            return
        }
        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        } else {
            showCameraSetupFailedAlert(title: "QR Scanning not Supported", message: "Permission to use the camera was denied. Please go to your system settings and give cuHacking permission inorder to scan QR codes.")
            return
        }
        let metadataOutput = AVCaptureMetadataOutput()
        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            showCameraSetupFailedAlert(title: "QR Scanning not Supported", message: "Permission to use the camera was denied. Please go to your system settings and give cuHacking permission inorder to scan QR codes. ")
            return
        }
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.insertSublayer(previewLayer, at: 0)
        captureSession.startRunning()

    }

    private func verifyCameraPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            self.setupCamera()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    DispatchQueue.main.async {
                        self.setupCamera()
                    }
                } else {
                    DispatchQueue.main.async {
                      self.showCameraSetupFailedAlert(title: "Can't Access Camera", message: "Permission to use the camera was denied. Please go to your system settings and give cuHacking permission inorder to scan QR codes.")
                    }
                }
            }
        case .denied:
            showCameraSetupFailedAlert(title: "Can't Access Camera", message: "Permission to use the camera was denied. Please go to your system settings and give cuHacking permission inorder to scan QR codes.")
        case .restricted:
            showCameraSetupFailedAlert(title: "Restriced Camera Access", message: "Camera usage is restricted on this device.")
        default:
            break
        }
    }

    private func showCameraSetupFailedAlert(title: String, message: String) {
        let errorAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { (_) in
            self.navigationController?.popViewController(animated: false)
        }
        errorAlert.addAction(okAction)
        present(errorAlert, animated: false)
        captureSession = nil
    }

    private func found(code: String) {
        guard let currentEventID = self.currentEventID else {
            return
        }
        showSpinner()
        currenUser.getIDToken { [weak self] (token, error) in
            guard let self = self else {
                return
            }
            if let token = token {
                self.qrScannerDataSource.scan(token: token, uuid: code, eventID: currentEventID) { [weak self] (result, error) in
                    guard let self = self else {
                        return
                    }
                    DispatchQueue.main.async {
                        self.removeSpinner()
                        if error != nil {
                            self.animateResult(wasSuccessful: false, message: error?.localizedDescription)
                        }
                        switch result {
                        case .success:
                            self.animateResult(wasSuccessful: true, message: "Success")
                        case .alreadyScanned:
                            self.animateResult(wasSuccessful: false, message: "User already scanned.")
                        case .userNotFound:
                            self.animateResult(wasSuccessful: false, message: "User not found.")
                        case .serverError:
                            self.animateResult(wasSuccessful: false, message: "Server error.")
                        default:
                            self.animateResult(wasSuccessful: false, message: "Unknown error.")
                        }
                    }
                }
            } else {
                self.removeSpinner()
            }
        }
    }

    private func animateResult(wasSuccessful: Bool, message: String?) {
        if currentlyAnimating {
            return
        }
        currentlyAnimating = true
        let tintColor = wasSuccessful ? UIColor.green : UIColor.red
        let image = wasSuccessful ? Asset.Images.success.image : Asset.Images.failure.image
        resultImageView.image = image
        resultImageView.tintColor = tintColor
        resultImageView.isHidden = false
        resultImageViewWidthConstraint.constant = 0

        resultTextLabel.isHidden = false
        resultTextLabel.text = message
        UIView.animate(withDuration: 1, animations: {
            self.resultTextLabel.layer.opacity = 0.60
            self.resultImageViewWidthConstraint.constant = 100
            self.view.layoutIfNeeded()
            self.firstScanFailure = false
        }) { (_) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.resultImageView.isHidden = true
                self.resultImageViewWidthConstraint.constant = 0
                self.view.layoutIfNeeded()
                self.currentlyAnimating = false
                self.resultTextLabel.text = ""
                self.resultTextLabel.isHidden = true
                self.resultTextLabel.layer.opacity = 0
            }
        }
    }

    // MARK: AVCaptureMetadataOutputObjectsDelegate Methods
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            if previousScan != stringValue {
                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                previousScan = stringValue
                found(code: stringValue)
            } else if firstScanFailure {
               // animateResult(wasSuccessful: false, message: "Already scanned")
            }
        } else {
            shouldScan = true
            previousScan = nil
            firstScanFailure = true
        }
        dismiss(animated: true)
    }
}

extension QRScannerViewController: UIPickerViewDelegate {
}

extension QRScannerViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        guard let events = self.events else {
            return NSAttributedString(string: "")
        }
        return NSAttributedString(string: "\(events[row].title)", attributes: [NSAttributedString.Key.foregroundColor : UIColor.black])
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return events?.count ?? 0
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currentEventID = events?[row].id
    }
}
