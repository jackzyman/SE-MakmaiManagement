//
//  ScanViewController.swift
//  JongYa
//
//  Created by Jarukit Rungruang on 15/10/18.
//  Copyright © 2018 Jarukit Rungruang. All rights reserved.
//

import AVFoundation
import UIKit

class ScanViewController: MainMenuViewController{
    @IBOutlet weak var cameraView: UIView!
    
    var captureSession: AVCaptureSession!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    
    var usReading:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
   
   override func viewDidAppear(_ animated: Bool) {
      startReading()
   }
//    @IBAction func scanButtonTouchup(_ sender: UIButton) {
//        startReading()
//    }
    
    func startReading() -> Bool {// ฟังก์ชันเปิดวิดีโอขึ้นมา
        if let captureDevice = AVCaptureDevice.default(for: AVMediaType.video){
            do{ // ที่ต้อง do try catch เพราะ ตัวAVCaptureDeviceInput มันต้องมีการ throw exception
                let input = try AVCaptureDeviceInput(device: captureDevice)
                self.captureSession = AVCaptureSession()
                self.captureSession.addInput(input)
            }catch let error as NSError{ // as NSError ตรง NSError สามารถเปลี่ยนเป็น error อื่นได้
                showMsg(msgTitle: error.localizedDescription, msgText: error.localizedFailureReason ?? "-") // คือให้มันพยายามโชว์ FailureReason ถ้าไม่มีก็ -
                return false // ถ้าเจ๊งให้ return false
            }
            
            self.videoPreviewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession) // ทำ preview
            self.videoPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
            self.videoPreviewLayer.frame = self.cameraView.layer.bounds // self คือ global
            self.cameraView.layer.addSublayer(self.videoPreviewLayer)
            
            let captureMetadataOutput = AVCaptureMetadataOutput()
            self.captureSession.addOutput(captureMetadataOutput)
            captureMetadataOutput.metadataObjectTypes = captureMetadataOutput.availableMetadataObjectTypes // detect ซึ่งสามารถตั้งได้ว่าจะ detectอะไร แต่อันนี้คือจับทุกอย่างเลย
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main) // main Dispatch queue สามารถอัพเดทหน้าจอได้ ทำเกี่ยวกับหน้าจอเท่านั้น(สิ่งที่คำนวณนานๆอย่าไปยัดลงในdispatchqueueเพราะจะค้าง )
            captureSession.startRunning()
            
        } else{
            // error message แจ้งเตือน สมมติถ้าแอปมีปัญหาต้องมีการเเจ้งเตือน
            showMsg(msgTitle: "Cannot Access Camera", msgText: "Do not have camera or permission is not given")
        }
        return true
    }
    
    func showMsg(msgTitle:String, msgText:String) { // ฟังก์ชันแสดง alert
        let alert = UIAlertController(title: msgTitle, message: msgText, preferredStyle: UIAlertController.Style.alert)
        
        // alert ต้องมีการทำ action ด้วย
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        // handler ที่ปุ่ม
        self.present(alert, animated: true, completion: nil) // show alert ขึ้นมา
        // completion ทำอะไรเมื่อปิด
        
        
    }
    
}

extension ScanViewController:AVCaptureMetadataOutputObjectsDelegate{
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        var qrText = ""
        
        for data in metadataObjects{ //AVMetadataMachineReadableCodeObject คำสั่งที่เอาไว้อ่าน QRCODE
            if let qrcode = data as? AVMetadataMachineReadableCodeObject{
                qrText = qrcode.stringValue ?? "N/A" + "\n" // ?? คือ เหมือนถ้า stringValue เป็น new ก็จะไปทำ N/A
            }
        }
        
        // Stop scanning
        self.captureSession.stopRunning()
        self.captureSession = nil // เพื่อสลายให้ capture เก่าทิ้ง
        self.videoPreviewLayer.removeFromSuperlayer()
        
    }
}

//class ScanViewController: MainMenuViewController, QRCodeReaderViewControllerDelegate {
//
//
//    @IBOutlet weak var previewView: QRCodeReaderView! {
//        didSet {
//            previewView.setupComponents(showCancelButton: false, showSwitchCameraButton: false, showTorchButton: false, showOverlayView: true, reader: reader)
//        }
//    }
//    lazy var reader: QRCodeReader = QRCodeReader()
//    lazy var readerVC: QRCodeReaderViewController = {
//        let builder = QRCodeReaderViewControllerBuilder {
//            $0.reader                  = QRCodeReader(metadataObjectTypes: [.qr], captureDevicePosition: .back)
//            $0.showTorchButton         = true
//            $0.preferredStatusBarStyle = .lightContent
//
//            $0.reader.stopScanningWhenCodeIsFound = false
//        }
//
//        return QRCodeReaderViewController(builder: builder)
//    }()
//
//    // MARK: - Actions
//
//    private func checkScanPermissions() -> Bool {
//        do {
//            return try QRCodeReader.supportsMetadataObjectTypes()
//        } catch let error as NSError {
//            let alert: UIAlertController
//
//            switch error.code {
//            case -11852:
//                alert = UIAlertController(title: "Error", message: "This app is not authorized to use Back Camera.", preferredStyle: .alert)
//
//                alert.addAction(UIAlertAction(title: "Setting", style: .default, handler: { (_) in
//                    DispatchQueue.main.async {
//                        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
//                            UIApplication.shared.openURL(settingsURL)
//                        }
//                    }
//                }))
//
//                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//            default:
//                alert = UIAlertController(title: "Error", message: "Reader not supported by the current device", preferredStyle: .alert)
//                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
//            }
//
//            present(alert, animated: true, completion: nil)
//
//            return false
//        }
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        guard checkScanPermissions(), !reader.isRunning else { return }
//
//        reader.didFindCode = { result in
//            print("Completion with result: \(result.value) of type \(result.metadataType)")
//        }
//
//        reader.startScanning()
//    }
//
////    @IBAction func scanInModalAction(_ sender: AnyObject) {
////        guard checkScanPermissions() else { return }
////
////        readerVC.modalPresentationStyle = .formSheet
////        readerVC.delegate               = self
////
////        readerVC.completionBlock = { (result: QRCodeReaderResult?) in
////            if let result = result {
////                print("Completion with result: \(result.value) of type \(result.metadataType)")
////            }
////        }
////
////        present(readerVC, animated: true, completion: nil)
////    }
////
////    @IBAction func scanInPreviewAction(_ sender: Any) {
////        guard checkScanPermissions(), !reader.isRunning else { return }
////
////        reader.didFindCode = { result in
////            print("Completion with result: \(result.value) of type \(result.metadataType)")
////        }
////
////        reader.startScanning()
////    }
//
//    // MARK: - QRCodeReader Delegate Methods
//
//    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
//        reader.stopScanning()
//
//        dismiss(animated: true) { [weak self] in
//            let alert = UIAlertController(
//                title: "QRCodeReader",
//                message: String (format:"%@ (of type %@)", result.value, result.metadataType),
//                preferredStyle: .alert
//            )
//            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
//
//            self?.present(alert, animated: true, completion: nil)
//        }
//    }
//
//    func reader(_ reader: QRCodeReaderViewController, didSwitchCamera newCaptureDevice: AVCaptureDeviceInput) {
//        print("Switching capturing to: \(newCaptureDevice.device.localizedName)")
//    }
//
//    func readerDidCancel(_ reader: QRCodeReaderViewController) {
//        reader.stopScanning()
//
//        dismiss(animated: true, completion: nil)
//    }
//}
