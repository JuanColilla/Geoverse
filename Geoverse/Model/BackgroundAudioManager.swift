//
//  BackgroundAudioManager.swift
//  Geoverse
//
//  Created by Renzo Luna Liendo on 28/04/2020.
//  Copyright © 2020 Renzo Luna Liendo. All rights reserved.
//
import Foundation
import AVFoundation

class BackgroundAudioManager {
    
    // Creamos un AudioPlayer y una "ruta" a la que en el constructor le asignaremos un valor.
    var backgroundAP: AVAudioPlayer?
    var url: URL
    
    init() {
        url = URL(string: Bundle.main.path(forResource: "arcade_background", ofType: "mp3")!)!
    }
    
    // Preparativos para el reproductor de audio, le pasamos la ruta del archivo de audio, un volumen y le decimos "calienta que sales".
    func prepareBackgroundAudio() {
        backgroundAP = try? AVAudioPlayer(contentsOf: url, fileTypeHint: nil)
        backgroundAP?.setVolume(0.15, fadeDuration: 0)
        backgroundAP?.prepareToPlay()
    }
    
    func playAudio() {
        backgroundAP?.play()
    }
    
    func pauseAudio() {
        backgroundAP?.pause()
    }
    
    // Meramente para comprobar si está reproduciendo.
    func isPlaying() -> Bool {
        return backgroundAP!.isPlaying
    }
    
}
