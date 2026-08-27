internal import Ownership_Latch
internal import Synchronization

public func withObservationTracking<R>(
    _ apply: () -> R,
    onChange: @escaping @Sendable () -> Void
) -> R {
    let frame = Observation.Tracking.Frame(parent: Observation.Tracking.currentFrame())
    Observation.Tracking.pushFrame(frame)
    let result = apply()
    Observation.Tracking.popFrame(frame)

    let accesses = frame.accesses
    guard !accesses.isEmpty else { return result }

    Observation.Tracking._installOneShot(accesses: accesses, onChange: onChange)

    return result
}

extension Observation.Tracking {

    @discardableResult
    static func _installOneShot(
        accesses: [ObjectIdentifier: (
            registrar: Observation.Registrar, properties: Set<Observation.Property.ID>
        )],
        onChange: @escaping @Sendable () -> Void
    ) -> Ownership.Latch<@Sendable () -> Void> {

        let pending: Mutex<[(Observation.Registrar, Observation.Subscription.ID)]> = Mutex([])

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
