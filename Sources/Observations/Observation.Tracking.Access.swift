extension Observation.Tracking {

    public static func access(
        _ registrar: Observation.Registrar,
        _ propertyID: Observation.Property.ID
    ) {
        guard let frame = currentFrame() else { return }
        frame.record(registrar, propertyID)
    }
}
