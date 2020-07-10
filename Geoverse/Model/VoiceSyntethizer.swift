//
//  VoiceSyntethizer.swift
//  Geoverse
//
//  Created by Renzo Luna Liendo on 28/04/2020.
//  Copyright © 2020 Renzo Luna Liendo. All rights reserved.
//

import Foundation
import AVFoundation

struct VoiceSyntethizerManager {
    
    // Llamamos al sintetizador de voz del sistema y a una voz en español.
    let speechSynthesizer = AVSpeechSynthesizer()
    let voice = AVSpeechSynthesisVoice(language: "es-ES")
 
    // Le pasamos un mensaje al sintetizador de voz y le decimos que lo lea con la voz creada en español y al ritmo deseado.
    func speak(textToSpeak: String) {
        let mensaje = AVSpeechUtterance(string: textToSpeak)
        mensaje.rate = 0.4
        mensaje.voice = voice
        speechSynthesizer.speak(mensaje)
    }

}

