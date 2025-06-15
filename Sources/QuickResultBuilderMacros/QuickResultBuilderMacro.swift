import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxMacros

enum QRBErrors: String {
	case notStruct = "Should be a struct"
	case notRB = "Should be marked @resultBuilder"

	case missingType = "Could not infer type alias from arguments neither from return type"
	case bFRInvParamType = "Final result parameters must be valid"
	case invTypeAlias = "Could not infer type alias from arguments"

	case notImplemented = "Not implemented"


	var error: MacroExpansionErrorMessage {
		MacroExpansionErrorMessage(self.rawValue)
	}
}

public struct QuickResultBuilderMacro: MemberMacro {
	public static func expansion(
		of node: AttributeSyntax,
		providingMembersOf declaration: some DeclGroupSyntax,
		in context: some MacroExpansionContext
	) throws -> [DeclSyntax] {
		return try DeclParser(declaration: declaration)
			.type(fromArgsOf: node)
			.parsedDeclarations()
	}
}

extension DeclModifierListSyntax {
	func any(withLiteral literal: String) -> Bool {
		contains { $0.firstToken(viewMode: .fixedUp)?.text == literal }
	}
}

@main
struct QuickResultBuilderPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [QuickResultBuilderMacro.self]
}
