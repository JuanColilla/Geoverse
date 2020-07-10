//
//  ViewController.swift
//  Geoverse
//
//  Created by Renzo Luna Liendo on 27/04/2020.
//  Copyright © 2020 Renzo Luna Liendo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // Managers
    let backgroundAM: BackgroundAudioManager = BackgroundAudioManager()
    let ondemandAM: OnDemandAudioManager = OnDemandAudioManager()
    let voiceSM: VoiceSyntethizerManager = VoiceSyntethizerManager()
    
    
    // IBActions
    @IBAction func playButton(_ sender: UIButton) {
        startPlaying()
    }
    @IBAction func muteButton(_ sender: UIBarButtonItem) {
        if backgroundAM.isPlaying() {
            backgroundAM.pauseAudio()
            muteButton.image = UIImage(systemName: "play.fill")
        } else {
            backgroundAM.playAudio()
            muteButton.image = UIImage(systemName: "pause.fill")
        }
    }
    @IBAction func tapGesture(_ sender: UITapGestureRecognizer) {
        let imageView = sender.view! as! UIImageView
        checkFigureImage(view: imageView)
        
    }
    @IBAction func rotateGesture(_ sender: UIRotationGestureRecognizer) {
        // Aquí mandamos la View (pantalla entera) para que desde la función "animate" cojamos todas las "subviews" (views que contiene).
        animate(animation: "RotateAll", view: view)
    }
    
    @IBAction func swipeDownGesture(_ sender: UISwipeGestureRecognizer) {
        animate(animation: "SwipeDownIcon", view: sender.view!)
    }
    
    
    
    // IBOutlets
    @IBOutlet weak var geoverseIcon: UIImageView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet var imageViews: [UIImageView]!
    @IBOutlet weak var muteButton: UIBarButtonItem!
    @IBOutlet weak var figureLabel: UILabel!
    
    
    // Arrays Imagenes/Nombres
    let imageArray: [UIImage] = [UIImage(named: "CIRCULO")!, UIImage(named: "CUADRADO")!, UIImage(named: "ROMBO")!, UIImage(named: "TRIANGULO")!, UIImage(named: "PENTAGONO")!]
    let figureNames: [String] = ["CIRCULO", "CUADRADO", "ROMBO", "TRIANGULO", "PENTAGONO"]
    
    //---------------------------------------- NATIVAS DEL VIEW CONTROLLER ------------------------------------------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        
        // Bucle para esconder y deshabilitar las imágenes hasta que se pulse "JUGAR"
        for imageView in imageViews {
            imageView.isHidden = true
            imageView.isUserInteractionEnabled = false
        }
        // Escondemos el Label con el nombre de la figura
        figureLabel.isHidden = true
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Preparaciones de reproductores de audio así como seteo de imagenes aleatorias.
        backgroundAM.prepareBackgroundAudio()
    }
    
    //--------------------------------------------------------------------------------------------------------------------------------------------------------
    // ------------------------------------------------------- Custom Funtions ----------------------------------------------------------------------------
    
    // Puro random, aquí el texto y las imagenes se escogen y disponen de forma aleatoria en base a las que existen.
    func setRandomImagesAndText() {
        var tempImageArray = imageArray
        for imageView in imageViews {
            let image = tempImageArray.randomElement()
            imageView.image = image
            let index = tempImageArray.firstIndex(of: image!)
            tempImageArray.remove(at: index!)
        }
        figureLabel.text = figureNames.randomElement()
        voiceSM.speak(textToSpeak: figureLabel.text!)
    }
    
    // Reproducimos el audio de fondo, llamamos a la animación inicial y configuramos las vistas para que el juego pueda empezar.
    func startPlaying() {
        
        backgroundAM.playAudio()
        muteButton.image = UIImage(systemName: "pause.fill")
        
        animate(animation: "PlayButtonPressed", view: playButton)
        animate(animation: "AppIconFadeOut", view: geoverseIcon)
        
        setRandomImagesAndText()
    }
    
    // Sirve para habilitar las viewa anteriormente ocultas sin necesidad de cambiar a otra pantalla.
    func unhideGame() {
        for imageView in imageViews {
            imageView.isHidden = false
            imageView.isUserInteractionEnabled = true
        }
        
        figureLabel.isHidden = false
    }
    
    // Comprobamos que la imagen dentro de la vista que recibimos por parámetro tenga el mismo nombre de figura que el que aparece en la label y reproducimos respuesta.
    func checkFigureImage(view: UIImageView) {
        if view.image == UIImage(named: figureLabel.text!) {
            ondemandAM.playSound(mode: "PASS")
            animate(animation: "CorrectFigureTapped", view: view)
        } else {
            ondemandAM.playSound(mode: "FAIL")
            print(figureLabel.text!)
            animate(animation: "WrongFigureTapped", view: view)
        }
    }
    
    // Función de animación, aquí escogemos qué animación ejecutar según el String que le pasemos, y le pasamos la view a animar por parámetros.
    func animate(animation: String, view: UIView) {
        
        switch(animation){
        case "PlayButtonPressed":
            UIViewPropertyAnimator.runningPropertyAnimator(
                withDuration: 0.75,
                delay: 0,
                options: UIView.AnimationOptions.curveEaseOut,
                animations: {
                    view.transform = CGAffineTransform(scaleX: 2, y: 2)
                    view.alpha = 0.0
            },
                completion: {if $0 == .end{
                    view.removeFromSuperview()
                    self.unhideGame()
                    } }
            )
            break;
        case "AppIconFadeOut":
            UIViewPropertyAnimator.runningPropertyAnimator(
                withDuration: 0.75,
                delay: 0,
                options: UIView.AnimationOptions.curveEaseOut,
                animations: { view.alpha = 0.0 },
                completion: {if $0 == .end{ view.removeFromSuperview() } }
            )
            break;
        case "WrongFigureTapped":
            UIViewPropertyAnimator.runningPropertyAnimator(
                withDuration: 0.25,
                delay: 0,
                options: UIView.AnimationOptions.curveEaseInOut,
                animations: { view.alpha = 0.25},
                completion: {if $0 == .end{ view.alpha = 1 } } )
            break;
        case "CorrectFigureTapped":
            UIViewPropertyAnimator.runningPropertyAnimator(
                withDuration: 0.5,
                delay: 0,
                options: UIView.AnimationOptions.curveLinear,
                animations: {
                    view.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
            }, completion: {if $0 == .end{ UIViewPropertyAnimator.runningPropertyAnimator(
                withDuration: 0.5,
                delay: 0,
                options: UIView.AnimationOptions.curveLinear,
                animations: { view.transform = CGAffineTransform.identity },
                completion:  {if $0 == .end{ self.setRandomImagesAndText() } }
                )
                
                }
                
            }
            )
            break;
        case "RotateAll":
            UIViewPropertyAnimator.runningPropertyAnimator(
                withDuration: 1,
                delay: 0,
                options: UIView.AnimationOptions.curveEaseIn,
                animations: {
                    for view in view.subviews {
                        view.transform = CGAffineTransform(rotationAngle: .pi)
                    }
            },
                completion: {if $0 == .end{
                    for view in view.subviews {
                        view.transform = .identity
                    }
                    } })
            break;
        case "SwipeDownIcon":
            UIViewPropertyAnimator.runningPropertyAnimator(
                withDuration: 0.5,
                delay: 0,
                options: UIView.AnimationOptions.curveEaseOut,
                animations: {
                    view.transform = CGAffineTransform(scaleX: 3, y: 3)
                    view.center.y += 100
                    self.playButton.alpha = 0.0
            },
                completion: {if $0 == .end{UIViewPropertyAnimator.runningPropertyAnimator(
                    withDuration: 0.5,
                    delay: 0,
                    options: UIView.AnimationOptions.curveLinear,
                    animations: {
                        view.transform = CGAffineTransform.identity
                        view.center.y -= 100
                        self.playButton.alpha = 1
                },
                    completion:  nil
                    )} })
            break;
        default:
            break;
        }
    }
    //--------------------------------------------------------------------------------------------------------------------------------------------------------
    
}
