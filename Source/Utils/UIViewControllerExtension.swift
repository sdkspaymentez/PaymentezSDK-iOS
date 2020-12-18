//
//  UIViewControllerExtension.swift
//  Alamofire
//
//  Created by Fennoma on 09/12/2020.
//

import Foundation

extension UIViewController {
    
    static var loading: Bool = false
    
    static var loadingView: UIVisualEffectView = {
        var containerView = UIVisualEffectView(frame: UIScreen.main.bounds)
        containerView.isHidden = true
        
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        containerView.effect = blurEffect
        
        var indicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.whiteLarge)
        containerView.contentView.addSubview(indicatorView)
        indicatorView.center = CGPoint(x: containerView.frame.width / 2, y: containerView.frame.height / 2)
        indicatorView.startAnimating()
        
        containerView.alpha = 0
        
        return containerView
    }()
    
    func showLoading() {
        if(!UIViewController.loading) {
            UIViewController.loading = true
            view.addSubview(UIViewController.loadingView)
            UIViewController.loadingView.isHidden = false
            UIView.animate(withDuration: 0.5) {
                UIViewController.loadingView.alpha = 1
            }
        }
    }
    
    @objc func dismissPmzLoading() {
        UIViewController.loading = false
        UIView.animate(withDuration: 0.5,
                       animations: {
                        UIViewController.loadingView.alpha = 0
        },
                       completion: { finished in
                        UIViewController.loadingView.isHidden = true
                        UIViewController.loadingView.removeFromSuperview()
                        
        })
    }
    
}
