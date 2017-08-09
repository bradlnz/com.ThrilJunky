//import UIKit
//import Koloda
//
//private var numberOfCards: Int = 5
//
//class TestSlideShowController: UIViewController {
//    
//    @IBOutlet weak var kolodaView: KolodaView!
//    var slideshowOverlay: JBKenBurnsView!
//    
//    fileprivate var dataSource: [UIImage] = {
//        var array: [UIImage] = []
//       // for index in 0..<numberOfCards {
//            array.append(UIImage(named: "bg")!)
//        //}
//        
//        return array
//    }()
//    
//    // MARK: Lifecycle
//    override func viewDidLoad() {
//        super.viewDidLoad()
//      
//        kolodaView.dataSource = self
//        kolodaView.delegate = self
//        
//        self.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
//        
//        
//
//    }
//    
//    
//    // MARK: IBActions
//    @IBAction func leftButtonTapped() {
//        kolodaView?.swipe(.left)
//    }
//    
//    @IBAction func rightButtonTapped() {
//        kolodaView?.swipe(.right)
//    }
//    
//    @IBAction func undoButtonTapped() {
//        kolodaView?.revertAction()
//    }
//}
//
//// MARK: KolodaViewDelegate
//extension TestSlideShowController: KolodaViewDelegate {
//    
//    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
//     let position = kolodaView.currentCardIndex
////        for i in 1...4 {
////            dataSource.append(UIImage(named: "bg")!)
////        }
////        
////    
//    }
//    
//    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
//        UIApplication.shared.openURL(URL(string: "https://yalantis.com/")!)
//    }
//    
//}
//
//// MARK: KolodaViewDataSource
//extension TestSlideShowController: KolodaViewDataSource {
//    
//    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
//        return dataSource.count
//    }
//    
//    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
//        return .default
//    }
//    
//    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
//        return UIView()
//        
//    }
//    
//    func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
//        return Bundle.main.loadNibNamed("OverlayView", owner: self, options: nil)?[0] as? OverlayView
//    }
//}

