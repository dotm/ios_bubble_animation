//
//  ViewController.swift
//  bubble animation
//
//  Created by Yoshua Elmaryono on 11/07/18.
//  Copyright © 2018 Yoshua Elmaryono. All rights reserved.
//

import UIKit

enum State {
    case alone, crowds
}

class ViewController: UIViewController {
    //MARK: Properties
    var circleView: UIView!
    var bubbleState: State! {
        didSet {
            switch bubbleState {
            case .alone:
                setToAlone()
            case .crowds:
                setToCrowds()
            case .none:
                break
            case .some(_):
                break
            }
        }
    }
    var timer: Timer?
    
    //Mark: Outlets
    @IBOutlet weak var stateButton: UIButton!
    @IBOutlet weak var coveringRegion: UIView!
    @IBOutlet weak var bubblesViewRegion: UIView!
    
    //MARK: Actions
    @IBAction func onButtonClick(_ sender: UIButton) {
        bubbleState = (bubbleState == .alone) ? .crowds : .alone
    }
    @IBAction func screenTapped(_ sender: UITapGestureRecognizer) {
        if timer == nil {
            generateBubbles()
        }else{
            timer!.invalidate()
            timer = nil
        }
    }
    
    //MARK: Helper functions
    func setToAlone(){
        UIView.animate(withDuration: 2) {
            self.circleView.alpha = 1
            self.coveringRegion.alpha = 0.8
            self.stateButton.setTitle("Alone", for: .normal)
        }
    }
    func setToCrowds(){
        UIView.animate(withDuration: 2) {
            self.circleView.alpha = 0
            self.coveringRegion.alpha = 0
            self.stateButton.setTitle("Crowds", for: .normal)
        }
    }
    func getRandomColor() -> UIColor {
        let red = CGFloat(Float(arc4random()) / Float(UINT32_MAX))
        let green = CGFloat(Float(arc4random()) / Float(UINT32_MAX))
        let blue = CGFloat(Float(arc4random()) / Float(UINT32_MAX))
        
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
    func generateBubbles(){
        timer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(makeOneBubble), userInfo: nil, repeats: true)
    }
    @objc func makeOneBubble(){
        let diameter = 20
        let bottomScreenPosition = view.frame.maxY + CGFloat(diameter)
        let x = arc4random_uniform(UInt32(view.frame.maxX - CGFloat(diameter)))

        let bubbleFrame = CGRect(x: Int(x), y: Int(bottomScreenPosition), width: diameter, height: diameter)
        var bubbleView: UIView! = UIView(frame: bubbleFrame)
        bubbleView.layer.cornerRadius = CGFloat(diameter)/2
        bubbleView.backgroundColor = getRandomColor()
        bubblesViewRegion.addSubview(bubbleView)
        
        let randomDuration = arc4random_uniform(10)
        UIView.animate(
            withDuration: TimeInterval(randomDuration),
            delay: 0,
            options: .curveLinear,
            animations: {
                bubbleView.frame = CGRect(x: Int(x), y: -20, width: diameter, height: diameter)
            },
            completion: { finished in
                bubbleView.removeFromSuperview()
                bubbleView = nil
            }
        )
    }
    
    //MARK: Lifecycle Hooks
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //setup circleView
        let circleDiameter = 100
        let centerX = (Int(view.frame.maxX) - circleDiameter)/2
        let circleFrame = CGRect(x: centerX, y: 283, width: circleDiameter, height: circleDiameter)
        circleView = UIView(frame: circleFrame)
        circleView.backgroundColor = UIColor.red
        circleView.layer.cornerRadius = CGFloat(circleDiameter/2)
        view.addSubview(circleView)
        
        bubbleState = .crowds
        setToCrowds()
    }
}

