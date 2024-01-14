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
    var leftThumbstickMoved: ((_ xValue: Float, _ yValue: Float) -> Void)?
    var rightThumbstickMoved: ((_ xValue: Float, _ yValue: Float) -> Void)?
    var leftTriggerPressed: ((_ value: Float) -> Void)?
    var rightTriggerPressed: ((_ value: Float) -> Void)?
    
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
                print("Button A pressed")
                self.buttonAPressed?()
            }
        }
        
        gamepad.buttonB.pressedChangedHandler = { (button, value, pressed) in
            if pressed {
                print("Button B pressed")
                self.buttonAPressed?()
            }
        }
        
        gamepad.buttonX.pressedChangedHandler = { (button, value, pressed) in
            if pressed {
                print("Button X pressed")
                self.buttonAPressed?()
            }
        }
        
        gamepad.buttonY.pressedChangedHandler = { (button, value, pressed) in
            if pressed {
                print("Button Y pressed")
                self.buttonAPressed?()
            }
        }
        
        gamepad.leftThumbstick.valueChangedHandler = { (thumbstick, xValue, yValue) in
            print("Left thumbstick: \(xValue), \(yValue)")
            self.leftThumbstickMoved?(xValue, yValue)
        }
        
        gamepad.leftThumbstickButton?.pressedChangedHandler = { (button, value, pressed) in
            if pressed {
                print("Left Thumb stick button pressed")
                self.leftThumbStickButtonPressed?()
            }
        }
        
        gamepad.rightThumbstick.valueChangedHandler = { (thumbstick, xValue, yValue) in
            print("Right thumbstick: \(xValue), \(yValue)")
            self.rightThumbstickMoved?(xValue, yValue)
        }
        
        gamepad.rightThumbstickButton?.pressedChangedHandler = { (button, value, pressed) in
            if pressed {
                print("Right Thumb stick button pressed")
                self.rightThumbStickButtonPressed?()
            }
        }
        
        gamepad.buttonMenu.pressedChangedHandler = { (button, value, pressed) in
            if pressed {
                print("Button Menu pressed")
                self.buttonMenuPressed?()
            }
        }
        
        gamepad.dpad.up.pressedChangedHandler = { (button, value, pressed) in
            if pressed {
                print("Dpad up pressed")
                self.dpadUpPressed?()
            }
        }
        
        gamepad.dpad.down.pressedChangedHandler = { (button, value, pressed) in
            if pressed {
                print("Dpad down pressed")
                self.dpadDownPressed?()
            }
        }
        
        gamepad.dpad.left.pressedChangedHandler = { (button, value, pressed) in
            if pressed {
                print("Dpad left pressed")
                self.dpadLeftPressed?()
            }
        }
        
        gamepad.dpad.right.pressedChangedHandler = { (button, value, pressed) in
            if pressed {
                print("Dpad right pressed")
                self.dpadRightPressed?()
            }
        }
        
        gamepad.leftShoulder.pressedChangedHandler = { (button, value, pressed) in
            if pressed {
                print("Left Shoulder pressed")
                self.leftShoulderPressed?()
            }
        }
        
        gamepad.rightShoulder.pressedChangedHandler = { (button, value, pressed) in
            if pressed {
                print("Right Shoulder pressed")
                self.rightShoulderPressed?()
            }
        }
        
        gamepad.leftTrigger.valueChangedHandler = { (trigger, value, pressed) in
            if pressed {
                print("Left Trigger value: \(value)") // value 范围从 0.0 (未按压) 到 1.0 (完全按压)
                self.leftTriggerPressed?(value)
            }
         }
        
        gamepad.rightTrigger.valueChangedHandler = { (trigger, value, pressed) in
            if pressed {
                print("Right Trigger value: \(value)") // value 范围同上
                self.rightTriggerPressed?(value)
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
