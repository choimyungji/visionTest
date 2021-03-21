//
//  ViewController.swift
//  VisionTest
//
//  Created by Myungji Choi on 2021/03/21.
//

import UIKit
import AVFoundation

class ViewController: UIViewController,AVCaptureVideoDataOutputSampleBufferDelegate {

    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var shotButton: UIButton!
    
    private let session = AVCaptureSession()
    private var camera: AVCaptureDevice?
    private var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    
    private var cameraCaptureOutput: AVCapturePhotoOutput?
    private var videoDataOutput: AVCaptureVideoDataOutput?
    private var videoDataOutputQueue: DispatchQueue?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAVCapture()
        // Do any additional setup after loading the view.
    }

    func setupAVCapture(){
        session.sessionPreset = AVCaptureSession.Preset.high
        camera = AVCaptureDevice.default(for: .video)

        do {
            let cameraCaptureInput = try AVCaptureDeviceInput(device:camera!)
            cameraCaptureOutput = AVCapturePhotoOutput()

            session.addInput(cameraCaptureInput)
            session.addOutput(cameraCaptureOutput!)
        } catch {
            print(error.localizedDescription)
        }

        videoDataOutput = AVCaptureVideoDataOutput()
        videoDataOutput?.alwaysDiscardsLateVideoFrames = true
        videoDataOutputQueue = DispatchQueue(label: "videoDataOutputQueue")
        videoDataOutput?.setSampleBufferDelegate(self,
                                                 queue: videoDataOutputQueue)
        if let output = videoDataOutput {
            if (session.canAddOutput(output)) {
                session.addOutput(output)
            }
        }
        videoDataOutput?.connection(with: .video)?.isEnabled = true

        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: session)
        cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        cameraPreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait

        let rootLayer = previewView.layer
        rootLayer.masksToBounds = true
        cameraPreviewLayer?.frame = rootLayer.bounds
        rootLayer.addSublayer(cameraPreviewLayer!)

        session.startRunning()
    }

}

