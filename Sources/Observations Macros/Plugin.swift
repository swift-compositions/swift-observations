import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
fileprivate struct ObservationsPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        ObservableMacro.self,
        ObservationTrackedMacro.self,
    ]
}
