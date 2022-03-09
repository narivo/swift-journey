//
//  CardView.swift
//  Challenge10
//
//  Created by MadiApps on 08/03/2022.
//

import UIKit

@IBDesignable
class CardView: UIView {

    @IBOutlet var frontImageView: UIImageView!
    @IBOutlet var backImageView: UIImageView!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var view: UIView!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadViewFromNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
    }
    
    fileprivate func loadViewFromNib() {
        let view = createInitialView()
        let logoImage = createLogoImage(size: bounds.size)
        frontImageView.image = logoImage
        let _ = createRoundedBorders(backImageView, color: UIColor.black)
        addSubview(view)
        self.view = view
    }
    
    fileprivate func createInitialView() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        var view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        view = createFrameFor(view: view, frame: bounds)
        view = createRoundedBorders(view, color: UIColor.black)
        return view
    }
    
    fileprivate func createLogoImage(size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        
        let image = renderer.image { ctx in
            ctx.cgContext.translateBy(x: size.width/2, y: size.height/2)
            
            var first = true
            var length: CGFloat = size.width/2
            
            for _ in 0 ..< Int(size.width/2) {
                ctx.cgContext.rotate(by: .pi / 2)
                
                if first {
                    first = false
                    ctx.cgContext.move(to: CGPoint(x: length, y: 50))
                } else {
                    ctx.cgContext.addLine(to: CGPoint(x: length, y: 50))
                }
                
                length *= 0.99
            }
            
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.strokePath()
        }
        
        return image
    }
    
    fileprivate func createFrameFor(view: UIView, frame: CGRect) -> UIView {
        view.frame = frame
        view.autoresizingMask = [
            .flexibleWidth,
            .flexibleHeight
        ]
        return view
    }
    
    fileprivate func createRoundedBorders(_ view: UIView, color: UIColor) -> UIView {
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1.5
        view.layer.borderColor = color.cgColor
        return view
    }
    
    func flip() {
        backImageView.isHidden = !backImageView.isHidden
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        flip()
    }

}
