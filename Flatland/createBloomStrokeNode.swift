import SpriteKit

func createBloomStrokeNode(size: CGSize, lineWidth: CGFloat, radius: CGFloat,bloomIntensity: CGFloat, bloomRadius: CGFloat) -> SKEffectNode {
    let squareStrokeNode = SKEffectNode()
    
    let bloomFilter = CIFilter(name: "CIBloom")!
    bloomFilter.setValue(bloomIntensity, forKey: kCIInputIntensityKey)
    bloomFilter.setValue(bloomRadius, forKey: kCIInputRadiusKey)
    
    squareStrokeNode.filter = bloomFilter
    squareStrokeNode.shouldEnableEffects = true
    let borderNode = SKShapeNode(rectOf: size, cornerRadius: radius)
    borderNode.strokeColor = SKColor.white
    borderNode.lineWidth = lineWidth
    borderNode.fillColor = SKColor.clear
    squareStrokeNode.addChild(borderNode)
    return squareStrokeNode
}
