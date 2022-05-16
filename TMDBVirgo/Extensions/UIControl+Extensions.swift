//
//  UIControl+Extensions.swift
//  TMDBVirgo
//
//  Created by Indo Teknologi Utama on 16/05/22.
//

import UIKit

/**
 * An extension for UIControl that lets you set action handlers using closures.
 */
extension UIControl {
    /**
     * A map of closures, mapped as [ instanceIdentifier : [ event : action ] ].
     */
    private static var _actionHandlers = [String:[UInt:((UIControl) -> Void)]]()

    /**
     * Retrieve the address for this UIControl as a String.
     */
    private func getAddressAsString() -> String {
        let addr = Unmanaged.passUnretained(self).toOpaque()
        return "\(addr)"
    }

    /**
     * Retrieve the handler associated with the specified event for this instance
     * if any exists, otherwise return nil.
     */
    private func getHandler(_ event: UIControl.Event) -> ((UIControl) -> Void)? {
        return UIControl._actionHandlers[
            self.getAddressAsString()
        ]?[event.rawValue]
    }

    /**
     * Set the action for the specified event.
     *
     * - parameter event: The event for which to set the action.
     * - parameter action: The action to perform when the event is raised.
     */
    func action(_ event: UIControl.Event, _ action:@escaping (UIControl) -> Void) {
        let id = self.getAddressAsString()
        if UIControl._actionHandlers[id] == nil {
            UIControl._actionHandlers[id] = [UInt:((UIControl) -> Void)]()
        }

        UIControl._actionHandlers[id]?[event.rawValue] = action

        switch event {
            case .touchDown:
                self.addTarget(self, action: #selector(triggerTouchDown), for: event)
                break
            case .touchDownRepeat:
                self.addTarget(self, action: #selector(triggerTouchDownRepeat), for: event)
                break
            case .touchDragInside:
                self.addTarget(self, action: #selector(triggerTouchDragInside), for: event)
                break
            case .touchDragOutside:
                self.addTarget(self, action: #selector(triggerTouchDragOutside), for: event)
                break
            case .touchDragEnter:
                self.addTarget(self, action: #selector(triggerTouchDragEnter), for: event)
                break
            case .touchDragExit:
                self.addTarget(self, action: #selector(triggerTouchDragExit), for: event)
                break
            case .touchUpInside:
                self.addTarget(self, action: #selector(triggerTouchUpInside), for: event)
                break
            case .touchUpOutside:
                self.addTarget(self, action: #selector(triggerTouchUpOutside), for: event)
                break
            case .touchCancel:
                self.addTarget(self, action: #selector(triggerTouchCancel), for: event)
                break
            case .valueChanged:
                self.addTarget(self, action: #selector(triggerValueChanged), for: event)
                break
            case .primaryActionTriggered:
                self.addTarget(self, action: #selector(triggerPrimaryActionTriggered), for: event)
                break
            case .editingDidBegin:
                self.addTarget(self, action: #selector(triggerEditingDidBegin), for: event)
                break
            case .editingDidEnd:
                self.addTarget(self, action: #selector(triggerEditingDidEnd), for: event)
                break
            case .editingChanged:
                self.addTarget(self, action: #selector(triggerEditingChanged), for: event)
                break
            case .editingDidEndOnExit:
                self.addTarget(self, action: #selector(triggerEditingDidEndOnExit), for: event)
                break
            case .allTouchEvents:
                self.addTarget(self, action: #selector(triggerAllTouchEvents), for: event)
                break
            case .allEditingEvents:
                self.addTarget(self, action: #selector(triggerAllEditingEvents), for: event)
                break
            case .applicationReserved:
                self.addTarget(self, action: #selector(triggerApplicationReserved), for: event)
                break
            case .systemReserved:
                self.addTarget(self, action: #selector(triggerSystemReserved), for: event)
                break
            case .allEvents:
                self.addTarget(self, action: #selector(triggerAllEvents), for: event)
                break
            default:
                return;
        }
    }

    // selector definitions below this line

    @objc private func triggerTouchDown() {
        getHandler(.touchDown)?(self)
    }

    @objc private func triggerTouchDownRepeat() {
        getHandler(.touchDownRepeat)?(self)
    }

    @objc private func triggerTouchDragInside() {
        getHandler(.touchDragInside)?(self)
    }

    @objc private func triggerTouchDragOutside() {
        getHandler(.touchDragOutside)?(self)
    }

    @objc private func triggerTouchDragEnter() {
        getHandler(.touchDragEnter)?(self)
    }

    @objc private func triggerTouchDragExit() {
        getHandler(.touchDragExit)?(self)
    }

    @objc private func triggerTouchUpInside() {
        getHandler(.touchUpInside)?(self)
    }

    @objc private func triggerTouchUpOutside() {
        getHandler(.touchUpOutside)?(self)
    }

    @objc private func triggerTouchCancel() {
        getHandler(.touchCancel)?(self)
    }

    @objc private func triggerValueChanged() {
        getHandler(.valueChanged)?(self)
    }

    @objc private func triggerPrimaryActionTriggered() {
        getHandler(.primaryActionTriggered)?(self)
    }

    @objc private func triggerEditingDidBegin() {
        getHandler(.editingDidBegin)?(self)
    }

    @objc private func triggerEditingChanged() {
        getHandler(.editingChanged)?(self)
    }

    @objc private func triggerEditingDidEnd() {
        getHandler(.editingDidEnd)?(self)
    }

    @objc private func triggerEditingDidEndOnExit() {
        getHandler(.editingDidEndOnExit)?(self)
    }

    @objc private func triggerAllTouchEvents() {
        getHandler(.allTouchEvents)?(self)
    }

    @objc private func triggerAllEditingEvents() {
        getHandler(.allEditingEvents)?(self)
    }

    @objc private func triggerApplicationReserved() {
        getHandler(.applicationReserved)?(self)
    }

    @objc private func triggerSystemReserved() {
        getHandler(.systemReserved)?(self)
    }

    @objc private func triggerAllEvents() {
        getHandler(.allEvents)?(self)
    }
}

