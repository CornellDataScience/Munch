//
//  ViewController.swift
//  Munch
//
//  Created by elizabeth song on 10/6/23.
//

import Foundation
import UIKit
import SwiftUI
import AVFoundation



class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
   //private var permissionGranted = false // Flag for permission
   // private let sessionQueue = DispatchQueue(label: "sessionQueue")
   // private var previewLayer = AVCaptureVideoPreviewLayer()
   // var screenRect: CGRect! = nil // For view dimensions
    var coordinator: CameraView.Coordinator?

    var captureImage: ((UIImage?) -> Void)?
    // Capture Session
    var session : AVCaptureSession?
    // Photo Output
    let output = AVCapturePhotoOutput()
    // Video Preview
    let previewLayer = AVCaptureVideoPreviewLayer()
    // Shutter Button
    private let shutterButton : UIButton = {
        let button = UIButton(frame: CGRect(x:0, y:0, width:200, height:200))
        button.layer.cornerRadius = 100
        button.layer.borderWidth = 10
        button.layer.borderColor = UIColor.white.cgColor
        return button
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        view.layer.addSublayer(previewLayer)
        view.addSubview(shutterButton)
        checkCameraPermission()
        
        shutterButton.addTarget(self, action: #selector(didTapTakePhoto), for: .touchUpInside)
        
        //            sessionQueue.async { [unowned self] in
        //                guard permissionGranted else { return }
        //                self.setupCaptureSession()
        //                self.captureSession.startRunning()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer.frame = view.bounds
        shutterButton.center = CGPoint (x: view.frame.size.width / 2, y: view.frame.size.height - 200)
    }
    
    
    
    
    private func checkCameraPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
            
        case .notDetermined: // [weak self] not working
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                guard granted else {
                    return
                }
                DispatchQueue.main.async{
                    self?.setUpCamera()
                }
            }
        case .restricted:
            break
        case .denied:
            break
        case .authorized:
            setUpCamera()
        @unknown default:
            break
        }
    }
    
    private func setUpCamera() {
        let session = AVCaptureSession()
        if let device = AVCaptureDevice.default(for:.video){
            do {
                let input = try AVCaptureDeviceInput(device: device)
                if session.canAddInput(input){
                    session.addInput(input)
                }
                
                if session.canAddOutput(output){ // cannot find output??
                    session.addOutput(output)
                }
                
                previewLayer.videoGravity = .resizeAspectFill
                previewLayer.session = session
                
                session.startRunning()
                self.session = session
                
            }
            catch {
                print(error)
            }
        }
    }
    
    
    
    @objc private func didTapTakePhoto() {
         output.capturePhoto(with: AVCapturePhotoSettings(),
                             delegate: coordinator as! AVCapturePhotoCaptureDelegate)
     }
    
    
    //    func requestPermission() {
    //        sessionQueue.suspend()
    //        AVCaptureDevice.requestAccess(for: .video) { [unowned self] granted in
    //            self.permissionGranted = granted
    //            self.sessionQueue.resume()
    //        }
    //    }
    //
    //}
    //
    //struct HostedViewController: UIViewControllerRepresentable {
    //    func makeUIViewController(context: Context) -> UIViewController {
    //        return ViewController()
    //        }
    //
    //        func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
    //        }
    //
}

extension ViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let data = photo.fileDataRepresentation() else {
            return
        }
        let image = UIImage(data: data)
        
        session?.stopRunning()
        
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.frame = view.bounds
        view.addSubview(imageView)
    }
}
