import SpriteKit
import GameController

class GamePad {
    private var controller: GCController?
    var buttonAPressed: (() -> Void)?
    var buttonBPressed: (() -> Void)?
    var buttonXPressed: (() -> Void)?
    var buttonYPressed: (() -> Void)?
    var buttonMenuPressed: (() -> Void)?
    var dpadUpPressed: (() -> Void)?
    var dpadDownPressed: (() -> Void)?
    var dpadLeftPressed: (() -> Void)?
    var dpadRightPressed: (() -> Void)?
    var leftShoulderPressed: (() -> Void)?
    var rightShoulderPressed: (() -> Void)?
    var leftThumbStickButtonPressed: (() -> Void)?
    var rightThumbStickButtonPressed: (() -> Void)?
    var leftThumbstickMoved: ((_ xValue: CGFloat, _ yValue: CGFloat) -> Void)?
    var rightThumbstickMoved: ((_ xValue: CGFloat, _ yValue: CGFloat) -> Void)?
    var leftTriggerPressed: ((_ value: CGFloat) -> Void)?
    var rightTriggerPressed: ((_ value: CGFloat) -> Void)?
    
    init() {
        setupControllers()
    }
    
    private func setupControllers() {
        NotificationCenter.default.addObserver(self, selector: #selector(controllerDidConnect), name: .GCControllerDidConnect, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(controllerDidDisconnect), name: .GCControllerDidDisconnect, object: nil)
        
        GCController.startWirelessControllerDiscovery { [weak self] in
            self?.controller = GCController.controllers().first
            self?.registerInputHandlers()
        }
    }
    
    @objc private func controllerDidConnect(notification: Notification) {
        controller = notification.object as? GCController
        registerInputHandlers()
    }
    
    @objc private func controllerDidDisconnect(notification: Notification) {
        controller = nil
    }
    
    private func registerInputHandlers() {
        guard let controller = controller, let gamepad = controller.extendedGamepad else {
            return
        }
        
        gamepad.buttonA.pressedChangedHandler = { (button, value, pressed) in
            if pressed {
                self.buttonAPressed?()
            }
        }
        
        gamepad.buttonB.pressedChangedHandler = { (button, value, pressed) in
            if pressed {
                self.buttonAPressed?()
            }
        }
        
        gamepad.buttonX.pressedChangedHandler = { (button, value, pressed) in
            if pressed {
                self.buttonAPressed?()
            }
        }
        
        gamepad.buttonY.pressedChangedHandler = { (button, value, pressed) in
            if pressed {
                self.buttonAPressed?()
            }
        }
        
        gamepad.leftThumbstick.valueChangedHandler = { (thumbstick, xValue, yValue) in
            self.leftThumbstickMoved?(CGFloat(xValue), CGFloat(yValue))
        }
        
        gamepad.leftThumbstickButton?.pressedChangedHandler = { (button, value, pressed) in
            if pressed {
                self.leftThumbStickButtonPressed?()
            }
        }
        
        gamepad.rightThumbstick.valueChangedHandler = { (thumbstick, xValue, yValue) in
            self.rightThumbstickMoved?(CGFloat(xValue), CGFloat(yValue))
        }
        
        gamepad.rightThumbstickButton?.pressedChangedHandler = { (button, value, pressed) in
            if pressed {
                self.rightThumbStickButtonPressed?()
            }
        }
        
        gamepad.buttonMenu.pressedChangedHandler = { (button, value, pressed) in
            if pressed {
                self.buttonMenuPressed?()
            }
        }
        
        gamepad.dpad.up.pressedChangedHandler = { (button, value, pressed) in
            if pressed {
                self.dpadUpPressed?()
            }
        }
        
        gamepad.dpad.down.pressedChangedHandler = { (button, value, pressed) in
            if pressed {
                self.dpadDownPressed?()
            }
        }
        
        gamepad.dpad.left.pressedChangedHandler = { (button, value, pressed) in
            if pressed {
                self.dpadLeftPressed?()
            }
        }
        
        gamepad.dpad.right.pressedChangedHandler = { (button, value, pressed) in
            if pressed {
                self.dpadRightPressed?()
            }
        }
        
        gamepad.leftShoulder.pressedChangedHandler = { (button, value, pressed) in
            if pressed {
                self.leftShoulderPressed?()
            }
        }
        
        gamepad.rightShoulder.pressedChangedHandler = { (button, value, pressed) in
            if pressed {
                self.rightShoulderPressed?()
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
