internal import Ownership
internal import Synchronization

public func withObservationTracking<R>(
    _ apply: () -> R,
    onChange: @escaping @Sendable () -> Void
) -> R {
    let frame = Observer.Tracking.Frame(parent: Observer.Tracking.currentFrame())
    Observer.Tracking.pushFrame(frame)
    let result = apply()
    Observer.Tracking.popFrame(frame)

    let accesses = frame.accesses
    guard !accesses.isEmpty else { return result }

    Observer.Tracking._installOneShot(accesses: accesses, onChange: onChange)

    return result
}

extension Observer.Tracking {

    @discardableResult
    static func _installOneShot(
        accesses: [ObjectIdentifier: (
            registrar: Observer.Registrar, properties: Set<Observer.Property.ID>
        )],
        onChange: @escaping @Sendable () -> Void
    ) -> Ownership.Latch<@Sendable () -> Void> {

        let pending: Mutex<[(Observer.Registrar, Observer.Subscription.ID)]> = Mutex([])

        let cleanup: @Sendable () -> Void = {
            let ids = pending.withLock { $0 }
            for (registrar, id) in ids {
                registrar.unsubscribe(id)
            }
            onChange()
        }

        let latch = Ownership.Latch<@Sendable () -> Void>(cleanup)

        for (_, value) in accesses {
            let registrar = value.registrar
            let properties = value.properties
            let id = registrar.subscribe(
                to: properties,
                didSet: { @Sendable [latch] _ in
                    latch.take()?()
                }
            )
            pending.withLock { $0.append((registrar, id)) }
        }

        return latch
    }
}
