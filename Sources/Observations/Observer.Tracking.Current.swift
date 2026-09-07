internal import Kernel_Thread

extension Observer.Tracking {

    static let _slot: Kernel.Thread.Local<Frame> =
        try! Kernel.Thread.Local()

    static func currentFrame() -> Frame? {
        _slot.value
    }

    static func pushFrame(_ frame: Frame) {
        _slot.value = frame
    }

    static func popFrame(_ frame: Frame) {
        guard let current = _slot.value else { return }
        precondition(
            current === frame,
            "Observer.Tracking frame popped out of order"
        )
        _slot.value = frame.parent
    }
}
