//
//  ViewController.swift
//  CreditScore
//
//  Created by Nur Ismail on 2020/03/03.
//  Copyright © 2020 NMI. All rights reserved.
//

import UIKit

extension UIViewController {
    //Make it an alert message extension so that it's available to all our ViewControllers
    func alert(message: String, title: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
class DashboardViewController: UIViewController {
    
    @IBOutlet weak var creditScoreView: UIView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    @IBOutlet weak var lblScoreHeading: UILabel!
    @IBOutlet weak var lblScore: AnimatedLabel!
    @IBOutlet weak var lblMaxScore: UILabel!
    
    //Various layers for drawing the Credit Score Gauge
    private let outerLayer = CAShapeLayer()
    private let scoreTrackLayer = CAShapeLayer()
    private let scoreShapeLayer = CAShapeLayer()
    private let scoreGradientLayer = CAGradientLayer()
    
    //View model
    private let creditDataViewModel = CreditDataViewModel()
    
    //Error messages
    //TODO Possibly define in a separate localization file, to make localization easier
    private let unableToRetrieveDataErrorMsg = "Unable to retrieve Credit Data. Please check that you are connected to the internet."
    

    override func viewDidLoad() {
        super.viewDidLoad()

        view.accessibilityIdentifier = "dashboardView"

        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))

        self.drawInitGauge(view: self.view)
        
        self.loadCreditDataAndDisplay()
    }
    
    @objc private func handleTap() {
        print("Tap")
        
        //self.animateGauge()   //Call this instead of line below if we just want to animate previous data, instead of reloading data from api call
        self.loadCreditDataAndDisplay()
    }

    private func loadCreditDataAndDisplay() {
        self.resetLabels(initAll: true)

        activityIndicatorView.startAnimating()
        
        creditDataViewModel.getCreditData() { success in
            DispatchQueue.main.async {
                self.activityIndicatorView.stopAnimating()
                
                if (success) {
                    self.updateGauge(view: self.view, score: self.creditDataViewModel.score /*327*/, maxScore: self.creditDataViewModel.maxScoreValue /*700*/)
                    self.animateGauge()
                } else {
                    self.alert(message: self.unableToRetrieveDataErrorMsg, title: "Error")
                    
                    self.lblScoreHeading.text = ""  //We don't want the score heading to be visible on retry
                    self.lblScore.text = "RETRY"    //User can tap the screen to retry
                }
            }
        }
    }
    
    //Usually called before retrieving initial Credit Data
    private func resetLabels(initAll: Bool = false) {
        if initAll {    //Only need to set this once
            self.lblScoreHeading.text = self.creditDataViewModel.creditScoreHeadingLabelText
        }

        self.lblScore.text = ""
        self.lblMaxScore.text = ""
    }

    private func updateLabels(showBlankScore: Bool = false) {
        self.lblScore.text = showBlankScore ? "" : creditDataViewModel.creditScoreText
        self.lblMaxScore.text = creditDataViewModel.creditScoreOutOfLabelText
    }

