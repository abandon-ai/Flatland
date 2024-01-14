import SpriteKit

func CreateGradientLayer(frame: CGRect, colors: [String], startPoint: CGPoint, endPoint: CGPoint) -> CAGradientLayer {
    let gradientLayer = CAGradientLayer()
    gradientLayer.frame = frame
    gradientLayer.colors = colors.map { UIColor(hex: $0).cgColor }
    gradientLayer.startPoint = startPoint
    gradientLayer.endPoint = endPoint
    return gradientLayer
}
