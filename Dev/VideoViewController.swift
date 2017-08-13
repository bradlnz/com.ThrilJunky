import Foundation
import UIKit
import Firebase
import AVKit
import APESuperHUD

class VideoViewController: UIViewController {
    
    let storageRef = FIRStorage.storage().reference()
    var user = FIRAuth.auth()?.currentUser!
    let ref =  FIRDatabase.database().reference()
    
    var businessName : String = ""
    var address : String = ""
    var phone : String = ""
    var website : String = ""
    var aKey : String = ""
    
    private var videoURL: URL
    
    
    var player: AVPlayer?
    var playerController : AVPlayerViewController?
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    
    init(videoURL: URL) {
        self.videoURL = videoURL
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        player?.play()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.gray
        player = AVPlayer(url: videoURL)
        playerController = AVPlayerViewController()
        
        guard player != nil && playerController != nil else {
            return
        }
        playerController!.showsPlaybackControls = false
        
        playerController!.player = player!
        self.addChildViewController(playerController!)
        self.view.addSubview(playerController!.view)
        playerController!.view.frame = view.frame
        NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReachEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.player!.currentItem)
        
        let cancelButton = UIButton(frame: CGRect(x: 10.0, y: 10.0, width: 30.0, height: 30.0))
        cancelButton.tintColor = UIColor.white
        cancelButton.setImage(UIImage(named: "icons8-delete_sign_filled"), for: UIControlState())
        cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        view.addSubview(cancelButton)
        
        let addButton = UIButton(frame: CGRect(x:  self.view.frame.width - 40.0, y: 10.0, width: 30.0, height: 30.0))
        addButton.tintColor = UIColor.white
        addButton.setImage(UIImage(named: "icons8-checkmark_filled"), for: UIControlState())
        addButton.addTarget(self, action: #selector(add), for: .touchUpInside)
        view.addSubview(addButton)
    }
    
    @objc fileprivate func playerItemDidReachEnd(_ notification: Notification) {
        if self.player != nil {
            self.player!.seek(to: kCMTimeZero)
            self.player!.play()
        }
    }
    
    func cancel() {
        dismiss(animated: true, completion: nil)
    }
    func getThumbnailFrom(path: URL) -> UIImage? {
        
        do {
            
            let asset = AVURLAsset(url: path , options: nil)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(0, 1), actualTime: nil)
            let thumbnail = UIImage(cgImage: cgImage)
            
            return thumbnail
            
        } catch let error {
            
            print("*** Error generating thumbnail: \(error.localizedDescription)")
            return nil
            
        }
        
    }
    func add() {
        APESuperHUD.showOrUpdateHUD(loadingIndicator: .standard, message: "Uploading...", presentingView: self.view)
        
        self.ref.child("businesses").queryOrdered(byChild: "uid").queryEqual(toValue: user!.uid).observe(.value, with: { (snapshot) in
            // Get user value
            
            for item in snapshot.children {
                let business = BusinessModel(snapshot: item as! FIRDataSnapshot)
                
                self.businessName = business.businessName
                self.address = business.address
                self.website = business.website
                self.phone = business.phone
                
            }
        }) { (error) in
            print(error.localizedDescription)
        }
     
        let data = NSData(contentsOf: videoURL) as Data?
        // let data = UIImagePNGRepresentation(backgroundImage) as Data?
        
        let a = self.ref.child("videos").childByAutoId().key
        let stoRef = self.storageRef.child("videos/\(self.user!.uid)/\(a).mp4")
        self.aKey = a
       
        let uploadTask = stoRef.put(data!, metadata: nil) { (metadata, error) in
            
        }
        
        // Listen for state changes, errors, and completion of the upload.
        uploadTask.observe(.pause) { snapshot in
            // Upload paused
        }
        
        uploadTask.observe(.resume) { snapshot in
            // Upload resumed, also fires when the upload starts
        }
        
        uploadTask.observe(.progress) { snapshot in
            
        }
        
        uploadTask.observe(.failure) { snapchat in
            APESuperHUD.showOrUpdateHUD(icon: IconType.sadFace, message: "Incomplete.. Try again", presentingView: self.view, completion: nil)
        }
        
        
        uploadTask.observe(.success) { snapshot in
            
            
            let img = self.getThumbnailFrom(path: URL(string: "https://project-316688844667019748.appspot.com.storage.googleapis.com/videos/\(self.user!.uid)/\(self.aKey).mp4")!)
            
            let dataImg = UIImageJPEGRepresentation(img!, 1) as Data?
            
            let imgMetadata = FIRStorageMetadata()
            imgMetadata.contentType = "image/jpeg"
              let stoRef = self.storageRef.child("videos/\(self.user!.uid)/\(a).jpg")
            let uploadTaskImg = stoRef.put(dataImg!, metadata: imgMetadata) { (metadata, error) in
                
            }
            
            // Listen for state changes, errors, and completion of the upload.
            uploadTaskImg.observe(.pause) { snapshot in
                // Upload paused
            }
            
            uploadTaskImg.observe(.resume) { snapshot in
                // Upload resumed, also fires when the upload starts
            }
            
            uploadTaskImg.observe(.progress) { snapshot in
                
            }
            
            uploadTaskImg.observe(.failure) { snapchat in
                APESuperHUD.showOrUpdateHUD(icon: IconType.sadFace, message: "Incomplete.. Try again", presentingView: self.view, completion: nil)
            }
            
            
            uploadTaskImg.observe(.success) { snapshot in
                print("done!")
                
                let date = Date()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssZZZ"
                dateFormatter.timeZone = TimeZone.autoupdatingCurrent
                
                print(dateFormatter.string(from: date))
                let parseDate = dateFormatter.string(from: date)
                
                let image = ["uid": self.user!.uid,
                             "displayTitle": self.businessName,
                             "displayName": self.businessName,
                             "userGenerated": "true",
                             "address": self.address,
                             "videoPath" : "https://project-316688844667019748.appspot.com.storage.googleapis.com/videos/\(self.user!.uid)/\(self.aKey).mp4",
                    "imagePath": "https://project-316688844667019748.appspot.com.storage.googleapis.com/videos/\(self.user!.uid)/\(self.aKey).jpg",
                    "latitude": "\(SingletonData.staticInstance.selectedObject!.lat)",
                    // "tags": tags,
                    "longitude": "\(SingletonData.staticInstance.selectedObject!.lng)",
                    "createdAt": parseDate] as [String : Any]
                
                self.ref.updateChildValues(["/videos/\(self.aKey)": image])
                
                
                APESuperHUD.showOrUpdateHUD(icon: .checkMark, message: "Completed", presentingView: self.view, completion: {
                    APESuperHUD.removeHUD(animated: true, presentingView: self.view, completion: { _ in
                        // Completed
                    })
                    self.player?.pause()
                    self.dismiss(animated: true, completion: {
                        
                    })
                    
                })
                
            }
            
           
            
        }
    }
}


