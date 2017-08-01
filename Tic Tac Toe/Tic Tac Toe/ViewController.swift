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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.newInPlayPiece(type: "xicon")
        self.newOutPlayPiece(type: "oicon")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Custom Functions
    
    private func newInPlayPiece(type: String) {
        
        let piece = GamePiece(type: type, inPlay: true)
        // Create a pan gesture recoginzer
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        
        // Add a tap gesture recognizer to the box
        piece.addGestureRecognizer(panGesture)
        
        self.view.addSubview(piece)
        
        UIView.animate(withDuration: 1.0, animations: { () -> Void in
            let scaleUpTransform = CGAffineTransform(scaleX: 2.0, y: 2.0)
            piece.transform = scaleUpTransform
        })
        
        UIView.animate(withDuration: 2.0, animations: { () -> Void in
            let scaleDownTransform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            piece.transform = scaleDownTransform
        })
    }
    
    private func newOutPlayPiece(type: String) {
        let piece = GamePiece(type: type, inPlay: false)
        self.view.addSubview(piece)
    }
    
    private func clearGame() {
        
    }
    
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
                trySnapToSquare(insideView)
            }
        }
    }
    
    private func trySnapToSquare(_ insideView: UIView) {
        var intersects = [UIView:CGFloat]()
        for spot in xoSpots {
            if (spot.frame.intersects(insideView.frame) && spot.tag != 99) {
                // - Attributions: https://stackoverflow.com/questions/1906511/how-to-find-the-distance-between-two-cg-points
                func distance(_ a: CGPoint, _ b: CGPoint) -> CGFloat {
                    let xDist = a.x - b.x
                    let yDist = a.y - b.y
                    return CGFloat(sqrt((xDist * xDist) + (yDist * yDist)))
                }
                let dist = distance(insideView.center, spot.center)
                intersects[spot] = dist
            }
            
        }
        
        for (spot, dist) in intersects {
            if dist == intersects.values.min() {
                insideView.center = spot.center
                spot.tag = 99 // means it's taken
                // TODO: need to uncomment this
                insideView.isUserInteractionEnabled = false
                
                //checkWinner()
                // other person's turn
                isXTurn = !isXTurn
                if (isXTurn) {
                    newInPlayPiece(type: "xicon")
                    newOutPlayPiece(type: "oicon")
                } else {
                    newInPlayPiece(type: "oicon")
                    newOutPlayPiece(type: "xicon")
                }
            }
        }
    }


}

