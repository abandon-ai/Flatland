import SpriteKit

class GridBackgroundNode: SKSpriteNode {
    let gridSize: CGSize
    let gridColor: SKColor
    
    init(gridSize: CGSize, gridColor: SKColor = SKColor.gray) {
        self.gridSize = gridSize
        self.gridColor = gridColor
        super.init(texture: nil, color: SKColor.clear, size: gridSize)
        drawGridLines()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func drawGridLines() {
        let path = CGMutablePath()
        
        for i in 0...Int(gridSize.height / 10) {
            path.move(to: CGPoint(x: 0, y: CGFloat(i) * 10))
            path.addLine(to: CGPoint(x: gridSize.width, y: CGFloat(i) * 10))
        }
        
        for i in 0...Int(gridSize.width / 10) {
            path.move(to: CGPoint(x: CGFloat(i) * 10, y: 0))
            path.addLine(to: CGPoint(x: CGFloat(i) * 10, y: gridSize.height))
        }
        
        let grid = SKShapeNode(path: path)
        grid.strokeColor = gridColor
        grid.lineWidth = 1
        
        addChild(grid)
    }
}
