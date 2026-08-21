@attached(member, names: named(_$registrar))
@attached(extension, conformances: Observable)
@attached(memberAttribute)
public macro Observable() =
    #externalMacro(
        module: "Observations_Macros",
        type: "ObservableMacro"
    )
