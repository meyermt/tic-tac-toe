//
//  SoundManager.swift
//  Tic Tac Toe
//
//  Created by Michael Meyer on 8/1/17.
//  Copyright © 2017 Michael Meyer. All rights reserved.
//

import Foundation
import AudioToolbox

class SoundManager {
    
    static let sharedInstance = SoundManager()
    
    fileprivate init() {}
    
    func playSwipe() {
        // Load in a sound file (must be in the correct format)
        let swipeUrl = Bundle.main.url(forResource: "swipe", withExtension: "caf")!
        
        // Assign an ID to the sound
        var swoosh: SystemSoundID = 0
        
        // Create a system sound
        AudioServicesCreateSystemSoundID(swipeUrl as CFURL, &swoosh)
        
        // Add a completion handlers
        AudioServicesAddSystemSoundCompletion(swoosh, nil, nil, {
            sound, context in
            AudioServicesRemoveSystemSoundCompletion(sound)
            AudioServicesDisposeSystemSoundID(sound)
        }, nil)
        
        // Play the sound
        AudioServicesPlaySystemSound(swoosh)
    }
    
    func playBuzzer() {
        // Load in a sound file (must be in the correct format)
        let buzzUrl = Bundle.main.url(forResource: "buzzer", withExtension: "caf")!
        
        // Assign an ID to the sound
        var buzz: SystemSoundID = 1
        
        // Create a system sound
        AudioServicesCreateSystemSoundID(buzzUrl as CFURL, &buzz)
        
        // Add a completion handlers
        AudioServicesAddSystemSoundCompletion(buzz, nil, nil, {
            sound, context in
            AudioServicesRemoveSystemSoundCompletion(sound)
            AudioServicesDisposeSystemSoundID(sound)
        }, nil)
        
        // Play the sound
        AudioServicesPlaySystemSound(buzz)
    }
    
    func playCongrats() {
        // Load in a sound file (must be in the correct format)
        let congratsUrl = Bundle.main.url(forResource: "congrats", withExtension: "caf")!
        
        // Assign an ID to the sound
        var congrats: SystemSoundID = 2
        
        // Create a system sound
        AudioServicesCreateSystemSoundID(congratsUrl as CFURL, &congrats)
        
        // Add a completion handlers
        AudioServicesAddSystemSoundCompletion(congrats, nil, nil, {
            sound, context in
            AudioServicesRemoveSystemSoundCompletion(sound)
            AudioServicesDisposeSystemSoundID(sound)
        }, nil)
        
        // Play the sound
        AudioServicesPlaySystemSound(congrats)
    }
    
    func playNiceMove() {
        // Load in a sound file (must be in the correct format)
        let niceUrl = Bundle.main.url(forResource: "nicemove", withExtension: "caf")!
        
        // Assign an ID to the sound
        var nice: SystemSoundID = 3
        
        // Create a system sound
        AudioServicesCreateSystemSoundID(niceUrl as CFURL, &nice)
        
        // Add a completion handlers
        AudioServicesAddSystemSoundCompletion(nice, nil, nil, {
            sound, context in
            AudioServicesRemoveSystemSoundCompletion(sound)
            AudioServicesDisposeSystemSoundID(sound)
        }, nil)
        
        // Play the sound
        AudioServicesPlaySystemSound(nice)
    }
    
}
