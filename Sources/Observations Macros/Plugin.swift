import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct ObservationsPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        ObservableMacro.self,
        ObservationTrackedMacro.self,
    ]
}
