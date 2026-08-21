extension Observation.Tracking {

    final class Frame {

        let parent: Frame?

        var accesses:
            [ObjectIdentifier: (
                registrar: Observation.Registrar, properties: Set<Observation.Property.ID>
            )] = [:]

        init(parent: Frame?) {
            self.parent = parent
        }
    }
}

extension Observation.Tracking.Frame {

    func record(_ registrar: Observation.Registrar, _ propertyID: Observation.Property.ID) {
        let key = registrar.id
        if accesses[key] != nil {
            accesses[key]!.properties.insert(propertyID)
        } else {
            accesses[key] = (registrar, [propertyID])
        }
    }
}
