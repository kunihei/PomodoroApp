//
//  ViewController.swift
//  PomodoroApp
//
//  Created by 祥平 on 2021/05/01.
//

import UIKit

class ViewController: UIViewController {
    
    var setTimer = Int()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func settimer(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            setTimer = 15
        case 2:
            setTimer = 30
        case 3:
            setTimer = 60
        default:
            setTimer = 90
        }
        performSegue(withIdentifier: "timer", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "timer"{
            let timerVC = segue.destination as! TimerViewController
        }
    }
    
}

