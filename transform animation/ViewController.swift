//
//  ViewController.swift
//  transform animation
//
//  Created by Yoshua Elmaryono on 11/07/18.
//  Copyright © 2018 Yoshua Elmaryono. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    var timer: Timer?
    
    @IBAction func screenTapped(_ sender: UITapGestureRecognizer) {
        if timer == nil {
            generateBubbles()
        }else{
            timer!.invalidate()
            timer = nil
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
        var bubbleView: UIView? = UIView(frame: bubbleFrame)
        bubbleView?.layer.cornerRadius = CGFloat(diameter)/2
        bubbleView?.backgroundColor = getRandomColor()
        view.addSubview(bubbleView!)
        
        let randomDuration = arc4random_uniform(10)
        UIView.animate(
            withDuration: TimeInterval(randomDuration),
            delay: 0,
            options: .curveLinear,
            animations: {
                bubbleView?.frame = CGRect(x: Int(x), y: -20, width: diameter, height: diameter)
            },
            completion: { finished in
                bubbleView?.removeFromSuperview()
                bubbleView = nil
            }
        )
    }
}

