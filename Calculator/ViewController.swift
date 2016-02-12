//
//  ViewController.swift
//  Calculator
//
//  Created by Waleed Amer on 2/3/16.
//  Copyright © 2016 Amer Software. All rights reserved.
//

import UIKit
import pop

public extension UIImage {
    convenience init(color: UIColor, size: CGSize = CGSizeMake(1, 1)) {
        let rect = CGRectMake(0, 0, size.width, size.height)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(CGImage: image.CGImage!)
    }  
}

class ViewController: UIViewController {

    var backgroundImageView: UIImageView?
    var gradientLayer: CAGradientLayer!
    var calculator: Calculator!
    
    @IBOutlet weak var AnswerView: UIView!
    @IBOutlet weak var RowsStackView: UIStackView!
    @IBOutlet weak var answerLabel: UILabel!
    
    var pendingOperator: UIButton? = nil
    
    override func viewWillAppear(animated: Bool) {
        // Make the background pretty
        gradientLayer = makeGradientLayer((250, 109, 105), rgb2: (241, 41, 124))
        self.view.layer.addSublayer(gradientLayer)
        
        AnswerView.hidden = true
        AnswerView.alpha = 0
        RowsStackView.alpha = 0
        
        // Set up UIButton highlights
        for row in RowsStackView.arrangedSubviews {
            if let buttons = row as? UIStackView {
                for view in buttons.arrangedSubviews {
                    if let button = view as? UIButton {
                        let whiteImage = UIImage(color: UIColor.whiteColor(), size: button.frame.size)
                        button.setBackgroundImage(whiteImage, forState: UIControlState.Highlighted)
                        button.setBackgroundImage(whiteImage, forState: UIControlState.Selected)
                        button.layer.cornerRadius = 20
                        button.clipsToBounds = true
                    }
                }
            }
        }
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
        calculator.viewController = self
    }
    
    override func viewDidAppear(animated: Bool) {
        UIView.animateWithDuration(0.5, delay: 0.4, options: [.CurveEaseInOut], animations: { () -> Void in
            self.AnswerView.hidden = false
            
            self.RowsStackView.alpha = 1
            }, completion: nil)
        
        UIView.animateWithDuration(0.5, delay: 0.8, options: [.CurveEaseOut], animations: { () -> Void in
            self.AnswerView.alpha = 1
            }, completion: nil)
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
                        shake(AnswerView, duration: 0.05, intensity: 3, count: 1)
                    }
                }
            }
        }
    }
    
    @IBAction func operationWasTapped(sender: UIButton) {
        // Unwrap the button's label to get the operator
        if let label = sender.titleLabel {
            if let text = label.text {
                let Operator = Character.init(text)
                
                let result = calculator.handleInput(InputType: .Operator, input: Operator)
                answerLabel.text = result.output
                if (result.error) {
                    shake(AnswerView, duration: 0.05, intensity: 3, count: 1)
                }
                else {
                    pendingOperator = sender
                    scaleUp(sender)
                }
            }
        }
    }
    
    @IBAction func equalWasTapped(sender: UIButton) {
        let result = calculator.handleInput(InputType: .Equal)
        answerLabel.text = result.output
        if (result.error) {
            shake(AnswerView, duration: 0.05, intensity: 3, count: 1)
        }
        else {
            if let button = pendingOperator {
                scaleDown(button)
                pendingOperator = nil
            }
            //shakeVertical(AnswerView, duration: 0.1, intensity: 3, count: 1)
        }
    }
    
    @IBAction func pointWasTapped(sender: AnyObject) {
        let result = calculator.handleInput(InputType: .Point)
        answerLabel.text = result.output
        if (result.error) {
            shake(AnswerView, duration: 0.05, intensity: 3, count: 1)
        }
    }
    
    @IBAction func clearWasTapped(sender: AnyObject) {
        let result = calculator.handleInput(InputType: .Clear)
        //let result = (output: "yo", error: false)
        answerLabel.text = result.output
        if (result.error) {
            shake(AnswerView, duration: 0.05, intensity: 3, count: 1)
        }
        if let button = pendingOperator {
            scaleDown(button)
            pendingOperator = nil
        }
    }

    @IBAction func answerWasTapped(sender: AnyObject) {
        let result = calculator.handleInput(InputType: .Answer)
        answerLabel.text = result.output
        if (result.error) {
            shake(AnswerView, duration: 0.05, intensity: 3, count: 1)
        }
    }
    
    @IBAction func deleteWasTapped(sender: AnyObject) {
        let result = calculator.handleInput(InputType: .Delete)
        answerLabel.text = result.output
        if (result.error == true) {
            shake(AnswerView, duration: 0.05, intensity: 3, count: 1)
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
    
    // MARK:- Animations
    func scaleUp(sender: UIView) {
        let scaleUpAnimation = POPSpringAnimation(propertyNamed: kPOPViewScaleXY)
        scaleUpAnimation.velocity = NSValue(CGPoint: CGPointMake(12, 12))
        scaleUpAnimation.springBounciness = 12
        scaleUpAnimation.springSpeed = 20
        scaleUpAnimation.toValue = NSValue(CGPoint: CGPointMake(1.5, 1.5))
        sender.pop_addAnimation(scaleUpAnimation, forKey: "scale")
    }
    
    func scaleDown(sender: UIView) {
        let scaleDownAnimation = POPSpringAnimation(propertyNamed: kPOPViewScaleXY)
        scaleDownAnimation.velocity = NSValue(CGPoint: CGPointMake(12, 12))
        scaleDownAnimation.springBounciness = 12
        scaleDownAnimation.springSpeed = 20
        scaleDownAnimation.toValue = NSValue(CGPoint: CGPointMake(1, 1))
        sender.pop_addAnimation(scaleDownAnimation, forKey: "scale")
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
                            self.shake(view, duration: duration, intensity: intensity, count: count-1)
                        }
                    }
                )
            }
        )
    }
}




