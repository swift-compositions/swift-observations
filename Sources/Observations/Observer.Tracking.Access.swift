extension Observer.Tracking {

    public static func access(
        _ registrar: Observer.Registrar,
        _ propertyID: Observer.Property.ID
    ) {
        guard let frame = currentFrame() else { return }
        frame.record(registrar, propertyID)
    }
}
