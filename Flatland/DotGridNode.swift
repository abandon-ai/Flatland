import SpriteKit

class DotGridNode: SKNode {
    let gridSize: CGSize
    let dotColor: SKColor
    let dotSize: CGFloat // 点的大小
    let spacing: CGFloat // 点之间的间隔
    
    init(gridSize: CGSize, dotSize: CGFloat = 2.0, spacing: CGFloat = 10.0, dotColor: SKColor = SKColor.lightGray) {
        self.gridSize = gridSize
        self.dotSize = dotSize
        self.spacing = spacing
        self.dotColor = dotColor
        super.init()
        drawDots()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func drawDots() {
        let rows = Int(gridSize.height / spacing)
        let columns = Int(gridSize.width / spacing)
        
        for row in 0...rows {
            for column in 0...columns {
                let dot = SKShapeNode(circleOfRadius: dotSize / 2)
                dot.fillColor = dotColor
                dot.strokeColor = dotColor
                dot.position = CGPoint(x: CGFloat(column) * spacing, y: CGFloat(row) * spacing)
                addChild(dot)
            }
        }
    }
}
