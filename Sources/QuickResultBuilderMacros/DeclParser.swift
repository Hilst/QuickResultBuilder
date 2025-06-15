import SwiftSyntax

public final class DeclParser {
	private let structDecl: StructDeclSyntax
	private let staticRBFns: [QRBFunction: FunctionDeclSyntax]
	private let contentTADecl: TypeAliasDeclSyntax?
	private var taTypeStx: TypeSyntaxProtocol?
	private(set) var typeArgs: ArrayTypeSyntax?

	private typealias RBFnPair = (QRBFunction, FunctionDeclSyntax)

	init(declaration decl: some DeclGroupSyntax) throws {
		structDecl = try DeclHelper.resultBuiderDeclaration(
			ofStruct: try DeclHelper.structDeclaration(ofMember: decl)
		)
		contentTADecl = DeclHelper.contentTA(fromStruct: structDecl)
		staticRBFns = Dictionary(
			uniqueKeysWithValues: DeclHelper
				.staticFns(ofStruct: structDecl)
				.compactMap(Self.fnDeclPair(_:))
		)
	}

	private static func fnDeclPair(_ decl: FunctionDeclSyntax) -> RBFnPair? {
		guard let rbEnum = QRBFunction(from: decl) else { return nil }
		return (rbEnum, decl)
	}

	func type(fromArgsOf node: AttributeSyntax) throws -> Self {
		if let typeText = node.arguments?.firstToken(viewMode: .fixedUp)?.text {
			typeArgs = ArrayTypeSyntax(element: TypeSyntax(stringLiteral: typeText))
		}
		return try addTypeAliasStrategy()
	}

	private func addTypeAliasStrategy() throws -> Self {
		if contentTADecl != nil { return self }

		let fnParamType = staticRBFns[.final]?
			.signature
			.parameterClause
			.parameters
			.first?.type

		if fnParamType == nil, typeArgs == nil { throw QRBErrors.missingType.error }

		guard let typeArgs else {
			guard let fnParamType else { throw QRBErrors.missingType.error }
			guard let arrayType = fnParamType.as(ArrayTypeSyntax.self) else { throw QRBErrors.bFRInvParamType.error }
			taTypeStx = arrayType
			return self
		}

		guard let fnParamType else {
			taTypeStx = typeArgs
			return self
		}

		if fnParamType.description == QRBTAlias.Component.name {
			taTypeStx = typeArgs
			return self
		}

		guard fnParamType.description == typeArgs.description else {
			throw QRBErrors.bFRInvParamType.error
		}
		
		taTypeStx = fnParamType

		return self
	}

	func parsedDeclarations() throws -> [DeclSyntax] {
		let functions = neededFunctions().map(\.asDecl)
		guard let alias = alias() else { return functions }
		return [alias.asDecl] + functions
	}

	private func neededFunctions() -> [FunctionDeclSyntax] {
		QRBFunction.allCases
			.filter { !staticRBFns.keys.contains($0) }
			.compactMap { $0.builder() }
			.map { $0.build() }
	}

	private func alias() -> TypeAliasDeclSyntax? {
		guard let taTypeStx else { return nil }
		return TypeAliasDeclSyntax(name: QRBTAlias.Component.TokenStx,
								   initializer: .init(value: taTypeStx))
	}
}
