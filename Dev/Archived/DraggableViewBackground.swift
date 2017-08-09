////
////  DraggableViewBackground.swift
////  ThrilJunky
////
////  Created by Lietz on 8/10/2016.
////  Copyright © 2016 ThrilJunky LLC. All rights reserved.
////
//
//
//import Foundation
//import UIKit
//import Firebase
//
//
//class DraggableViewBackground: UIView, DraggableViewDelegate {
//    
//    
//    static var staticInstance = DraggableViewBackground()
//    let MAX_BUFFER_SIZE = 0
//    var CARD_HEIGHT = CGFloat()
//    var CARD_WIDTH = CGFloat()
//    var delegateBg : DraggableViewBgDelegate?
//     var ref: FIRDatabaseReference?
//
//    let menuButton = UIButton()
//    let messageButton = UIButton()
//    let checkButton = UIButton()
//    let xButton = UIButton()
//    var videos = [FIRItem]()
//    var loadedCards = NSMutableArray()
//    var allCards =  NSMutableArray()
//    var cardsLoadedIndex = 0
//    var numLoadedCardsCap = 0
//    var Card : DraggableView?
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        
//        
//        for item in subviews {
//            item.removeFromSuperview()
//        }
//        
//        super.layoutSubviews()
//        setupView()
//        setLoadedCardsCap()
//        
//        self.Card?.frame = frame
//        videos = SingletonData.staticInstance.closestVideo
//     
//        let cardFrame = CGRect(x: 0, y: 0, width: frame.width + 20, height: frame.height)
//        createCard(cardFrame, index: 0)
//         self.Card?.delegate = self
//    }
//    
//    func setupView() {
//        setBackgroundColor()
//        CARD_HEIGHT = self.frame.size.height
//        CARD_WIDTH = self.frame.size.width - 28
//        
//        print(CARD_WIDTH)
//        print(CARD_HEIGHT)
//    }
//    
//    func setBackgroundColor() {
//        self.backgroundColor = UIColor.clear
//    }
//    
//
//    func setLoadedCardsCap() {
//        numLoadedCardsCap = 0;
//        if (self.videos.count > MAX_BUFFER_SIZE) {
//            numLoadedCardsCap = MAX_BUFFER_SIZE
//            print(numLoadedCardsCap)
//        } else {
//            numLoadedCardsCap = self.videos.count
//        }
//        
//    }
//    
//    func createCard(_ frame: CGRect, index: Int) {
//       
//        print(self.videos)
//        
//        
//        if(self.videos.count > 0){
//      
//            let item = self.videos[index]
//        
//
//        if(item.ActivityCategory != "" && item.address != "" && item.displayTitle != "" && item.imagePath != "" && item.latitude != "" && item.longitude != "" && item.taggedLocation != "" && item.videoPath != ""){
//      
//            let cardFrame = CGRect(x: 14, y: -145, width: self.CARD_WIDTH, height: self.CARD_HEIGHT)
//            self.Card = DraggableView(frame: cardFrame, video: item)
//    
//        self.addSubview(self.Card!)
//        self.cardsLoadedIndex += 1
//                
//        }
//        
//        }
//    }
//
//    
//    
//    func cardSwipedLeft(_ card: DraggableView) {
//        delegateBg?.addedToPicks()
//        processCardSwipe()
//        
//        
//        DispatchQueue.main.async {
//            self.ref = FIRDatabase.database().reference()
//            
//            
//            let video = ["uid": card.videoItem.uid,
//                         "ActivityCategory": card.videoItem.ActivityCategory,
//                         "displayTitle": card.videoItem.displayTitle,
//                         "displayName": card.videoItem.displayName,
//                         "taggedLocation": card.videoItem.taggedLocation,
//                         "userPhoto": card.videoItem.userPhoto,
//                         "address": card.videoItem.address,
//                         "videoPath" : card.videoItem.videoPath,
//                         "imagePath": card.videoItem.imagePath,
//                         "latitude": String(card.videoItem.lat),
//                         "longitude": card.videoItem.longitude,
//                         "createdAt": card.videoItem.createdAt,
//                         "show": "false"]
//            
//            let userId = FIRAuth.auth()?.currentUser?.uid
//            let key = card.videoItem.key //self.ref?.child("profiles").child(userId!).child("picks").childByAutoId().key
//            
//            
//            self.ref?.child("profiles").child(userId!).child("picks").updateChildValues([key : video])
//        }    }
//    
//    func cardSwipedRight(_ card: DraggableView) {
//     
//        delegateBg?.addedToPicks()
//        processCardSwipe()
//        
//        
//         DispatchQueue.main.async {
//        self.ref = FIRDatabase.database().reference()
//        
//        
//        let video = ["uid": card.videoItem.uid,
//                     "ActivityCategory": card.videoItem.ActivityCategory,
//                     "displayTitle": card.videoItem.displayTitle,
//                     "displayName": card.videoItem.displayName,
//                     "taggedLocation": card.videoItem.taggedLocation,
//                     "userPhoto": card.videoItem.userPhoto,
//                     "address": card.videoItem.address,
//                     "videoPath" : card.videoItem.videoPath,
//                     "imagePath": card.videoItem.imagePath,
//                     "latitude": String(card.videoItem.latitude),
//                     "longitude": card.videoItem.longitude,
//                     "createdAt": card.videoItem.createdAt,
//                     "show": "true"]
//        
//        let userId = FIRAuth.auth()?.currentUser?.uid
//        let key = card.videoItem.key //self.ref?.child("profiles").child(userId!).child("picks").childByAutoId().key
//        
//
//        self.ref?.child("profiles").child(userId!).child("picks").updateChildValues([key : video])
//        }
//    }
//    
//    
//    func cardTapped(_ card: DraggableView) {
//        delegateBg?.cardTapped(self)
//    }
//    
//    func processCardSwipe() {
//    
//        
//        for item in subviews{
//            item.removeFromSuperview()
//        }
//        if (moreCardsToLoad()) {
//            loadNextCard()
//        } else {
//            delegateBg?.noMoreCardsToLoad()
//        }
//    }
//    
//   // func noMoreCardsToLoad(){
//       
//  //  }
//    
//    func moreCardsToLoad() -> Bool {
//        let moreToLoad = cardsLoadedIndex < SingletonData.staticInstance.closestVideo.count
//        
//        if moreToLoad == false {
//            self.delegateBg?.noMoreCardsToLoad()
//            return false
//        } else {
//            return true
//        }
//    }
//    
//    func loadNextCard() {
//        let cardFrame = CGRect(x: -20, y: 0, width: self.frame.width + 20, height: self.frame.height)
//        createCard(cardFrame, index: cardsLoadedIndex)
//         self.Card?.delegate = self
//    }
//    
//
//    
//    func swipeRight() {
//  
//        let dragView = loadedCards[0] as! DraggableView
//        print ("Clicked right", terminator: "")
//        dragView.rightClickAction()
//        dragView.removeFromSuperview()
//    }
//    
//    func swipeLeft() {
//      
//        let dragView = loadedCards[0] as! DraggableView
//        print ("clicked left", terminator: "")
//        dragView.leftClickAction()
//             dragView.removeFromSuperview()
//    }
//    
//    deinit {
//        print("deinit drag bg view")
//        print(subviews.count)
//        for item in subviews {
//            item.removeFromSuperview()
//        }
//    }
//}
//
//protocol DraggableViewBgDelegate {
// 
//    func cardTapped(_ card: DraggableViewBackground)
//    func addedToPicks()
//    func noMoreCardsToLoad()
//}
//
