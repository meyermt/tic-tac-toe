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
    
    let xTag = 98
    let oTag = 99
    var pieceTag = 105
    var isXTurn = true
    var gameInProgress = true
    var canDisplayAWinner = false
    var xoSpots = [UIView]()
    
    // MARK: Actions
    
    @IBAction func infoButton(_ sender: Any) {
        
        if let oldView = self.view.viewWithTag(120) {
            oldView.removeFromSuperview()
        }
        
        // Get an offscreen position
        let offscreen = CGRect(x: 15, y: -200, width: 340, height: 250)
        
        let infoView = UITextView(frame: offscreen)
        infoView.backgroundColor = UIColor.gray
        infoView.tag = 120
        infoView.text = "\n\n\nWelcome to the classic game of tic tac toe. Here are the rules:\n" +
            "- Each player is assigned a mark, an X or an O\n" +
            "- Players take turns placing their mark in the grid\n" +
        "- The first player to get three of their marks in a row wins!"
        
        // Add the sun to the field
        self.view.addSubview(infoView)
    
        
        let button = UIButton(frame: CGRect(x: 120, y: 190, width: 100, height: 50))
        button.setTitle("Dismiss", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        infoView.addSubview(button)
        
        UIView.animate(withDuration: 0.2, delay: 0.2, options: UIViewAnimationOptions(), animations: { () -> Void in
            SoundManager.sharedInstance.playSwipe()
            infoView.center = self.view.center
        })
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
    
    
    // MARK: Gesture Recognizers
    
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
            if (recognizer.state == .began) {
                SoundManager.sharedInstance.playSwipe()
            }
            
            if (recognizer.state == .ended) {
                trySnapToSquare(insideView)
            }
        }
    }
    
    // MARK: Custom Functions
    
    @objc private func buttonTapped(_ button: UIButton!) {
        guard let infoView = self.view.viewWithTag(120) else {
            return
        }
        UIView.animate(withDuration: 0.3, delay: 0.3, options: UIViewAnimationOptions(), animations: { () -> Void in
            SoundManager.sharedInstance.playSwipe()
            infoView.center = CGPoint(x: 187.5, y: 1000)
        })
    }
    
    private func newInPlayPiece(type: String) {
        
        let piece = GamePiece(type: type, inPlay: true, tagNum: pieceTag)
        pieceTag += 1
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
        let piece = GamePiece(type: type, inPlay: false, tagNum: 0)
        self.view.addSubview(piece)
    }
    
    private func clearWaitingPiece() {
        if let piece = self.view.viewWithTag(103) {
            piece.removeFromSuperview()
        }
        if let piece = self.view.viewWithTag(104) {
            piece.removeFromSuperview()
        }
    }
    
    private func trySnapToSquare(_ insideView: UIView) {
        var intersects = [UIView:CGFloat]()
        var playBuzzer = false
        for spot in xoSpots {
            if (spot.frame.intersects(insideView.frame) && spot.tag != xTag && spot.tag != oTag) {
                // - Attributions: https://stackoverflow.com/questions/1906511/how-to-find-the-distance-between-two-cg-points
                func distance(_ a: CGPoint, _ b: CGPoint) -> CGFloat {
                    let xDist = a.x - b.x
                    let yDist = a.y - b.y
                    return CGFloat(sqrt((xDist * xDist) + (yDist * yDist)))
                }
                let dist = distance(insideView.center, spot.center)
                intersects[spot] = dist
            } else if (spot.frame.intersects(insideView.frame) && (spot.tag == xTag || spot.tag == oTag)) {
                playBuzzer = true
            }
        }
        
        if (playBuzzer && intersects.isEmpty) {
            SoundManager.sharedInstance.playBuzzer()
        }
        
        for (spot, dist) in intersects {
            if dist == intersects.values.min() {
                if (isXTurn) {
                    spot.tag = xTag
                } else {
                    spot.tag = oTag
                }
                animateToSnap(spot: spot, piece: insideView)
                insideView.isUserInteractionEnabled = false
                
                let winner = isWinner()
                
                if (winner == 0) {
                    if (pieceTag == 114) { // the game is a wash
                        self.alertTie()
                    } else {
                        // other person's turn
                        isXTurn = !isXTurn
                        clearWaitingPiece()
                        if (isXTurn) {
                            newInPlayPiece(type: "xicon")
                            newOutPlayPiece(type: "oicon")
                        } else {
                            newInPlayPiece(type: "oicon")
                            newOutPlayPiece(type: "xicon")
                        }
                    }
                } else {
                    SoundManager.sharedInstance.playCongrats()
                    self.alertWinner(winner)
                }
            }
        }
    }
    
    private func animateToSnap(spot: UIView, piece: UIView) {
        UIView.animate(withDuration: 0.2, delay: 0.2, options: UIViewAnimationOptions(), animations: { () -> Void in
            SoundManager.sharedInstance.playNiceMove()
            piece.center = spot.center
        })
    }
    
    private func alertTie() {
        let alert = UIAlertController(title: "Game Over", message: "No one wins!", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "New Game", style: UIAlertActionStyle.default, handler: startNewGame))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func alertWinner(_ winner: Int) {
        let winnerStr = winner == xTag ? "X" : "O"
        let alert = UIAlertController(title: "Game Over", message: "\(winnerStr) wins!", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "New Game", style: UIAlertActionStyle.default, handler: startNewGame))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func isWinner() -> Int {
        var winner = 0
        for tag in [xTag, oTag] {
            if ((xoSpots[0].tag == tag && xoSpots[1].tag == tag && xoSpots[2].tag == tag) ||
                (xoSpots[3].tag == tag && xoSpots[4].tag == tag && xoSpots[5].tag == tag) ||
                (xoSpots[6].tag == tag && xoSpots[7].tag == tag && xoSpots[8].tag == tag) ||
                (xoSpots[0].tag == tag && xoSpots[3].tag == tag && xoSpots[6].tag == tag) ||
                (xoSpots[1].tag == tag && xoSpots[4].tag == tag && xoSpots[7].tag == tag) ||
                (xoSpots[2].tag == tag && xoSpots[5].tag == tag && xoSpots[8].tag == tag) ||
                (xoSpots[0].tag == tag && xoSpots[4].tag == tag && xoSpots[8].tag == tag) ||
                (xoSpots[2].tag == tag && xoSpots[4].tag == tag && xoSpots[6].tag == tag)) {
                winner = tag
            }
        }
        return winner
    }
    
    private func clearAllPieces() {
        for num in 103...114 {
            print("looking for piece")
            if let piece = self.view.viewWithTag(num) {
                print("found piece \(num)")
                piece.removeFromSuperview()
            }
        }
        for view in self.view.subviews {
            view.tag = 0
        }
    }
    
    private func startNewGame(action: UIAlertAction) {
        self.clearAllPieces()
        self.viewDidAppear(true)
    }

}

