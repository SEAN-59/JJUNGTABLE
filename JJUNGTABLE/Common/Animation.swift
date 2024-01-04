//
//  Animation.swift
//  JJUNGTABLE
//
//  Created by Sean Kim on 11/21/23.
//

import UIKit

func zoomAndOut(_ view: UIView, duration: Double, x: Double, y: Double, completion: (() -> ())? = nil) {
    UIView.animate(withDuration: duration) {
        view.transform = CGAffineTransform(scaleX: x, y: y)
    } completion: { _ in
        UIView.animate(withDuration: duration) {
            view.transform = CGAffineTransform(scaleX: 1, y: 1)
        }completion: { _ in
            completion?()
        }
    }
}

func shakeView(_ view: UIView, duration: Double, rotation: Double, completion: (() -> ())? = nil) {
    UIView.animate(withDuration: duration) {
        view.transform = CGAffineTransform(rotationAngle: rotation)
//        view.transform = CGAffineTransform(rotationAngle: -1)
    } completion: { _ in
        UIView.animate(withDuration: duration) {
            view.transform = CGAffineTransform(rotationAngle: 0)
        } completion: { _ in
            completion?()
        }
    }
}
