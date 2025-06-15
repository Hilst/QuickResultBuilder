import SwiftSyntax
import SwiftSyntaxBuilder

protocol RBBuilder {
	@DeclModifierListBuilder var StaticKeyword: DeclModifierListSyntax { get }
	var fnName: String { get }
	@FunctionParameterListBuilder var parameters: FunctionParameterListSyntax { get }
	var returnType: IdentifierTypeSyntax { get }
	@CodeBlockItemListBuilder var code: CodeBlockItemListSyntax { get }
	func build() -> FunctionDeclSyntax
}

extension RBBuilder {
	@DeclModifierListBuilder
	var StaticKeyword: DeclModifierListSyntax {
		// static
		.init(name: .keyword(.static))
	}

	var FnNameToken: TokenSyntax { .identifier(fnName) }

	var returnType: IdentifierTypeSyntax {
		QRBTAlias.Component.TypeStx
	}

	func build() -> FunctionDeclSyntax {
		.init(modifiers: StaticKeyword,
			  name: FnNameToken,
			  signature: .init(parameterClause: .init(parameters: parameters),
							   returnClause: .init(type: returnType))) {
			code
		}
	}
}
