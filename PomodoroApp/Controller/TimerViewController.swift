//
//  TimerViewController.swift
//  PomodoroApp
//
//  Created by 祥平 on 2021/05/01.
//

import UIKit
import AudioToolbox

private var vibrationCount = 4
private var soundIdString:SystemSoundID = 1304

class TimerViewController: UIViewController {

    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var intervalLabel: UILabel!
    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var stopBtn: UIButton!
    
    var setTimer = Int()
    private var interval = Int()
    private var secTimer:Int = 0
    private var intervalsec:Int = 0
    private var timer = Timer()
    
    private let systemSoundID = SystemSoundID(kSystemSoundID_Vibrate)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startBtn.layer.cornerRadius = 55
        stopBtn.layer.cornerRadius = 55
        stopBtn.isEnabled = false
        
        switch setTimer {
        case 15:
            interval = 5
        case 30:
            interval = 5
        case 60:
            interval = 10
        default:
            interval = 15
        }
        UserDefaults.standard.setValue(setTimer, forKey: "setTimer")
        UserDefaults.standard.setValue(interval, forKey: "interval")
        timerLabel.text = "\(setTimer)分\(secTimer)秒"
        intervalLabel.text = "\(interval)分\(intervalsec)秒"
        // Do any additional setup after loading the view.
    }
    
    @IBAction func startButton(_ sender: Any) {
        stopBtn.isEnabled = true
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countDown), userInfo: nil, repeats: true)
    }
    
    //残り時間のカウントダウンメソッド
    @objc func countDown(){
        //残り時間のカウントダウン
        if (secTimer == 0){
            setTimer -= 1
            secTimer = 59
        }else{
            secTimer -= 1
        }
        
        //カウントダウンが0になった時に休憩時間のカウントダウン開始する条件分岐
        if (setTimer == 0 && secTimer == 0){
            timerLabel.text = "休憩して下さい！"
            timer.invalidate()
            
            AudioServicesPlayAlertSound(systemSoundID)
            
            vibrationCount = 4
            
            AudioServicesAddSystemSoundCompletion(systemSoundID, nil, nil, { (systemSoundID, nil) -> Void in
                vibrationCount -= 1
                
                if ( vibrationCount > 0 ) {
                    // 繰り返し再生
                    AudioServicesPlaySystemSound(systemSoundID)
                }
            }, nil)
            if let soundUrl = CFBundleCopyResourceURL(CFBundleGetMainBundle(), nil, nil, nil){
                AudioServicesCreateSystemSoundID(soundUrl, &soundIdString)
                AudioServicesPlaySystemSound(soundIdString)
            }
            interval = UserDefaults.standard.object(forKey: "interval") as! Int
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(intervalDown), userInfo: nil, repeats: true)
        }else{
            timerLabel.text = "\(setTimer)分\(secTimer)秒"
        }
    }
    
    //休憩時間のカウントダウンメソッド
    @objc func intervalDown(){
        //休憩時間のカウントダウン
        if(intervalsec == 0){
            interval -= 1
            intervalsec = 59
        }else{
            intervalsec -= 1
        }
        
        //休憩時間が0になったら残り時間のカウントダウンが再度される条件分岐
        if(interval == 0 && intervalsec == 0){
            intervalLabel.text = "作業を再開して下さい！"
            timer.invalidate()
            AudioServicesPlayAlertSound(systemSoundID)
            if let soundUrl = CFBundleCopyResourceURL(CFBundleGetMainBundle(), nil, nil, nil){
                AudioServicesCreateSystemSoundID(soundUrl, &soundIdString)
                AudioServicesPlaySystemSound(soundIdString)
            }
            setTimer = UserDefaults.standard.object(forKey: "setTimer") as! Int
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countDown), userInfo: nil, repeats: true)
        }else{
            intervalLabel.text = "\(interval)分\(intervalsec)秒"
        }
    }
    
    @IBAction func stopButton(_ sender: Any) {
        timer.invalidate()
    }
    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
