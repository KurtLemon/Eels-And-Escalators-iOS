//
//  IntroGameViewController.swift
//  EelsAndEscalators
//
//  Created by Norman, Claire Noel on 11/18/18.
//  Copyright © 2018 Lamon, Kurt David. All rights reserved.
//

import UIKit

class IntroGameViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var playerNameTextField: UITextField!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var titleView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "welcomeBackground.png")!)
        self.navigationController?.isNavigationBarHidden = true
        playerNameTextField.delegate = self
        assignBackground()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func assignBackground() {
        let background = UIImage(named: "welcomeBackground.png")
        
        var imageView: UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.center = view.center
        view.addSubview(imageView)
        self.view.sendSubviewToBack(imageView)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "startGameSegue" {
                if let gameVC = segue.destination as? GameViewController {
                    print("starting the game")
                    if let playerName = playerNameTextField.text {
                        print("Player name saved: \(playerNameTextField.text!)")
                    }
                }
            }
        }
    }
    
    @IBAction func startButtonPressed(_ sender: UIButton!) {
        print("Button pressed")
        if playerNameTextField.text != "" {
           performSegue(withIdentifier: "startGameSegue", sender: self)
        } else {
            let nameAlert = UIAlertController(title: "No Name Entered", message: "Please enter a player name!", preferredStyle: .alert)
            
            let okayAction = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
            nameAlert.addAction(okayAction)
            present(nameAlert, animated: true, completion: nil)
        }
        
    }
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
