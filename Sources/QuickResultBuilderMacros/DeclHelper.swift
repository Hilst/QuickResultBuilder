import SwiftSyntax

enum DeclHelper {
	static func structDeclaration(ofMember decl: some DeclSyntaxProtocol) throws -> StructDeclSyntax {
		guard let decl = decl.as(StructDeclSyntax.self) else { throw QRBErrors.notStruct.error }
		return decl
	}

	static func resultBuiderDeclaration(ofStruct decl: StructDeclSyntax) throws -> StructDeclSyntax {
		let RBDecl = decl.attributes
			.compactMap { $0.as(AttributeSyntax.self) }
			.filter { $0.firstToken(viewMode: .fixedUp)?.tokenKind == .atSign }
			.first { $0.lastToken(viewMode: .fixedUp)?.text == "resultBuilder" }
		if RBDecl == nil { throw QRBErrors.notRB.error }
		return decl
	}

	static func contentTA(fromStruct decl: StructDeclSyntax) -> TypeAliasDeclSyntax? {
		return decl.memberBlock.members
			.compactMap { $0.decl.as(TypeAliasDeclSyntax.self) }
			.first { $0.name.text == QRBTAlias.Component.name }
	}


	static func staticFns(ofStruct decl: StructDeclSyntax) -> [FunctionDeclSyntax] {
		return decl.memberBlock.members
			.compactMap { $0.decl.as(FunctionDeclSyntax.self) }
			.filter { $0.modifiers.any(withLiteral: "static") }
	}
}