    //Draw the initial gauge without the score displayed
    private func drawInitGauge(view: UIView) {
        let center = view.center
        
        let radius: CGFloat = min(125.0, view.frame.size.width / 2.0)
        let startAngle: CGFloat = -0.5 * CGFloat.pi  //-90 degrees (12 'o clock position)
        let endAngle: CGFloat = startAngle + 2.0 * CGFloat.pi    //270 degrees (12 'o clock position right around). However since our start angle is at -90 degees, so this is 360 degrees from the starting point.
        let lineWidth: CGFloat = 4
        
        let circularOuterPath = UIBezierPath(arcCenter: center, radius: radius + 10.0, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        //Just an initial empty path with same start and end angle
        let circularZeroInnerPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: startAngle, clockwise: true)

        //Outer circular region
        outerLayer.path = circularOuterPath.cgPath
        
        outerLayer.strokeColor = UIColor.black.cgColor
        outerLayer.lineWidth = 2
        outerLayer.fillColor = UIColor.clear.cgColor
        outerLayer.lineCap = CAShapeLayerLineCap.round
        view.layer.addSublayer(outerLayer)
        
        //Inner grayed out "score" background track arc
        scoreTrackLayer.path = circularZeroInnerPath.cgPath

        scoreTrackLayer.strokeColor = UIColor.lightGray.cgColor
        scoreTrackLayer.lineWidth = lineWidth
        scoreTrackLayer.fillColor = UIColor.clear.cgColor
        scoreTrackLayer.lineCap = CAShapeLayerLineCap.round
        view.layer.addSublayer(scoreTrackLayer)
        
        //Inner active "score" region arc
        scoreShapeLayer.path = circularZeroInnerPath.cgPath

        scoreShapeLayer.strokeColor = UIColor.red.cgColor
        scoreShapeLayer.lineWidth = lineWidth
        scoreShapeLayer.fillColor = UIColor.clear.cgColor
        scoreShapeLayer.lineCap = CAShapeLayerLineCap.round
        
        scoreShapeLayer.strokeEnd = 0
        
        //Inner gradient for "score" region arc
        scoreGradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
        scoreGradientLayer.endPoint = CGPoint(x: 0.0, y: 0.5)
        
        //TODO Need to determine all the gradient colors needed to display 0-100% of score (i.e. score / maxScoreValue)
//        gradientLayer.colors = [UIColor.red.cgColor, UIColor.orange.cgColor, UIColor.yellow.cgColor, UIColor.green.cgColor]
        scoreGradientLayer.colors = [UIColor.orange.cgColor, UIColor.yellow.cgColor]
        scoreGradientLayer.frame = view.frame
        scoreGradientLayer.mask = scoreShapeLayer
        
//        view.layer.addSublayer(scoreShapeLayer)
        view.layer.addSublayer(scoreGradientLayer)
    }
    
    private func updateGauge(view: UIView, score: Int, maxScore: Int) {
        self.updateLabels(showBlankScore: true)
        
        let center = view.center
        
        let radius: CGFloat = min(125.0, view.frame.size.width / 2.0)
        let startAngle: CGFloat = -0.5 * CGFloat.pi  //-90 degrees (12 'o clock position)
        let endAngle: CGFloat = startAngle + 2.0 * CGFloat.pi * CGFloat(score) / CGFloat(maxScore)   //Up to 270 degrees (12 'o clock position right around). However since our start angle is at -90 degees, so this is 360 degrees from the starting point.
        
        let circularInnerPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        scoreTrackLayer.path = circularInnerPath.cgPath
        scoreShapeLayer.path = circularInnerPath.cgPath
    }
    
    private func animateGauge() {
        //We set score to blank here, since our animation below will update it incrementally
        self.updateLabels(showBlankScore: true)

        //animate
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        
        basicAnimation.toValue = 1
        basicAnimation.duration = 1 //seconds
        
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = false
        
        scoreShapeLayer.add(basicAnimation, forKey: "basicAnim")
        
        //self.incrementLabel(to: self.score)   //Alternate way to visually increment our score label
        self.lblScore.countingMethod = .easeOut
        self.lblScore.countFromZero(to: Float(self.creditDataViewModel.score), duration: .superBrisk)
    }
    
    //Alternate way to visually increment our score label, and is more light-weight, but our third-party class has some additional features
    //Not actively used at the moment, but kept here for reference!
    private func incrementLabel(to endValue: Int) {
        let duration: Double = 1.2 //seconds
        DispatchQueue.global().async {
            for i in 0 ..< (endValue + 1) {
                let sleepTime = UInt32(duration / Double(endValue) * 1000000.0)
                usleep(sleepTime)
                DispatchQueue.main.async {
                    self.lblScore.text = "\(i)"
                }
            }
        }
    }
}
