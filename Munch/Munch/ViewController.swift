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



class ViewController: UIViewController {
    private var permissionGranted = false // Flag for permission
        private let captureSession = AVCaptureSession()
        private let sessionQueue = DispatchQueue(label: "sessionQueue")
        private var previewLayer = AVCaptureVideoPreviewLayer()
        var screenRect: CGRect! = nil // For view dimensions
      
      override func viewDidLoad() {
            checkPermission()
            
            sessionQueue.async { [unowned self] in
                guard permissionGranted else { return }
                self.setupCaptureSession()
                self.captureSession.startRunning()
            }
        }
    
    func checkPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
            // Permission has been granted before
            case .authorized:
                permissionGranted = true
                    
            // Permission has not been requested yet
            case .notDetermined:
                requestPermission()
                        
            default:
                permissionGranted = false
        }
    }
    
    func requestPermission() {
        sessionQueue.suspend()
        AVCaptureDevice.requestAccess(for: .video) { [unowned self] granted in
            self.permissionGranted = granted
            self.sessionQueue.resume()
        }
    }

}

struct HostedViewController: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        return ViewController()
        }

        func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        }
}
