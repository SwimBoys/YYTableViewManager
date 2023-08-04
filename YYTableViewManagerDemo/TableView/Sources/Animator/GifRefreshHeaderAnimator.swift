//
//  GifRefreshHeaderAnimator.swift
//  testDemo
//
//  Created by youyongpeng on 2023/4/13.
//

import UIKit

public class GifRefreshHeaderAnimator: UIView, ESRefreshProtocol, ESRefreshAnimatorProtocol {
    
    public var insets: UIEdgeInsets = UIEdgeInsets.zero
    public var view: UIView { return self }
    public var trigger: CGFloat = 70.0
    public var executeIncremental: CGFloat = 56.0
    public var state: ESRefreshViewState = .pullToRefresh
    
    var gifBeginImageNameArr: [String] = []
    
    var gifStartImageNameArr: [String] = []
    
    private let imageView: UIImageView = {
        let imageView = UIImageView.init()
        return imageView
    }()
    
    init(frame: CGRect, gifBeginImageNameArr: [String], gifStartImageNameArr: [String]) {
        super.init(frame: frame)
        self.gifBeginImageNameArr = gifBeginImageNameArr
        self.gifStartImageNameArr = gifStartImageNameArr
        imageView.image = UIImage.init(named: gifBeginImageNameArr.first ?? "")
        self.addSubview(imageView)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func refreshAnimationBegin(view: ESRefreshComponent) {
        imageView.center = self.center
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveLinear, animations: {
            self.imageView.frame = CGRect.init(x: (self.bounds.size.width - 39.0) / 2.0,
                                               y: self.bounds.size.height - 50.0,
                                           width: 39.0,
                                          height: 50.0)


            }, completion: { (finished) in
                var images = [UIImage]()
                for string in self.gifStartImageNameArr {
                    if let aImage = UIImage(named: string) {
                        images.append(aImage)
                    }
                }
                self.imageView.animationDuration = 0.5
                self.imageView.animationRepeatCount = 0
                self.imageView.animationImages = images
                self.imageView.startAnimating()
        })
    }
    
    public func refreshAnimationEnd(view: ESRefreshComponent) {
        imageView.stopAnimating()
        imageView.image = UIImage.init(named: gifBeginImageNameArr.first ?? "")
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveLinear, animations: {
            self.refresh(view: view, progressDidChange: 0.0)
        }, completion: { (finished) in
        })
    }
    
    public func refresh(view: ESRefreshComponent, progressDidChange progress: CGFloat) {
        let p = max(0.0, min(1.0, progress))
        imageView.frame = CGRect.init(x: (self.bounds.size.width - 39.0) / 2.0,
                                      y: self.bounds.size.height - 50.0 * p,
                                      width: 39.0,
                                      height: 50.0 * p)
    }
    
    public func refresh(view: ESRefreshComponent, stateDidChange state: ESRefreshViewState) {
        guard self.state != state else {
            return
        }
        self.state = state
        
        switch state {
        case .pullToRefresh:
            var images = [UIImage]()
            for string in self.gifBeginImageNameArr.reversed() {
                if let aImage = UIImage(named: string) {
                    images.append(aImage)
                }
            }
            imageView.animationDuration = 0.2
            imageView.animationRepeatCount = 1
            imageView.animationImages = images
            imageView.image = UIImage.init(named: gifBeginImageNameArr.first ?? "")
            imageView.startAnimating()
            break
        case .releaseToRefresh:
            var images = [UIImage]()
            for string in self.gifBeginImageNameArr {
                if let aImage = UIImage(named: string) {
                    images.append(aImage)
                }
            }
            imageView.animationDuration = 0.2
            imageView.animationRepeatCount = 1
            imageView.animationImages = images
            imageView.image = UIImage.init(named: gifBeginImageNameArr.last ?? "")
            imageView.startAnimating()
            break
        default:
            break
        }
    }
    
    
    

    

}
