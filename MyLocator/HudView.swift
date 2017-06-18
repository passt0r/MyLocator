//
//  HudView.swift
//  MyLocator
//
//  Created by Dmytro Pasinchuk on 18.06.17.
//  Copyright © 2017 Dmytro Pasinchuk. All rights reserved.
//

import UIKit

class HudView: UIView {
    var text = ""
    
    override func draw(_ rect: CGRect) {
        let boxWidth: CGFloat = 96
        let boxHeight: CGFloat = 96
        //MARK: - HudBox setup
        let boxRect = CGRect(x: round((bounds.size.width - boxWidth)/2),
                             y: round((bounds.size.height - boxHeight)/2),
                             width: boxWidth,
                             height: boxHeight)
        let roundedRect = UIBezierPath(roundedRect: boxRect, cornerRadius: 10)
        UIColor(white: 0.3, alpha: 0.8).setFill()
        roundedRect.fill()
        //MARK: - Image in hud setup
        if let image = UIImage(named: "Checkmark") {
            let imagePoint = CGPoint(x: center.x - round(image.size.width/2),
                                     y: center.y - round(image.size.height/2) - boxHeight/8)
            image.draw(at: imagePoint)
        }
        //MARK: - Text in hud setup
        let attribs = [NSFontAttributeName: UIFont.systemFont(ofSize: 16), NSForegroundColorAttributeName: UIColor.white]
        let textSize = text.size(attributes: attribs)
        let textPoint = CGPoint(x: center.x - round(textSize.width/2),
                                y: center.y - round(textSize.height/2) + boxHeight/4)
        text.draw(at: textPoint,withAttributes: attribs)
    }
    
    func show(animated: Bool) {
        if animated {
            alpha = 0
            transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            //Cool animation effect!
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.6, options: [], animations: {
                self.alpha = 1
                self.transform = CGAffineTransform.identity
                
            }, completion: nil)
        }
        
    }
    
    static func hud(inView view: UIView, animated: Bool) -> HudView {
        let hudView = HudView(frame: view.bounds)
        hudView.isOpaque = false
        
        view.addSubview(hudView)
        view.isUserInteractionEnabled = false
        hudView.show(animated: animated)
        
        return hudView
    }
}
