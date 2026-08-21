extension Observation.Subscription {

    public struct Token: ~Copyable, Sendable {
        @usableFromInline
        var _registrar: Observation.Registrar?

        @usableFromInline
        var _id: Observation.Subscription.ID?

        @inlinable
        public init(_ registrar: Observation.Registrar, _ id: Observation.Subscription.ID) {
            self._registrar = registrar
            self._id = id
        }

        deinit {
            if let registrar = _registrar, let id = _id {
                registrar.unsubscribe(id)
            }
        }
    }
}

extension Observation.Subscription.Token {

    @inlinable
    public mutating func detach() -> (Observation.Registrar, Observation.Subscription.ID)? {
        guard let registrar = _registrar, let id = _id else { return nil }
        _registrar = nil
        _id = nil
        return (registrar, id)
    }
}
