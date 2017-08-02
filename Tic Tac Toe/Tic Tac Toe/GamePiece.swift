//
//  GamePiece.swift
//  Tic Tac Toe
//
//  Created by Michael Meyer on 8/1/17.
//  Copyright © 2017 Michael Meyer. All rights reserved.
//

import UIKit

class GamePiece: UIImageView {
    
    // MARK: Properties
    
    var xPlay = 105
    let xNoPlay = 103
    var oPlay = 110
    let oNoPlay = 104

    //
    // MARK: - Initialization
    //
    
    init (type: String, inPlay: Bool) {
        if (type == "xicon" && inPlay) {
            super.init(frame : CGRect(x: 16, y: 557, width: 90, height: 90))
            self.isUserInteractionEnabled = true
            self.tag = xPlay
            xPlay += 1
        } else if (type == "xicon" && !inPlay) {
            super.init(frame : CGRect(x: 16, y: 557, width: 90, height: 90))
            self.isUserInteractionEnabled = false
            self.alpha = 0.5
            self.tag = xNoPlay
        } else if (type == "oicon" && inPlay) {
            super.init(frame : CGRect(x: 269, y: 557, width: 90, height: 90))
            self.isUserInteractionEnabled = true
            self.tag = oPlay
            oPlay += 1
        } else {
            super.init(frame : CGRect(x: 269, y: 557, width: 90, height: 90))
            self.isUserInteractionEnabled = false
            self.alpha = 0.5
            self.tag = oNoPlay
        }
        self.image = UIImage(named: type)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //
    // MARK: - Lifecyle
    //
//    override func didMoveToSuperview() {
//        
//        SoundManager.sharedInstance.playTink()
//        
//        // Animate it
//        UIView.animate(withDuration: 2.0, delay: 1.0, options: UIViewAnimationOptions(), animations: { () -> Void in
//            self.center = (self.superview?.center)!
//        }) { (finished) -> Void in
//            print("The groundhog has risen")
//        }
//    }

}
