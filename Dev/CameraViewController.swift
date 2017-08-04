//
//  CameraViewController.swift
//  Dev
//
//  Created by Brad Lietz on 21/01/2016.
//  Copyright © 2016 ThrilJunky LLC. All rights reserved.
//

import UIKit
import AVKit
import Firebase
import MapKit
import Photos
import AVFoundation
//import GeoFire


struct MoveKeyboard {
    static let KEYBOARD_ANIMATION_DURATION : CGFloat = 0.3
    static let MINIMUM_SCROLL_FRACTION : CGFloat = 0.2
    static let MAXIMUM_SCROLL_FRACTION : CGFloat = 0.8
    static let PORTRAIT_KEYBOARD_HEIGHT : CGFloat = 216
    static let LANDSCAPE_KEYBOARD_HEIGHT : CGFloat = 162
}

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, AVCaptureFileOutputRecordingDelegate,  UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UITextViewDelegate, UIGestureRecognizerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var resultSearchController: UISearchController? = nil
    var viewController = ViewController()
    
    @IBOutlet weak var captureButton: UIButton!
    @IBOutlet weak var countdownLabel: UILabel!
    @IBOutlet weak var postVideoOverlay: UIView!
    @IBOutlet weak var loadingOverlay: UIActivityIndicatorView!
    @IBOutlet weak var loadingOverlayLayer: UIView!
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet var gestureRecognizer: UIPinchGestureRecognizer!
    @IBOutlet weak var percentageLabel: UILabel!
    @IBOutlet weak var clipsCollectionView: UICollectionView!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var flashButton: UIButton!
   // @IBOutlet weak var categoriesCollectionView: UICollectionView!
    @IBOutlet weak var postVideoScreen: UIView!
   // @IBOutlet weak var quickHint: UITextView!

    @IBOutlet weak var addSuggestion: UIButton!
    @IBOutlet weak var displayTitle: UITextField!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var tagButton: UIButton!
    @IBOutlet weak var suggestionsView: UIView!
    
    var activityCategories : [String]?
    var frontCamera:Bool = true
    var businesses:[MKMapItem] = []
    var localSearchResponse :  MKLocalSearchResponse? = nil


    var images = [UIImage(named: "Indoor"),
                  UIImage(named: "Outdoor"),
                  UIImage(named: "Food"),
                  UIImage(named: "Nightlife"),
                  UIImage(named: "Events"),
                  UIImage(named: "sightseeingIcon")]
    
    
    var categories: [String] = ["Indoor",
                                "Outdoor",
                                "Food",
                                "Nightlife",
                                "Events",
                                "Other"]
    
    
    @IBOutlet weak var watchButton: UIButton!
    
    var captureSession : AVCaptureSession?
    var backCameraVideoCapture:AVCaptureDevice?
    var frontCameraVideoCapture:AVCaptureDevice?
    var previewLayer : AVCaptureVideoPreviewLayer?
    var outputVideo : AVCaptureVideoDataOutput?
    var vidDelegate : AVCaptureFileOutputRecordingDelegate?
   
    var firstSession = true
    var output:AVCaptureMovieFileOutput!
    var player = AVPlayer()
    var playerItem : AVPlayerItem?
    var playerLayer = AVPlayerLayer()
    var date = Date()
    var locManager = CLLocationManager()
    var videoClips:[URL] = [URL]()
    var mergedClip : URL?
    let limitLength = 100
    var countdownCount = 120
    var alertCount : Int = 0
    var time:Int = 20
    var recordCount: Int = 0
    var videosCount: Int = 0
    var timer:Timer?
    var timerForMerge: Timer?
    var isHighlighted: Bool = false
    var thumbnails = [UIImage]()
    let storage = Storage.storage()
    var ref: DatabaseReference?
    var recordingInProgress : Bool = false
    var assetCollection: PHAssetCollection!
    var albumFound : Bool = false
    var photosAsset: PHFetchResult<AnyObject>!
    var assetThumbnailSize:CGSize!
    var collection: PHAssetCollection!
    var assetCollectionPlaceholder: PHObjectPlaceholder!
    var setPlaceholderQuickHint : String?
    var setPlaceholderQuickMsg : String?
    var delegate: ReloadCardsDelegate?
    let locationsRef = Database.database().reference(withPath: "locations")
    var user = Auth.auth().currentUser!
    var animateDistance: CGFloat!
    var pastUrls = SingletonData.staticInstance.Activities
    var autocompleteUrls = [String]()
    
    @IBOutlet weak var autoCompleteTable: UITableView!

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        SingletonData.staticInstance.setBusinessInfoItem(nil)
        SingletonData.staticInstance.setWebsite(nil)
        SingletonData.staticInstance.setPhoneNumber(nil)
        SingletonData.staticInstance.setName(nil)
        UIApplication.shared.isStatusBarHidden = false
    }
    
    
    func tagLocation(){
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TagLocation")
        self.present(viewController, animated: true, completion: nil)

    }
    
    @IBAction func tagLocation(_ sender: AnyObject) {
        tagLocation()
    }
    
    @IBAction func addSuggestion(_ sender: AnyObject) {
        self.suggestionsView.isHidden = false
        self.autoCompleteTable.isHidden = false
        displayTitle.becomeFirstResponder()
        
        NotificationCenter.default.addObserver(self, selector: #selector(CameraViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CameraViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(CameraViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(CameraViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardDidHide, object: nil)

    }
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.addSuggestion.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(CameraViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CameraViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
   
            self.tagButton.setTitle(SingletonData.staticInstance.selectedObject?.displayTitle, for: UIControlState())
            
        
       
        // Initialize Alert Controller
        let alertController = UIAlertController(title: "How to begin?", message: "Press the circle below to record, press it again to stop recording. When you're done press the tick.", preferredStyle: .alert)
        
        // Initialize Actions
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) -> Void in
            print("The user is okay.")
        }
        
        
        
        // Add Actions
        alertController.addAction(okAction)
       
        if alertCount == 0 {
        // Present Alert Controller
        self.present(alertController, animated: true, completion: nil)
            
        self.alertCount = 1
        }
        
        if self.videoClips.count > 0 {
            self.videoClips.removeAll()
        }
        
        
        if SingletonData.staticInstance.isPostVideo == false {
        DispatchQueue.main.async{
            self.captureSession = AVCaptureSession()
            self.captureSession?.sessionPreset = AVCaptureSession.Preset.high
            
            self.beginSession()
            self.swapCameraInit()
        }
        }
   
}
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
     
        let substring = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        textField.autocapitalizationType = .words
        searchAutocompleteEntriesWithSubstring(substring)
        return true     // not sure about this - could be false
    }
    
    
    func searchAutocompleteEntriesWithSubstring(_ substring: String)
    {
        autocompleteUrls.removeAll(keepingCapacity: false)
        
        for curString in pastUrls!
        {
            
                           let i = curString["Activity"] as? String
            
            if(i != nil){
                            let myString = i! as NSString
            
            
                            var substringRange :NSRange! = myString.range(of: substring)
                            
                            if (substringRange.location == 0)
                            {
                                autocompleteUrls.append(i!)
                            }
                
            }
            
          
        }
        
        if(autocompleteUrls.isEmpty){
            autocompleteUrls.append("Nothing Found.. Tap here to add")
        }
        
        autoCompleteTable.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return autocompleteUrls.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let autoCompleteRowIdentifier = "cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: autoCompleteRowIdentifier, for: indexPath) as! AutocompleteCell
        let index = (indexPath as NSIndexPath).row as Int
        
        cell.result.text = autocompleteUrls[index]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell : AutocompleteCell = tableView.cellForRow(at: indexPath) as! AutocompleteCell
       
        
        self.suggestionsView.isHidden = true
        
    
        if(selectedCell.result.text == "Nothing Found.. Tap here to add"){
            //1. Create the alert controller.
            let alert = UIAlertController(title: "Add Activity Title", message: "Enter the name of your activity.", preferredStyle: .alert)
            
            //2. Add the text field. You can configure it however you need.
            alert.addTextField { (textField) in
                textField.text = ""
            }
            
            // 3. Grab the value from the text field, and print it when the user clicks OK.
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
                self.displayTitle.text = textField?.text
                 self.addSuggestion.setTitle(textField?.text, for: UIControlState())
                SingletonData.staticInstance.setActivityCategory("Other")
                self.tagLocation()
            }))
            
            
            // 4. Present the alert.
            self.present(alert, animated: true, completion: nil)
        } else {
         self.addSuggestion.setTitle(selectedCell.result.text, for: UIControlState())
            self.displayTitle.text = selectedCell.result.text
            
        var count = 0
        for curString in pastUrls!
        {
            
            if(indexPath.count == count){
            let i = curString["ActivityType"] as! String
           
             SingletonData.staticInstance.setActivityCategory(i)
            }
            
            count = count + 1
            
        }
              tagLocation()
        }
      
    }
    
    
    @objc func keyboardWillShow(sender: NSNotification) {
        let userInfo:NSDictionary = sender.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        
        var contentInsets: UIEdgeInsets
        if UIInterfaceOrientationIsPortrait(UIApplication.shared.statusBarOrientation) {
            contentInsets = UIEdgeInsetsMake(0.0, 0.0, (keyboardHeight), 0.0)
        }
        else {
            contentInsets = UIEdgeInsetsMake(0.0, 0.0, (keyboardHeight), 0.0)
        }
        self.autoCompleteTable.contentInset = contentInsets
        self.autoCompleteTable.scrollIndicatorInsets = contentInsets
    }
    @objc func keyboardWillHide(sender: NSNotification) {
 
       // self.autoCompleteTable.scrollToRow(at: sender, at: .top, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      

        self.displayTitle.delegate = self

        autoCompleteTable.delegate = self
        autoCompleteTable.dataSource = self
        autoCompleteTable.isScrollEnabled = true
        autoCompleteTable.isHidden = true
        self.clipsCollectionView.delegate = self
        self.clipsCollectionView.dataSource = self
       // self.categoriesCollectionView.delegate = self
      //  self.categoriesCollectionView.dataSource = self
        clipsCollectionView.canCancelContentTouches = false
        clipsCollectionView.isExclusiveTouch = false
        clipsCollectionView.isPagingEnabled = true
     
        watchButton.isHidden = true
        self.suggestionsView.isHidden = true
        self.postVideoScreen.isHidden = true
        captureButton.isHidden = false
        captureButton.layer.cornerRadius = (captureButton.frame.size.width) / 2
        captureButton.clipsToBounds = true
        self.ref = Database.database().reference()
        self.closeButton.tintColor = UIColor.white
        self.closeButton.addTarget(self, action: #selector(CameraViewController.closeCamera(_:)), for: UIControlEvents.touchUpInside)
        self.postVideoOverlay.isHidden = true
        self.loadingOverlay.isHidden = true
        self.percentageLabel.isHidden = true
        self.loadingOverlayLayer.isHidden = true
        self.flashButton.isHidden = true
        output = AVCaptureMovieFileOutput()
        
        let flashoff : UIImage = UIImage(named: "flashoff")!
       flashButton.setImage(flashoff,for:UIControlState())
        
        let camflip : UIImage = UIImage(named: "camflip")!
        cameraButton.setImage(camflip,for:UIControlState())

        let close : UIImage = UIImage(named: "close")!
        closeButton.setImage(close,for:UIControlState())

        let done : UIImage = UIImage(named: "done")!
        watchButton.setImage(done,for:UIControlState())

                UIApplication.shared.isStatusBarHidden = true
                self.tabBarController?.tabBar.isHidden = true
                self.navigationController?.navigationBar.isHidden = true
    }
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.categories[row]
    }
    
    @IBAction func watchAction(_ sender: AnyObject) {
           self.watchButton.isEnabled = false
        
        self.mergeVideoClips()
    }
    @IBAction func swapCamera(_ sender: AnyObject) {
        swapCameraInit()
    }
    
    func swapCameraInit(){
        for i in 0 ..< captureSession!.inputs.count {
            
            let input = captureSession!.inputs[i] as! AVCaptureDeviceInput
            let device = input.device as AVCaptureDevice
            
            if device.hasMediaType(AVMediaType.video){
                captureSession?.removeInput(input)
            }
        }
        if frontCamera{
            self.flashButton.isHidden = false
        try! captureSession?.addInput(AVCaptureDeviceInput(device: backCameraVideoCapture!))
        }else{
            self.flashButton.isHidden = true
        try! captureSession?.addInput(AVCaptureDeviceInput(device: frontCameraVideoCapture!))
        }
        
        frontCamera = !frontCamera

    }
  
    @IBAction func toggleFlash(_ sender: AnyObject) {
        for i in 0 ..< captureSession!.inputs.count {
            
            let input = captureSession!.inputs[i] as! AVCaptureDeviceInput
            let device = input.device as AVCaptureDevice
            
            if device.hasMediaType(AVMediaType.video){
                
                try! device.lockForConfiguration()
                if device.hasTorch && !device.isTorchActive {
                    
                    device.torchMode = AVCaptureDevice.TorchMode.on
                    let img : UIImage = UIImage(named: "flash")!
                    flashButton.setImage(img,for:UIControlState())
                    
                }else{
                    device.torchMode = AVCaptureDevice.TorchMode.off
                    let img : UIImage = UIImage(named: "flashoff")!
                    flashButton.setImage(img,for:UIControlState())
                }
                
                device.unlockForConfiguration()
                
            }
            
            
        }

    }
 
 
    
    func delay(_ time: Double, closure: @escaping () -> () ) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(time * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
    
    func getThumbnail(_ outputFileURL:URL) -> UIImage {
        
        let clip = AVURLAsset(url: outputFileURL)
        let imgGenerator = AVAssetImageGenerator(asset: clip)
        let cgImage = try! imgGenerator.copyCGImage(
            at: CMTimeMake(0, 1), actualTime: nil)
        let uiImage = UIImage(cgImage: cgImage)
        return uiImage
        
    }
    
    @IBAction func handlePinch(_ sender: AnyObject) {
        
        var device: AVCaptureDevice = self.backCameraVideoCapture!
        
        
        let pinchZoomScaleFactor: CGFloat = self.gestureRecognizer.scale
        var error:NSError!
        do{
            try device.lockForConfiguration()
            defer {device.unlockForConfiguration()}
            if (pinchZoomScaleFactor < device.activeFormat.videoMaxZoomFactor){
                device.videoZoomFactor = 1.0 + gestureRecognizer.scale
            }
        }catch error as NSError{
            
        }catch _{
            
        }
    }
    func ResizeImage(_ image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        let textViewRect : CGRect = self.view.window!.convert(textView.bounds, from: textView)
        let viewRect : CGRect = self.view.window!.convert(self.view.bounds, from: self.view)
        let midline : CGFloat = textViewRect.origin.y + 0.5 * textViewRect.size.height
        let numerator : CGFloat = midline - viewRect.origin.y - MoveKeyboard.MINIMUM_SCROLL_FRACTION * viewRect.size.height
        let denominator : CGFloat = (MoveKeyboard.MAXIMUM_SCROLL_FRACTION - MoveKeyboard.MINIMUM_SCROLL_FRACTION) * viewRect.size.height
        var heightFraction : CGFloat = numerator / denominator
        
        if heightFraction > 1.0 {
            heightFraction = 1.0
        }
        let orientation : UIInterfaceOrientation = UIApplication.shared.statusBarOrientation
        if (orientation == UIInterfaceOrientation.portrait || orientation == UIInterfaceOrientation.portraitUpsideDown) {
            animateDistance = floor(MoveKeyboard.PORTRAIT_KEYBOARD_HEIGHT * heightFraction)
        } else {
            animateDistance = floor(MoveKeyboard.LANDSCAPE_KEYBOARD_HEIGHT * heightFraction)
        }
        
        var viewFrame : CGRect = self.view.frame
        viewFrame.origin.y -= animateDistance
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(TimeInterval(MoveKeyboard.KEYBOARD_ANIMATION_DURATION))
        self.view.frame = viewFrame
        UIView.commitAnimations()
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        var viewFrame : CGRect = self.view.frame
        viewFrame.origin.y += animateDistance
        
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        
        UIView.setAnimationDuration(TimeInterval(MoveKeyboard.KEYBOARD_ANIMATION_DURATION))
        
        self.view.frame = viewFrame
        
        UIView.commitAnimations()
        
    }
    private func textViewShouldReturn(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return true
    }
    
 func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
 
    
    @IBAction func nextButton(_ sender: AnyObject) {
    
            
            self.postVideoScreen.isHidden = true
            
            self.postVideo()
    }
    
    
    @IBAction func closeSuggestions(_ sender: AnyObject) {
        self.suggestionsView.isHidden = true
    }
    
    func beginSession(){

        // Initialize the captureSession object.
        self.captureSession = AVCaptureSession()
        // Set the input device on the capture session.
        //Add Audio Input
     
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
        cameraView.clipsToBounds = true
        previewLayer?.frame = self.view.bounds
        self.cameraView.layer.addSublayer(previewLayer!)
        
        captureSession?.startRunning()
        
        
        // start by adding audio capture
        do{
            let audioDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaType.audio)
            let inputAudio = try AVCaptureDeviceInput(device: audioDevice)
             captureSession?.addInput(inputAudio)
        }catch{
            print(error)
            return
        }
        
        do{
            
            let devices = AVCaptureDevice.devices()
            var input : AVCaptureDeviceInput? = nil
         
                for device in devices
                {
                    
                    
                    if (device as AnyObject).position == AVCaptureDevice.Position.front {
                        frontCameraVideoCapture = device as? AVCaptureDevice
                        input = try AVCaptureDeviceInput(device: self.frontCameraVideoCapture!)
                        
                    } else if (device as AnyObject).position == AVCaptureDevice.Position.back {
                        backCameraVideoCapture = device as? AVCaptureDevice
                        input = try AVCaptureDeviceInput(device: self.backCameraVideoCapture!)
                        
                    }
                    
                }
                
                captureSession?.addInput(input!)

        }catch{
            print(error)
            return
        }
        
        output = AVCaptureMovieFileOutput()
        
        
        let maxDuration = CMTimeMakeWithSeconds(10, 1200)
        output.maxRecordedDuration = maxDuration
        captureSession?.addOutput(output)
        let connection = output.connection(with: AVMediaType.video)
        connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        captureSession?.sessionPreset = AVCaptureSession.Preset.hd1280x720
        captureSession?.commitConfiguration()
        
     
    
    }
    
  
    func parseAddress(_ selectedItem:CLPlacemark) -> String {
        // put a space between "4" and "Melrose Place"
        let firstSpace = (selectedItem.subThoroughfare != nil && selectedItem.thoroughfare != nil) ? " " : ""
        // put a comma between street and city/state
        let comma = (selectedItem.subThoroughfare != nil || selectedItem.thoroughfare != nil) && (selectedItem.subAdministrativeArea != nil || selectedItem.administrativeArea != nil) ? ", " : " "
        // put a space between "Washington" and "DC"
        let secondSpace = (selectedItem.subAdministrativeArea != nil && selectedItem.administrativeArea != nil) ? ", " : " "
        let addressLine = String(
            format:"%@%@%@%@%@%@%@",
            // street number
            selectedItem.subThoroughfare ?? "",
            firstSpace,
            // street name
            selectedItem.thoroughfare ?? "",
            comma,
            // city
            selectedItem.locality ?? "",
            secondSpace,
            // state
            selectedItem.administrativeArea ?? ""
        )
        return addressLine
    }
    
    @IBAction func record(_ sender : UIButton) {
        
        
         DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async{
       
        if self.recordingInProgress {
            DispatchQueue.main.async {
             self.captureButton.backgroundColor = UIColor.white
                  self.watchButton.isHidden = false
        
            self.stopTimer()
         self.stopRecord()
         
            }
            
        }else{
        
         self.recordCount += 1
        
             self.captureButton.isEnabled = false
            let delay = DispatchTime.now() + Double(Int64(0.20 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            
            DispatchQueue.main.asyncAfter(deadline: delay) {
               
                self.captureButton.isEnabled = true
                DispatchQueue.main.async {
                    self.captureButton.backgroundColor = UIColor.red
                    self.watchButton.isHidden = true
                    let uuid = UUID().uuidString
                    let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
                    let outputPath = "\(documentsPath)/\(uuid).mp4"
                    let outputURL = URL(fileURLWithPath: outputPath)
                    
                    self.output.startRecording(to: outputURL, recordingDelegate: self)
                    
                    self.cameraView.layer.addSublayer(self.countdownLabel.layer)
                    
                    
                }
                self.startTimer()
            }
            
           
        }
             self.recordingInProgress = !self.recordingInProgress
      }
        
    }
    
    
    
    func enableButton(){
        self.captureButton.isEnabled = true
    }
 
    @objc func closeCamera(_ sender: UIButton!){
        self.cameraView = nil
        SingletonData.staticInstance.setIsPostVideo(false)
        SingletonData.staticInstance.setSelectedMapItem(nil)
        
          UIApplication.shared.isStatusBarHidden = false
         DispatchQueue.main.async {
           
            self.dismiss(animated: true, completion: {
                self.delegate?.reloadCards(input: true)
            })
            
            
            
        }
    }
    
    

    func startTimer(){
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector:#selector(CameraViewController.addTime), userInfo: nil, repeats: true)
        }
      
    }
    
    func stopTimer(){
        if timer != nil {
            timer?.invalidate()
            timer = nil
    
        }
    }
    
    @objc func addTime(){
        
       
        self.time = self.time - 1
        if(self.time > 0){
         self.countdownLabel.text = "\(time)"
        }
        if time == 0 {
        self.mergeVideoClips()
        
        }
        

    }

 
    
    func mergeVideoClips(){
    
        let composition = AVMutableComposition()
        
        let videoTrack = composition.addMutableTrack(withMediaType: AVMediaType.video, preferredTrackID: CMPersistentTrackID())
        let trackAudio = composition.addMutableTrack(withMediaType: AVMediaType.audio, preferredTrackID: CMPersistentTrackID())

        var insertTime = kCMTimeZero
        
       
        for video in self.videoClips {
            
            print(video)
            let asset = AVAsset(url: video)
            print(asset.duration)
            do {
            let tracks = asset.tracks(withMediaType: AVMediaType.video)
            let audios = asset.tracks(withMediaType: AVMediaType.audio)
            let assetTrack:AVAssetTrack = tracks[0] as AVAssetTrack
            try videoTrack?.insertTimeRange(CMTimeRangeMake(kCMTimeZero, asset.duration), of: assetTrack, at: insertTime)
            let assetTrackAudio:AVAssetTrack = audios[0] as AVAssetTrack
            try trackAudio?.insertTimeRange(CMTimeRangeMake(kCMTimeZero, asset.duration), of: assetTrackAudio, at: insertTime)
            insertTime = CMTimeAdd(insertTime, asset.duration)
            } catch {
                
            }
        }
    
     
            let directory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
             let uuid = UUID().uuidString
        print(uuid)
            let savePath = "\(directory)/\(uuid).mp4"
            let url = URL(fileURLWithPath: savePath)
        
        
            let filePath = url.appendingPathComponent(savePath).path
        let fileManager = FileManager.default
        
        let exporter = AVAssetExportSession(asset: composition, presetName: AVAssetExportPreset1280x720)
        exporter?.outputURL = url
        exporter?.shouldOptimizeForNetworkUse = true
        exporter?.outputFileType = AVFileType.mp4
     
        if fileManager.fileExists(atPath: filePath) {
            print("FILE EXISTS")
            
        } else {
          
            exporter?.exportAsynchronously(completionHandler: {
                print(exporter?.outputURL)
                
                
                if exporter?.status == AVAssetExportSessionStatus.completed
                {
                    self.mergedClip = exporter?.outputURL
                    self.playVideoOutput(exporter?.outputURL)
                    
                    
                    PHPhotoLibrary.shared().performChanges({
                       PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: exporter!.outputURL!)
                        }, completionHandler: { success, error in
                            if !success {
                                print("Failed to create video: %@", error)
                            }
                    })
                }
                
                if exporter?.status == AVAssetExportSessionStatus.exporting {
                    print("Exporting")
                }
                
                if exporter?.status == AVAssetExportSessionStatus.failed {
                    print("Failed")
                      self.watchButton.isEnabled = true
                    self.mergeVideoClips()
                }
                if exporter?.status == AVAssetExportSessionStatus.waiting {
                    print("Waiting")
                }
            })
       
            
        }
        
        
    }

    
    func getPreviewImageForVideoAtURL(_ videoURL: URL, atInterval: Int) -> UIImage? {
        print("Taking pic at \(atInterval) second")
        let asset = AVAsset(url: videoURL)
        let assetImgGenerate = AVAssetImageGenerator(asset: asset)
        assetImgGenerate.appliesPreferredTrackTransform = true
        let time = CMTimeMake(1, 30)
        do {
            let img = try assetImgGenerate.copyCGImage(at: time, actualTime: nil)
            let frameImg = UIImage(cgImage: img)
            return frameImg
        } catch {
            /* error handling here */
        }
        return nil
    }
    
    func compressVideo(_ inputURL: URL, outputURL: URL, handler:@escaping (_ session: AVAssetExportSession)-> Void)
    {
        let urlAsset = AVURLAsset(url: inputURL, options: nil)
        let exportSession = AVAssetExportSession(asset: urlAsset, presetName: AVAssetExportPresetMediumQuality)
        
        exportSession!.outputURL = outputURL
        exportSession!.outputFileType = AVFileType.mp4
        exportSession!.shouldOptimizeForNetworkUse = true
        exportSession!.exportAsynchronously { () -> Void in
            
            handler(exportSession!)
        }
    }
    func fileOutput(_ captureOutput: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
    }
    
    func fileOutput(_ captureOutput: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
    
        DispatchQueue.main.async {
          //  self.previewLayer!.removeFromSuperlayer()
            
            self.cropVideo(outputFileURL)
            
           // self.mergeVideoClips()
                }
        //playVideoOutput(outputFileURL)
    }
    
    
    
    
    func cropVideo(_ outputFileURL:URL){
        
       
        let videoAsset: AVAsset = AVAsset(url: outputFileURL) as AVAsset
        
        let clipVideoTrack = videoAsset.tracks(withMediaType: AVMediaType.video).first! as AVAssetTrack
        
        let composition = AVMutableComposition()
        composition.addMutableTrack(withMediaType: AVMediaType.video, preferredTrackID: CMPersistentTrackID())
        
        let videoComposition = AVMutableVideoComposition()
        
        videoComposition.renderSize = CGSize(width: 720, height: 1280)
        videoComposition.frameDuration = CMTimeMake(1, 30)
        
        let instruction = AVMutableVideoCompositionInstruction()
        
        instruction.timeRange = CMTimeRangeMake(kCMTimeZero, CMTimeMakeWithSeconds(180, 600))
        
        // rotate to portrait
        let transformer:AVMutableVideoCompositionLayerInstruction = AVMutableVideoCompositionLayerInstruction(assetTrack: clipVideoTrack)
        let t1 = CGAffineTransform(translationX: 720, y: 0);
        let t2 = t1.rotated(by: CGFloat(M_PI_2));
        
        transformer.setTransform(t2, at: kCMTimeZero)
        instruction.layerInstructions = [transformer]
        videoComposition.instructions = [instruction]
        
        
        let uuid = UUID().uuidString
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        let outputPath = "\(documentsPath)/\(uuid).mp4"
        let outputURL = URL(fileURLWithPath: outputPath)
        let exporter = AVAssetExportSession(asset: videoAsset, presetName: AVAssetExportPresetHighestQuality)!
        exporter.videoComposition = videoComposition
        exporter.outputURL = outputURL
        exporter.outputFileType = AVFileType.mov
        
        exporter.exportAsynchronously(completionHandler: { () -> Void in
            DispatchQueue.main.async(execute: {
                
                if exporter.status == AVAssetExportSessionStatus.completed {
                         self.handleExportCompletion(exporter)
                } else {
                   print("Not complete")
                }
           
            })
        })
    }

    
    func handleExportCompletion(_ session: AVAssetExportSession) {
         let thumbnail =  self.getThumbnail(session.outputURL!)
        videoClips.append(session.outputURL!)
        
        thumbnails.append(thumbnail)
        print(thumbnails.count)
        
        self.clipsCollectionView.reloadData()
    let indexPath = IndexPath(item: thumbnails.count - 1, section: 0)
      self.clipsCollectionView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.right, animated: true)
    }

    
    func playVideoOutput(_ outputFileURL : URL!)
    {
        DispatchQueue.main.async {
            self.captureButton.isHidden = true
            self.closeButton.isHidden = true
            self.previewLayer?.isHidden = true
            self.playerLayer = AVPlayerLayer()
            self.playerItem = AVPlayerItem(url: outputFileURL!)
            self.player = AVPlayer(playerItem: self.playerItem!)
            self.playerLayer = AVPlayerLayer(player: self.player)
            self.playerLayer.frame = UIScreen.main.bounds
            self.view.layer.addSublayer(self.playerLayer)
            self.view.layer.addSublayer(self.postVideoOverlay.layer)
            self.view.layer.addSublayer(self.loadingOverlayLayer.layer)
            self.view.layer.addSublayer(self.loadingOverlay.layer)
            self.view.layer.addSublayer(self.percentageLabel.layer)
            self.view.layer.addSublayer(self.postVideoScreen.layer)
            self.player.play()
            
            SingletonData.staticInstance.setVideoPlayed(outputFileURL)
            
            DispatchQueue.main.async {
                NotificationCenter.default.addObserver(self, selector: #selector(CameraViewController.playerDidFinishPlaying(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.playerItem)
            }
        }
    }
    
    
    @objc func playerDidFinishPlaying(_ note: Notification) {
        
        self.postVideoScreen.isHidden = false
        self.suggestionsView.isHidden = true
        self.autoCompleteTable.isHidden = true
        //displayTitle.becomeFirstResponder()
        
        let item = SingletonData.staticInstance.selectedObject
    
        SingletonData.staticInstance.setBusinessName(input: item!.displayTitle)
        SingletonData.staticInstance.setAddress(item!.address)

        
        self.captureSession?.stopRunning()
         SingletonData.staticInstance.setIsPostVideo(true)
        self.player.pause()
    

    }

    
    
    

    func dismissKeyboard(){
        view.endEditing(true)
        
    }
    
    func removeOldFileIfExist(_ fileNamePath : String?) {
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        if paths.count > 0 {
            let dirPath = paths[0]
            let fileName = fileNamePath
            let filePath = NSString(format:"%@/%@", dirPath, fileName!) as String
            if FileManager.default.fileExists(atPath: filePath) {
                do {
                    try FileManager.default.removeItem(atPath: filePath)
                    print("old video has been removed")
                } catch {
                    print("an error during a removing")
                }
            }
        }
    }
    
    
    
    func postVideo() {
        let videoToPost = mergedClip
        
        if(videoToPost != nil)
        {
            postVideoInit(videoToPost)
        }

    }
    
    func postVideoInit(_ outputFileURL: URL!)
    {
        self.postVideoOverlay.isHidden = true

    
        self.loadingOverlay.isHidden = false
        self.loadingOverlayLayer.isHidden = false
        self.loadingOverlay.startAnimating()
        
        let currentUser = Auth.auth().currentUser
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
     
        let x = String(Int32.random(0))
        let file  = "compressed_" + x + ".mp4"
        removeOldFileIfExist(file)
        let compressedOutput = documentsURL.appendingPathComponent(file)
        let previewImage = getPreviewImageForVideoAtURL(outputFileURL, atInterval: 1)
        let imageData = UIImageJPEGRepresentation(previewImage!, 0.50)
        let userImgUrl = currentUser?.photoURL
        var userImageData = Data()
        if(userImgUrl != nil){
        userImageData = try! Data(contentsOf: userImgUrl!)
        }
        
        self.compressVideo(outputFileURL, outputURL: compressedOutput, handler: { (session) -> Void in
            
            DispatchQueue.main.async {
                
                print(session.status)
                
                if session.status == AVAssetExportSessionStatus.waiting
                {
                    print("Waiting")
                }
                if session.status == AVAssetExportSessionStatus.exporting
                {
                    print("Exporting")
                }
                if session.status == AVAssetExportSessionStatus.failed
                {
                    print("Failed")
                }
                if session.status == AVAssetExportSessionStatus.completed
                {
                    let data = try? Data(contentsOf: compressedOutput)
                    
                    let videoFile = currentUser!.uid + "_" + x +  ".mp4"
                    let imageFile =  currentUser!.uid + "_" + x + ".jpg"
                    let userPhotoFile = currentUser!.uid + "_UserPhoto_" + x + ".jpg"
                    if SingletonData.staticInstance.location != nil{
                        
                        let key = self.ref!.child("videos").childByAutoId().key
                        let userID : String = currentUser!.uid
                        let activityCategory : String
                        var taggedLocation : String = ""
                    
                        let address : String
                        let latitude : String
                        let longitude : String
                  //      let businessTagged = SingletonData.staticInstance.businessTagged
                        
                        if SingletonData.staticInstance.selectedMapItem != nil {
                            taggedLocation = SingletonData.staticInstance.selectedMapItem!.name!
                        }
                      
                        if SingletonData.staticInstance.activityCategory != nil {
                            activityCategory =  SingletonData.staticInstance.activityCategory!
                            SingletonData.staticInstance.setActivityCategory(nil)
                        } else {
                            activityCategory = "-"
                        }
                        
                        if SingletonData.staticInstance.address != nil {
                            address =  SingletonData.staticInstance.address!
                            SingletonData.staticInstance.setAddress(nil)
                        } else {
                            address = "-"
                        }
                        
                        if SingletonData.staticInstance.location != nil {
                            let lat = SingletonData.staticInstance.location?.coordinate.latitude
                            let lng = SingletonData.staticInstance.location?.coordinate.longitude
                            let numLat = NSNumber(value: (lat)! as Double as Double)
                            let numLong = NSNumber(value: (lng)! as Double as Double)
                            
                            
                            latitude = numLat.stringValue
                            longitude = numLong.stringValue
                            
                        } else {
                            latitude = "-"
                            longitude = "-"
                        }
                        
                        
                        print("File size after compression: \(Double(data!.count))")
                        
                        
                        // Create the file metadata
                        let imgMetadata = StorageMetadata()
                        imgMetadata.contentType = "image/jpeg"
                        let storageImgRef = self.storage.reference()
                      
                        
                          let uploadUserPhotoTask = storageImgRef.child("images/" + userPhotoFile).putData(userImageData, metadata: imgMetadata)
                        
                        // Listen for state changes, errors, and completion of the upload.
                        uploadUserPhotoTask.observe(.pause) { snapshot in
                            // Upload paused
                        }
                        
                        uploadUserPhotoTask.observe(.resume) { snapshot in
                            // Upload resumed, also fires when the upload starts
                        }
                        
                        uploadUserPhotoTask.observe(.progress) { snapshot in
                           
                            
                            self.dismiss(animated: true, completion: {
                                self.delegate?.reloadCards(input: false)
                                
                            })

                        }
                        
                        uploadUserPhotoTask.observe(.success) { snapshot in
                            
                            
                        
                        // Upload file and metadata to the object 'images/mountains.jpg'
                        let uploadTask = storageImgRef.child("images/" + imageFile).putData(imageData!, metadata: imgMetadata);
                        
                        // Listen for state changes, errors, and completion of the upload.
                        uploadTask.observe(.pause) { snapshot in
                            // Upload paused
                        }
                        
                        uploadTask.observe(.resume) { snapshot in
                            // Upload resumed, also fires when the upload starts
                        }
                        
                        uploadTask.observe(.progress) { snapshot in
                   
                                self.percentageLabel.isHidden = false
                                self.loadingOverlay.isHidden = false
                                self.loadingOverlayLayer.isHidden = false
                                self.loadingOverlay.startAnimating()
                                self.percentageLabel.text = ("Initializing")

                        }
                        
                        uploadTask.observe(.success) { snapshot in
                            // Upload completed successfully
                            // Create the file metadata
                            
                           
                            
                            
                            let metadata = StorageMetadata()
                            metadata.contentType = "video/mp4"
                            let storageRef = self.storage.reference()
                            
                            // Upload file and metadata to the object 'images/mountains.jpg'
                            let uploadTask = storageRef.child("videos/" + videoFile).putData(data!, metadata: metadata)
                            
                            // Listen for state changes, errors, and completion of the upload.
                            uploadTask.observe(.pause) { snapshot in
                                // Upload paused
                            }
                            
                            uploadTask.observe(.resume) { snapshot in
                                // Upload resumed, also fires when the upload starts
                                
                            }
                            
                    
                            
                            uploadTask.observe(.progress) { snapshot in
                                // Upload reported progress
                                if let progress = snapshot.progress {
                                    
                                
                                    let percentComplete = 100.0 * Double(progress.completedUnitCount) / Double(progress.totalUnitCount)
                                    print(percentComplete)
                                    
                                    self.percentageLabel.isHidden = false
                                    self.loadingOverlay.isHidden = false
                                    self.loadingOverlayLayer.isHidden = false
                                    self.loadingOverlay.startAnimating()
                                    
                                    self.percentageLabel.text = ("Uploading \(percentComplete)%")
                                }
                            }
                            
                            uploadTask.observe(.success) { snapshot in
                                // Upload completed successfully
                                
                                let date = Date()
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssZZZ"
                                dateFormatter.timeZone = TimeZone.autoupdatingCurrent
                                
                                print(dateFormatter.string(from: date))
                                let parseDate = dateFormatter.string(from: date)
                                let storageRef = self.storage.reference()
                                var videoPath : String?
                                var imagePath : String?
                                var userPhotoPath : String?
                                //  let url : String
                                let videoRef = storageRef.child("videos/" + videoFile)
                                let photoRef = storageRef.child("images/" + imageFile)
                                let userPhotoRef = storageRef.child("images/" + userPhotoFile)
                                
                                // print(setVideoPath)
                                //   Fetch the download URL
                                videoRef.downloadURL { (URL, error) -> Void in
                                    if (error != nil) {
                                        // Handle any errors
                                        
                                    } else {
                                        videoPath = URL?.absoluteString
                                       
                                        photoRef.downloadURL(completion: { (URL, error) in
                                            
                                            imagePath = URL?.absoluteString
                                            
                                            
                                          //  let tags : String = ClarifaiClient.staticInstance.retrieveTags(videoPath)!
                                       
                                            let setImagePath : String = imagePath!
                                            
                                            if let user = Auth.auth().currentUser {
                                                let name = user.displayName
                                                
                                                
                                                userPhotoRef.downloadURL(completion: { (URL, error) in
                                                    userPhotoPath = URL?.absoluteURL.absoluteString
                                              
                                            //    let phone : String = businessTagged!.displayPhone!
                                              //  let website : String = businessTagged!.mobileUrl!
                                                let profilePicture : String = userPhotoPath!
                                                let displayName : String = name!
                                                let displayTitle : String = SingletonData.staticInstance.businessName!//self.displayTitle.text!
//                                                let displayMsg : String = self.quickMsg.text!
                                              //  let displayHint : String = self.quickHint.text!
                                             //  let businessName : String = businessTagged!.name!
                                                
                                       let video = ["uid": userID,
                                                    "displayTitle": displayTitle,
                                                    "displayName": displayName,
                                                   // "displayHint": displayHint,
                                                    "taggedLocation": "-",
                                                    "userPhoto": profilePicture,
                                                    "userGenerated": "true",
//                                                    "displayMsg": displayMsg,
                                                    "address": address,
                                                    "videoPath" : videoFile,
                                                    "imagePath": setImagePath,
                                                    "latitude": latitude,
                                                   // "tags": tags,
                                                    "longitude": longitude,
                                                    "createdAt": parseDate]
                                                
                                                self.ref?.updateChildValues(["/videos/\(key)": video])
                                                self.ref?.updateChildValues(["/profiles/\(userID)/\(key)": video])
                                                
                                           
                                               // let geoFire = GeoFire(firebaseRef: self.locationsRef)
                                                let loc = SingletonData.staticInstance.location
                                               // geoFire?.setLocation(loc, forKey: key)
                                                
                                               self.alertCount = 0
                                              UIApplication.shared.isStatusBarHidden = false
                                                SingletonData.staticInstance.setSelectedMapItem(nil)
                                                SingletonData.staticInstance.setIsPostVideo(false)
                                                    
                                                    self.dismiss(animated: true, completion: {
                                                        
                                                    })
                                                    
//                                                self.dismissViewControllerAnimated(true, completion: {
//                                                    let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Now")
//                                                    self.presentViewController(viewController, animated: true, completion: nil)
//                                                    
//                                                      })
                                                })
                                            } else {
                                                // No user is signed in.
                                            }
                                            
                                            
                                        })
                                        
                                        
                                    }
                                }
                             
                            }
                        
                            
                            // Errors only occur in the "Failure" case
                            uploadTask.observe(.failure) { snapshot in
                                guard let storageError = snapshot.error else { return }
                                guard let errorCode = StorageErrorCode(rawValue: storageError as! Int) else { return }
                                switch errorCode {
                                case .objectNotFound: break
                                    // File doesn't exist
                                    
                                case .unauthorized: break
                                    // User doesn't have permission to access file
                                    
                                case .cancelled: break
                                    // User canceled the upload
                                    
                                case .unknown: break
                                // Unknown error occurred, inspect the server response
                                default: break
                                }
                            }
                            
                        }
                        
                        // Errors only occur in the "Failure" case
                        uploadTask.observe(.failure) { snapshot in
                            guard let storageError = snapshot.error else { return }
                            guard let errorCode = StorageErrorCode(rawValue: storageError as! Int) else { return }
                            switch errorCode {
                            case .objectNotFound: break
                                // File doesn't exist
                                
                            case .unauthorized: break
                                // User doesn't have permission to access file
                                
                            case .cancelled: break
                                // User canceled the upload
                                
                            case .unknown: break
                            // Unknown error occurred, inspect the server response
                            default: break
                            }
                        }
                    }
                 }
                }
                else
                {
                    self.loadingOverlay.isHidden = true
                    self.loadingOverlayLayer.isHidden = true
                    self.dismiss(animated: true, completion: {
                        
                    })
//                    let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Now")
//                    self.presentViewController(viewController, animated: true, completion: nil)
                }
            }
        })
    
    }
    
    

    
    
    func stopRecord() {
        captureButton.isHidden = false
        DispatchQueue.main.async {
            self.output.stopRecording()
        }
    }
    
    

    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
 
//        if collectionView == self.categoriesCollectionView {
//        var cat = self.categories[(indexPath as NSIndexPath).row]
//        
//            
//        switch(cat){
//        case "Indoor Activities":
//            cat = "IndoorActivities"
//            break
//        case "Outdoor Activities":
//            cat = "OutdoorActivities"
//            break
//        case "Food & Dining":
//            cat = "FoodDining"
//            break
//        default:
//            break
//        }
//        
//        
//        SingletonData.staticInstance.setActivityCategory(cat)
//        }
    }
    
    // MARK: - CollectionView stuff
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
//        if collectionView == self.categoriesCollectionView {
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewItemCell
//            
//            cell.catLabel.text = nil
//            cell.imageView.image = nil
//            
//            
//                    cell.imageView.image = self.images[(indexPath as NSIndexPath).row]
//            
//                    cell.catLabel.text = self.categories[(indexPath as NSIndexPath).row]
//                    return cell
//    
//
//        } else {
        
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ThumbnailCell", for: indexPath) as! ThumbnailCollectionViewCell
            cell.thumbnailImageView.image = thumbnails[(indexPath as NSIndexPath).row]
            cell.isExclusiveTouch = false
            return cell
            
       // }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if collectionView == self.categoriesCollectionView {
//            print(self.categories.count)
//            return self.categories.count
//        } else{
            return thumbnails.count
       // }

    }
    

    
    deinit{
        NotificationCenter.default.removeObserver(self)

        print("deinit")
    }
    

}
protocol ReloadCardsDelegate {
    func reloadCards(input : Bool)
}



