import UIKit
import XCPlayground

/*:
 **IMPORTANT:** To view the animation, go ***View->Assistant Editor->Show Assistant Editor***.
 # Custom animation curves
 This is an example of how you can create custom animation curves using Core Animation. For context, see [this post on Medium](https://medium.com/p/edde651b6a7a). To adjust the animation curve, **change the control points below**.
  */
func configure() {
    configurePlayground(withControlPoints: 0.25, 0.2, 0.66, 1.5, andDuration: 2.0)
}
//: You can set the y-coordinates outside the range 0.0 - 1.0. Just reassure it makes sense for the property you are animating. A scale transform can't be less than 0.0 for example. ...but it can be above 1.0.
func configurePlayground(withControlPoints c1x: CGFloat, _ c1y: CGFloat, _ c2x: CGFloat, _ c2y: CGFloat, andDuration duration: CFTimeInterval) {
    
    // Want to animate something else? Then swap the key path to your preference.
    let keyPathToAnimate = "transform.scale"
    
    let controlPoints = [CGPoint(x: c1x, y: c1y), CGPoint(x: c2x, y: c2y)]
    let bounds = CGRect(x: 0, y: 0, width: 375, height: 667)
    
    let containerView = UIView(frame: bounds)
    containerView.backgroundColor = .whiteColor()
    XCPlaygroundPage.currentPage.liveView = containerView
    
    class CurveView : UIView {
        
        var controlPoints: [CGPoint] = []
        
        convenience init(controlPoints: [CGPoint]) {
            self.init()
            self.controlPoints = controlPoints
        }
        
        override func drawRect(rect: CGRect) {
            let context = UIGraphicsGetCurrentContext()
            let frame = bounds.insetBy(dx: bounds.midX / 2, dy: bounds.midY / 2)
            
            CGContextAddRect(context, frame)
            CGContextSetStrokeColorWithColor(context, [#Color(colorLiteralRed: 0.2078431372549019, green: 0.2274509803921569, blue: 0.2509803921568627, alpha: 0.5)#].CGColor)
            CGContextStrokePath(context)
            
            CGContextMoveToPoint(context, frame.minX, frame.maxY)
            CGContextAddCurveToPoint(context, frame.minX + controlPoints[0].x * frame.width, frame.maxY - controlPoints[0].y * frame.height, frame.minX + controlPoints[1].x * frame.width, frame.maxY - controlPoints[1].y * frame.height, frame.maxX, frame.minY)
            
            CGContextSetStrokeColorWithColor(context, [#Color(colorLiteralRed: 0.2078431372549019, green: 0.2274509803921569, blue: 0.2509803921568627, alpha: 1)#].CGColor)
            CGContextStrokePath(context)
        }
    }
    
    func addCurveView() {
        let size: CGFloat = 200
        let curveView = CurveView(controlPoints: controlPoints)
        curveView.backgroundColor = .clearColor()
        curveView.frame = CGRect(x: 0, y: bounds.midY - size / 2, width: size, height: size)
        curveView.controlPoints = controlPoints
        containerView.addSubview(curveView)
    }
    
    func addCircleView() {
        let circleView = UIView(frame: CGRect(x: 0, y: 0, width: 112, height: 112))
        circleView.layer.cornerRadius = circleView.bounds.midX
        circleView.backgroundColor = [#Color(colorLiteralRed: 0.403921568627451, green: 0.5294117647058824, blue: 0.6862745098039216, alpha: 1)#]
        circleView.center = CGPoint(x: bounds.width * 0.7, y: bounds.midY)
        containerView.addSubview(circleView)
        addAnimation(toView: circleView)
    }
    
    func addAnimation(toView view: UIView) {
        let animation = CABasicAnimation(keyPath: keyPathToAnimate)
        let c = controlPoints.map{ (x: Float($0.x), y: Float($0.y)) }
        animation.timingFunction = CAMediaTimingFunction(controlPoints: c[0].x, c[0].y, c[1].x, c[1].y)
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = duration
        animation.repeatCount = .infinity
        
        view.layer.addAnimation(animation, forKey: nil)
    }
    
    addCurveView()
    addCircleView()
}

configure()
