import SpriteKit

public func image(from layer: CALayer) -> UIImage {
    UIGraphicsBeginImageContext(layer.bounds.size)
    layer.render(in: UIGraphicsGetCurrentContext()!)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image!
}
