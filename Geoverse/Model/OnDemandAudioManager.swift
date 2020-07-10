//
//  OnDemandAudioManager.swift
//  Geoverse
//
//  Created by Renzo Luna Liendo on 28/04/2020.
//  Copyright © 2020 Renzo Luna Liendo. All rights reserved.
//

import Foundation
import AVFoundation

class OnDemandAudioManager {
    
    var ondemandAP: AVAudioPlayer?
    var url: URL = URL(fileURLWithPath: "none")
    
    // A diferencia del "BackgroundAudioManager", aquí tenemos dos posibles archivos a reproducir (correcto o fallido), se lo pasamos por parámetros y ejecutamos todo de golpe en un solo método.
    func playSound(mode: String) {
        url = URL(string: Bundle.main.path(forResource: mode, ofType: "m4a")!)!
        ondemandAP = try? AVAudioPlayer(contentsOf: url, fileTypeHint: nil)
        ondemandAP?.prepareToPlay()
        ondemandAP?.play()
    }
    
}
