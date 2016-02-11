//
//  ViewController.swift
//  Calculator
//
//  Created by Waleed Amer on 2/3/16.
//  Copyright © 2016 Amer Software. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var backgroundImageView: UIImageView?
    var gradientLayer: CAGradientLayer!
    var calculator: Calculator!
    
    @IBOutlet weak var AnswerView: UIView!
    @IBOutlet weak var RowsStackView: UIStackView!
    @IBOutlet weak var answerLabel: UILabel!
    
    override func viewWillAppear(animated: Bool) {
        // Make the background pretty
        gradientLayer = makeGradientLayer((250, 109, 105), rgb2: (241, 41, 124))
        self.view.layer.addSublayer(gradientLayer)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Make the AnswerView pretty
        AnswerView.layer.cornerRadius = 4
        AnswerView.layer.shadowColor = UIColor.blackColor().CGColor
        AnswerView.layer.shadowOffset = CGSizeMake(0, 8)
        AnswerView.layer.shadowRadius = 6
        AnswerView.layer.shadowOpacity = 0.25
        
        calculator = Calculator()
    }
    
    // MARK:- Handle Input Types
    @IBAction func digitWasTapped(sender: UIButton) {
        // Unwrap the button's label to get the digit
        if let label = sender.titleLabel {
            if let text = label.text {
                if let digit: Character = Character.init(text) {
                    let result = calculator.handleInput(InputType: .Digit, input: digit)
                    answerLabel.text = result.output
                    if (result.error) {
                        shake(AnswerView, duration: 0.05, intensity: 5, count: 2)
                    }
                }
            }
        }
    }
    
    @IBAction func operationWasTapped(sender: UIButton) {
        // Unwrap the button's label to get the operator
        if let label = sender.titleLabel {
            if let text = label.text {
                let op = Character.init(text)
                let result = calculator.handleInput(InputType: .Operator, input: op)
                answerLabel.text = result.output
                if (result.error) {
                    shake(AnswerView, duration: 0.05, intensity: 5, count: 2)
                }
            }
        }
    }
    
    @IBAction func equalWasTapped(sender: UIButton) {
        let result = calculator.handleInput(InputType: .Equal)
        answerLabel.text = result.output
        if (result.error) {
            shake(AnswerView, duration: 0.05, intensity: 5, count: 2)
        }
        else {
            shakeVertical(answerLabel, duration: 0.1, intensity: 3, count: 1)
        }
    }
    
    @IBAction func pointWasTapped(sender: AnyObject) {
        let result = calculator.handleInput(InputType: .Point)
        answerLabel.text = result.output
        if (result.error) {
            shake(AnswerView, duration: 0.05, intensity: 5, count: 2)
        }
    }
    
    @IBAction func clearWasTapped(sender: AnyObject) {
        let result = calculator.handleInput(InputType: .Clear)
        answerLabel.text = result.output
        if (result.error) {
            shake(AnswerView, duration: 0.05, intensity: 5, count: 2)
        }
    }

    @IBAction func answerWasTapped(sender: AnyObject) {
        let result = calculator.handleInput(InputType: .Answer)
        answerLabel.text = result.output
        if (result.error) {
            shake(AnswerView, duration: 0.05, intensity: 5, count: 2)
        }
    }
    
    @IBAction func deleteWasTapped(sender: AnyObject) {
        let result = calculator.handleInput(InputType: .Delete)
        answerLabel.text = result.output
        if (result.error == true) {
            shake(AnswerView, duration: 0.05, intensity: 5, count: 2)
        }
    }
    
    
    // MARK:- Misc
    // Returns a Gradient Layer
    func makeGradientLayer(rgb: (r: CGFloat, g: CGFloat, b: CGFloat), rgb2: (r: CGFloat, g: CGFloat, b: CGFloat)) -> CAGradientLayer {
        let layer = CAGradientLayer()
        layer.frame = self.view.bounds
        
        let color1 = UIColor(red: rgb.r/255, green: rgb.g/255, blue: rgb.b/255, alpha: 1).CGColor as CGColorRef
        let color2 = UIColor(red: rgb2.r/255, green: rgb2.g/255, blue: rgb2.b/255, alpha: 1).CGColor as CGColorRef
        
        layer.colors = [color1, color2]
        layer.locations = [0.0, 1.0]
        layer.zPosition = -5
        
        return layer
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// Shake a view vertically
func shakeVertical(view: UIView, duration: NSTimeInterval, intensity: CGFloat, count: Int) {
    UIView.animateWithDuration(
        duration,
        animations: {
            view.frame.origin.y = intensity
        },
        completion: { finish in
            UIView.animateWithDuration(
                duration,
                animations: {
                    view.frame.origin.y = 0
                })
    })
}

// Shake a view side to side
func shake(view: UIView, duration: NSTimeInterval, intensity: CGFloat, count: Int) {
    UIView.animateWithDuration(
        duration,
        animations: {
            view.frame.origin.x = -intensity
        },
        completion: { finish in
            UIView.animateWithDuration(
                duration,
                animations: {
                    view.frame.origin.x = intensity
                },
                completion: { finish in
                    if (count == 0) {
                        UIView.animateWithDuration(
                            duration,
                            animations: {
                                view.frame.origin.x = 0
                            }
                        )
                    } else {
                        shake(view, duration: duration, intensity: intensity, count: count-1)
                    }
                }
            )
        }
    )
}


