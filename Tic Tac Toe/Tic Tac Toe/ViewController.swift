//
//  ViewController.swift
//  Tic Tac Toe
//
//  Created by Michael Meyer on 7/31/17.
//  Copyright © 2017 Michael Meyer. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK: Properties
    
    @IBOutlet weak var board: UIImageView!
    @IBOutlet weak var oImage: UIImageView!
    
    
    var isXTurn = true
    var gameInProgress = true
    var canDisplayAWinner = false
    var xoSpots = [UIView]()
    
    // MARK: Actions
    
    @IBAction func infoButton(_ sender: Any) {
        
    }
    
    
    // MARK: Controller methods 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var x = 0
        var y = 92
        for index in 0...8 {
            let someView = UIView(frame: CGRect(x: x, y: y, width: 125, height: 125))
            someView.isHidden = false
            //someView.layer.borderWidth = 5
            //someView.layer.borderColor = UIColor.black.cgColor
            self.view.addSubview(someView)
            xoSpots.append(someView)
            switch index {
            case 0...1, 3...4, 6...7:
                x += 125
            case 2, 5:
                x = 0
                y += 125
            default:
                break
            }
        }
        
//        
//        while (gameInProgress) {
//            if (isXTurn) {
//                
//            } else {
//                
//            }
//            if (canDisplayAWinner) {
//                gameInProgress = false
//            }
//        }
//        self.clearGame()
//        self.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        oImage.alpha = 0.5
        let piece = self.newGamePiece(type: "xicon")
        UIView.animate(withDuration: 1.0, animations: { () -> Void in
            let scaleUpTransform = CGAffineTransform(scaleX: 2.0, y: 2.0)
            piece.transform = scaleUpTransform
        })
        
        UIView.animate(withDuration: 2.0, animations: { () -> Void in
            let scaleDownTransform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            piece.transform = scaleDownTransform
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Custom Functions
    
    private func newGamePiece(type: String) -> GamePiece {
        let xPiece = GamePiece(type: "xicon")
        // Create a pan gesture recoginzer
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        
        // Add a tap gesture recognizer to the box
        xPiece.addGestureRecognizer(panGesture)
        
        self.view.addSubview(xPiece)
        return xPiece
    }
    
    private func clearGame() {
        
    }
    
//    private func displayAWinner() -> Bool {
//        //if
//        return true
//    }
    
    // MARK: Gesture Recognizers
    
    /// Reposition the center of a view to correspond with a touch point
    /// - Parameter recognizer: The gesture that is recognized
    func handlePan(_ recognizer:UIPanGestureRecognizer) {
        
        // Determine where the view is in relation to the superview
        let translation = recognizer.translation(in: self.view)
        
        if let view = recognizer.view {
            // Set the view's center to the new position
            view.center = CGPoint(x:view.center.x + translation.x,
                                  y:view.center.y + translation.y)
        }
        
        // Reset the translation back to zero, so we are dealing
        // in offsets
        recognizer.setTranslation(CGPoint.zero, in: self.view)
        
        if let insideView = recognizer.view {
            if (recognizer.state == .ended) {
                var intersects = [UIView:CGFloat]()
                for spot in xoSpots {
                    if (spot.frame.intersects(insideView.frame)) {
                        // - Attributions: https://stackoverflow.com/questions/1906511/how-to-find-the-distance-between-two-cg-points
                        func distance(_ a: CGPoint, _ b: CGPoint) -> CGFloat {
                            let xDist = a.x - b.x
                            let yDist = a.y - b.y
                            return CGFloat(sqrt((xDist * xDist) + (yDist * yDist)))
                        }
                        let dist = distance(insideView.center, spot.center)
                        print("distance was: \(dist)")
                        intersects[spot] = dist
                    }
                    
                }
                
                for (spot, dist) in intersects {
                    if dist == intersects.values.min() {
                        insideView.center = spot.center
                        //insideView.isUserInteractionEnabled = false
                    }
                }
                
            }
        }
    }


}

