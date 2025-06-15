import SwiftSyntax

struct RBBlock: RBBuilder {
	let fnName = QRBFunction.block.name

	var code: CodeBlockItemListSyntax {
		// components
		.init(stringLiteral: QRBParameter.component.pluralName)
	}

	var parameters: FunctionParameterListSyntax {
		// _ components: Component.Element...
		.init(firstName: .wildcardToken(),
			  secondName: QRBParameter.component.PluralTokenStx,
			  type: QRBTAlias.Element.TypeStx,
			  ellipsis: .ellipsisToken()
		)
	}
}

struct RBPartialAccumulated: RBBuilder {
	let fnName = QRBFunction.partialAcc.name

	var code: CodeBlockItemListSyntax {
		InfixOperatorExprSyntax(
			// accumulated
			leftOperand: DeclReferenceExprSyntax(baseName: QRBParameter.accumulated.TokenStx),
			// +
			operator: BinaryOperatorExprSyntax(operator: .binaryOperator("+")),
			// next
			rightOperand: DeclReferenceExprSyntax(baseName: QRBParameter.next.TokenStx)
		)
	}

	var parameters: FunctionParameterListSyntax {
		// accumulated: Component
		FunctionParameterSyntax(firstName: QRBParameter.accumulated.TokenStx,
								type: QRBTAlias.Component.TypeStx)
		// next: Component
		FunctionParameterSyntax(firstName: QRBParameter.next.TokenStx,
								type: QRBTAlias.Component.TypeStx)
	}
}

struct RBPartialFirst: RBBuilder {
	let fnName = QRBFunction.partial.name

	var code: CodeBlockItemListSyntax {
		// first
		.init(stringLiteral: QRBParameter.first.name)
	}

	var parameters: FunctionParameterListSyntax {
		// first: Component
		.init(firstName: QRBParameter.first.TokenStx,
			  type: QRBTAlias.Component.TypeStx)
	}
}

struct RBOptional: RBBuilder {
	let fnName = QRBFunction.optional.name

	var code: CodeBlockItemListSyntax {
		InfixOperatorExprSyntax(
			// component
			leftOperand: DeclReferenceExprSyntax(baseName: QRBParameter.component.TokenStx),
			// ??
			operator: BinaryOperatorExprSyntax(text: "??"),
			// []
			rightOperand: ArrayExprSyntax(elements: [])
		)
	}
	
	var parameters: FunctionParameterListSyntax {
		// _ component: Component?
		.init(firstName: .wildcardToken(),
			  secondName: QRBParameter.component.TokenStx,
			  type: OptionalTypeSyntax(wrappedType: QRBTAlias.Component.TypeStx))
	}
}

struct RBArray: RBBuilder {
	let fnName = QRBFunction.array.name

	var parameters: FunctionParameterListSyntax {
		// _ components: [Component]
		.init(firstName: .wildcardToken(),
			  secondName: QRBParameter.component.TokenStx,
			  type: ArrayTypeSyntax(element: QRBTAlias.Component.TypeStx))
	}

	private var ZeroShorthandClosure: CodeBlockItemListSyntax {
		.init(stringLiteral: "$\(0.description)")
	}

	var code: CodeBlockItemListSyntax {
		FunctionCallExprSyntax(
			callee: MemberAccessExprSyntax(
				// components
				base: DeclReferenceExprSyntax(baseName: QRBParameter.component.TokenStx),
				// flatMap
				name: .identifier("flatMap")),
			// { $0 }
			trailingClosure: ClosureExprSyntax(statements: ZeroShorthandClosure)
		)
	}
}

struct RBEither: RBBuilder {
	let fnName = QRBFunction.either1.name

	enum FirstOrSecond {
		case first
		case second

		var paramToken: TokenSyntax {
			self == .first ?
			QRBParameter.first.TokenStx :
			QRBParameter.second.TokenStx
		}
	}
	let firstOrSecond: FirstOrSecond

	var code: CodeBlockItemListSyntax {
		// component
		.init(stringLiteral: QRBParameter.component.name)
	}

	var parameters: FunctionParameterListSyntax {
		// (first | second) component: Component
		.init(firstName: firstOrSecond.paramToken,
			  secondName: QRBParameter.component.TokenStx,
			  type: QRBTAlias.Component.TypeStx)
	}
}

struct RBExpression: RBBuilder {
	let fnName = QRBFunction.expression.name

	var parameters: FunctionParameterListSyntax {
		// _ expression: Component.Element
		.init(firstName: .wildcardToken(),
			  secondName: QRBParameter.expression.TokenStx,
			  type: QRBTAlias.Element.TypeStx)
	}

	var code: CodeBlockItemListSyntax {
		// [expression]
		ArrayExprSyntax(elements: ArrayElementListSyntax(expressions: [
			.init(stringLiteral: QRBParameter.expression.name)
		]))
	}
}

struct RBLimitedAvailability: RBBuilder {
	let fnName = QRBFunction.availability.name

	var parameters: FunctionParameterListSyntax {
		// _ component: Component
		.init(firstName: .wildcardToken(),
			  secondName: QRBParameter.component.TokenStx,
			  type: QRBTAlias.Component.TypeStx)
	}

	var code: CodeBlockItemListSyntax {
		// component
		.init(stringLiteral: QRBParameter.component.name)
	}
}
