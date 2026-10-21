extension Observer.Tracking {

    final class Frame {

        let parent: Frame?

        var accesses:
            [ObjectIdentifier: (
                registrar: Observer.Registrar, properties: Set<Observer.Property.ID>
            )] = [:]

        init(parent: Frame?) {
            self.parent = parent
        }
    }
}

extension Observer.Tracking.Frame {

    func record(_ registrar: Observer.Registrar, _ propertyID: Observer.Property.ID) {
        let key = registrar.id
        if var existing = accesses[key] {
            existing.properties.insert(propertyID)
            accesses[key] = existing
        } else {
            accesses[key] = (registrar, [propertyID])
        }
    }
}
