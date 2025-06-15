import SwiftSyntax

protocol AsDeclaration: DeclSyntaxProtocol {
	var asDecl: DeclSyntax { get }
}

extension AsDeclaration {
	var asDecl: DeclSyntax { DeclSyntax(self) }
}

extension TypeAliasDeclSyntax: AsDeclaration { }
extension FunctionDeclSyntax: AsDeclaration { }
