import SwiftSyntax

enum QRBTAlias: String {
	case Component
	case Element

	var name: String {
		self == .Element ? "\(Self.Component.rawValue).\(rawValue)" : rawValue
	}

	var TokenStx: TokenSyntax { .identifier(name) }
	var TypeStx: IdentifierTypeSyntax { IdentifierTypeSyntax(name: TokenStx)
	}
}

enum QRBParameter: String {
	case component
	case first
	case second
	case accumulated
	case next
	case expression

	var name: String { rawValue }
	var pluralName: String { "\(rawValue)s" }
	var TokenStx: TokenSyntax { .identifier(name) }
	var PluralTokenStx: TokenSyntax { .identifier(pluralName) }
}
