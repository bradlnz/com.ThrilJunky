import Foundation
import UIKit
import Firebase
import AVKit

class VideoViewController: UIViewController {
    
    let storageRef = FIRStorage.storage().reference()
    var user = FIRAuth.auth()?.currentUser!
    let ref =  FIRDatabase.database().reference()
    
    var businessName : String = ""
    var address : String = ""
    var phone : String = ""
    var website : String = ""
    
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
    
    func add() {
        
        self.ref.child("businesses").queryOrdered(byChild: "uid").queryEqual(toValue: user!.uid).observe(.value, with: { (snapshot) in
            // Get user value
            
            for var item in snapshot.children {
                let business = BusinessModel(snapshot: item as! FIRDataSnapshot)
                
                self.businessName = business.businessName
                self.address = business.address
                self.website = business.website
                self.phone = business.phone
                
            }
        }) { (error) in
            print(error.localizedDescription)
        }
        
        let a = self.ref.child("businesses").childByAutoId().key
        let key = user?.uid as! String
        
        let item = [
            "url" : "\(a).mp4"
        ]
        self.ref.updateChildValues(["/businesses/\(key)/content/\(a)": item])
        
        // Create a reference to the file you want to upload
        let ref = storageRef.child("images/business/\(key)/\(a).mp4")
        
        // Upload the file to the path "images/rivers.jpg"
        
        let data = NSData(contentsOf: videoURL) as Data?
        // let data = UIImagePNGRepresentation(backgroundImage) as Data?
        
        let uploadTask = ref.put(data!, metadata: nil) { (metadata, error) in
            
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
        
        uploadTask.observe(.success) { snapshot in
            print("done!")
            self.dismiss(animated: true, completion: {
                
            })
        }
    }
}


