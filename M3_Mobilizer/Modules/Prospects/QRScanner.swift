import UIKit
import AVFoundation
import Foundation

class QRScanner: UIViewController,AVCaptureMetadataOutputObjectsDelegate,XMLParserDelegate
{
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    let sessionQueue = DispatchQueue(label: AVCaptureSession.self.description(), attributes: [], target: nil)
    var barcodeAreaView: UIView?

    var parser = XMLParser()
    
    @IBOutlet var qrCodeView: UIView!
    
    @IBAction func cancelButton(_ sender: Any)
    {
        self.performSegue(withIdentifier: "qrscanner_page", sender: self)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Get the back-facing camera for capturing videos
        self.title = "Scanner"

       
        view.backgroundColor = UIColor.black
        captureSession = AVCaptureSession()
        
        navigationLetfButton ()

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        var barcodeArea:CGRect!

        let width = 250
        let height = 250

        let xPos = (CGFloat(self.qrCodeView.frame.size.width) / CGFloat(2)) - (CGFloat(width) / CGFloat(2))
        let yPos = (CGFloat(self.qrCodeView.frame.size.height) / CGFloat(2)) - (CGFloat(height) / CGFloat(2))
        barcodeArea = CGRect(x: Int(xPos), y: Int(yPos), width: width, height: height)
        
        barcodeAreaView = UIView()
        barcodeAreaView?.layer.borderColor = UIColor.green.cgColor
        barcodeAreaView?.layer.borderWidth = 1
        barcodeAreaView?.frame = barcodeArea
        view.addSubview(barcodeAreaView!)
        
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            failed()
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = self.qrCodeView.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        qrCodeView.layer.addSublayer(previewLayer)
        self.qrCodeView.clipsToBounds = true
        
        captureSession.startRunning()
        
        metadataOutput.rectOfInterest = previewLayer!.metadataOutputRectConverted(fromLayerRect: barcodeArea)

    
    }
    
    func navigationLetfButton ()
    {
        let navigationLetfButton = UIButton(type: .custom)
        navigationLetfButton.setImage(UIImage(named: "back-01"), for: .normal)
        navigationLetfButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        navigationLetfButton.addTarget(self, action: #selector(clickButton), for: .touchUpInside)
        let navigationButton = UIBarButtonItem(customView: navigationLetfButton)
        self.navigationItem.setLeftBarButton(navigationButton, animated: true)
    }
    
    @objc func clickButton()
    {
        self.performSegue(withIdentifier: "qrscanner_page", sender: self)
    }
    
    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection)
    {
        captureSession.stopRunning()
        
        if let metadataObject = metadataObjects.first
        {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)

        }
        
      }
    
    func found(code: String)
    {
        print(code)
        let parser = XMLParser.init(data: code.data(using: .utf8)!)
        parser.delegate = self
        parser.parse()
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {

            switch elementName
            {
            case "PrintLetterBarcodeData":  GlobalVariables.studentname  =  attributeDict["name"]
            if let _dob = attributeDict["dob"]
            {
                GlobalVariables.dob = _dob
            }
            else
            {
                GlobalVariables.dob = attributeDict["yob"]
            }
            GlobalVariables.aadhaar_card_number = attributeDict["uid"]!
            let co = attributeDict["co"]!
            let splits = co.components(separatedBy: ":")
            GlobalVariables.father_name = splits[1]
            GlobalVariables.sex = attributeDict["gender"]!
            GlobalVariables.address = attributeDict["house"]! + attributeDict["street"]!
            GlobalVariables.state = attributeDict["state"]!
            if let loc = attributeDict["loc"]
            {
                 GlobalVariables.city = loc
            }
            else
            {
                GlobalVariables.city = attributeDict["dist"]!
            }
            GlobalVariables.pincode = attributeDict["pc"]!
            self.performSegue(withIdentifier: "qrscanner_form", sender: self)
            default: break
            }
         }
    
    override var prefersStatusBarHidden: Bool {
         return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
