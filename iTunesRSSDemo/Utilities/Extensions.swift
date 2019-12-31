//
//  Extensions.swift
//  iTunesRSSDemo
//
//  Created by Manikanta Nallabelly on 12/29/19.
//  Copyright © 2019 STANZA. All rights reserved.
//

import Foundation
import UIKit

extension DateFormatter {
    static let yyyyMMdd: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
}

extension Date {
    func readableDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        return formatter.string(from: self)
    }
}

extension UIViewController {
    func showAlert(title:String = "Exception", message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension UIView {
    
    func anchor (top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?,  paddingTop: CGFloat, paddingLeft: CGFloat, paddingBottom: CGFloat, paddingRight: CGFloat, width: CGFloat, height: CGFloat, enableInsets: Bool) {
        var topInset = CGFloat(0)
        var bottomInset = CGFloat(0)
        
        if enableInsets {
            let insets = self.safeAreaInsets
            topInset = insets.top
            bottomInset = insets.bottom
        }
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: paddingTop+topInset).isActive = true
        }
        if let left = left {
            self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom-bottomInset).isActive = true
        }
        if height != 0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        if width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
    }
}


extension UIView {
    
    static let activityIndicatorTag = 1000
    
    func showActivityIndicator() {
        let container: UIView = UIView()
        container.tag = UIView.activityIndicatorTag
        container.frame = self.frame
        container.center = self.center
        container.backgroundColor = UIColor.white

        let loadingView: UIView = UIView()
        loadingView.frame = CGRect(origin: .zero, size: CGSize(width: 80, height: 80))
        loadingView.center = self.center
        loadingView.backgroundColor = .gray
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10

        let actInd: UIActivityIndicatorView = UIActivityIndicatorView()
        actInd.frame = CGRect(origin: .zero, size: CGSize(width: 40, height: 40))
        actInd.style = UIActivityIndicatorView.Style.large
        actInd.center = CGPoint(x: loadingView.frame.size.width / 2,y :loadingView.frame.size.height / 2)
        loadingView.addSubview(actInd)
        container.addSubview(loadingView)
        self.addSubview(container)
        actInd.startAnimating()
    }
    
    func hideActivityIndicator() {
        self.viewWithTag(UIView.activityIndicatorTag)?.removeFromSuperview()
    }
}

@propertyWrapper
public struct UsesAutoLayout<T: UIView> {
    public var wrappedValue: T {
        didSet {
            wrappedValue.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    public init(wrappedValue: T) {
        self.wrappedValue = wrappedValue
        wrappedValue.translatesAutoresizingMaskIntoConstraints = false
    }
}
