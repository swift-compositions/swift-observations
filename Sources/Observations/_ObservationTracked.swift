@attached(accessor, names: named(init), named(_read), named(_modify))
@attached(peer, names: prefixed(_))
public macro _ObservationTracked(_ id: UInt32 = 0) =
    #externalMacro(
        module: "Observations_Macros",
        type: "ObservationTrackedMacro"
    )
