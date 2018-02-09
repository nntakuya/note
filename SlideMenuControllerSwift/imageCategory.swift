//
//  imageCategory.swift
//  SlideMenuControllerSwift
//
//  Created by 仲松拓哉 on 08/02/2018.


import Foundation
import UIKit

class imageCategory:  UIViewController, UIScrollViewDelegate {
    
    func sample(){
        print("sample")
    }
    
    
    //サークルイメージ作成
    func circlePathWithCenter(center: CGPoint, radius: CGFloat) -> UIBezierPath {
        let circlePath = UIBezierPath()
        circlePath.addArc(withCenter: center, radius: radius, startAngle: -CGFloat(Double.pi), endAngle: -CGFloat(Double.pi/2), clockwise: true)
        circlePath.addArc(withCenter: center, radius: radius, startAngle: -CGFloat(Double.pi/2), endAngle: 0, clockwise: true)
        circlePath.addArc(withCenter: center, radius: radius, startAngle: 0, endAngle: CGFloat(Double.pi/2), clockwise: true)
        circlePath.addArc(withCenter: center, radius: radius, startAngle: CGFloat(Double.pi/2), endAngle: CGFloat(Double.pi), clockwise: true)
        circlePath.close()
        return circlePath
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
}
