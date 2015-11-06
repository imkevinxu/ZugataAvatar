//
//  ZAAvatarView.swift
//  ZugataAvatar
//
//  Created by Kevin Xu on 11/5/15.
//  Copyright © 2015 Kevin Xu. All rights reserved.
//

import UIKit
import SnapKit

// MARK: - Properties

final class ZAAvatarView: UIView {

    var numberOfSides: Int!
    var borderWidth: CGFloat!
    var borderColor: UIColor!

    var borderView: UIView?
    var pictureView: UIView?

    // MARK: Initializers

    init(numberOfSides: Int, borderWidth: CGFloat, borderColor: UIColor) {
        super.init(frame: CGRectZero)
        self.numberOfSides = numberOfSides
        self.borderWidth = borderWidth
        self.borderColor = borderColor
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: Layout Methods

    override func layoutSubviews() {
        super.layoutSubviews()

        if borderView == nil {
            borderView = UIView(frame: bounds)
            addSubview(borderView!)
        }
        borderView!.backgroundColor = borderColor
        borderView!.layer.mask = shapeLayerForRect(bounds, withNumberOfSides: numberOfSides)

        if pictureView == nil {
            pictureView = UIImageView(image: UIImage(named: "profile"))
            addSubview(pictureView!)
        }
        pictureView!.frame = CGRectMake(borderWidth, borderWidth, frame.size.width - borderWidth * 2, frame.size.height - borderWidth * 2)
        pictureView!.layer.mask = shapeLayerForRect(pictureView!.bounds, withNumberOfSides: numberOfSides)
    }
}

// MARK: Public Methods

extension ZAAvatarView {

    func updateBorderColor(color: UIColor) {
        borderColor = color
        setNeedsLayout()
    }

    func updateBorderWidth(width: CGFloat) {
        borderWidth = width
        setNeedsLayout()
    }

    func updateNumberOfSides(sides: Int) {
        numberOfSides = sides
        setNeedsLayout()
    }
}

// MARK: - Helper Methods

extension ZAAvatarView {

    private func shapeLayerForRect(rect: CGRect, withNumberOfSides numberOfSides: Int) -> CAShapeLayer {
        if numberOfSides < 3 {
            assertionFailure("Polygon needs at least 3 sides or greater")
        }

        let bezierPath = UIBezierPath()
        let centerX = CGRectGetMidX(rect)
        let centerY = CGRectGetMidY(rect)
        let xRadius = CGRectGetWidth(rect) / 2
        let yRadius = CGRectGetHeight(rect) / 2

        bezierPath.moveToPoint(CGPointMake(centerX + xRadius, centerY))
        for i in 1...numberOfSides {
            let theta = Float(2) * Float(M_PI) / Float(numberOfSides) * Float(i)
            let xPosition = CGFloat(centerX) + CGFloat(xRadius) * CGFloat(cosf(theta))
            let yPosition = CGFloat(centerY) + CGFloat(yRadius) * CGFloat(sinf(theta))
            bezierPath.addLineToPoint(CGPointMake(xPosition, yPosition))
        }
        bezierPath.closePath()

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = bezierPath.CGPath
        return shapeLayer
    }
}