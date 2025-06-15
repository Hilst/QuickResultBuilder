import SwiftSyntax

enum QRBFunction: CaseIterable {
	case block, final, partial, partialAcc, array, optional, either1, either2, expression, availability

	static let names: [QRBFunction: String] = [
		.block: "buildBlock",
		.final: "buildFinalResult",
		.partial: "buildPartialBlock",
		.partialAcc: "buildPartialBlock",
		.array: "buildArray",
		.optional: "buildOptional",
		.either1: "buildEither",
		.either2: "buildEither",
		.expression: "buildExpression",
		.availability: "buildLimitedAvailability",
	]

	var name: String {
		Self.names[self] ?? ""
	}

	init?(from fnDecl: FunctionDeclSyntax) {
		let fnName = fnDecl.name.text
		let rbFnEnum = Self.allCases.first { Self.names[$0] == fnName }
		guard let rbFnEnum else { return nil }

		if rbFnEnum == .partial || rbFnEnum == .partialAcc {
			let paramsFirstName = Self.firstParameterFirstName(from: fnDecl)
			if paramsFirstName == QRBParameter.first.name {
				self = .partial
			} else if paramsFirstName == QRBParameter.accumulated.name {
				self = .partialAcc
			} else {
				return nil
			}
			return
		}

		if rbFnEnum == .either1 || rbFnEnum == .either2 {
			let paramsFirstName = Self.firstParameterFirstName(from: fnDecl)
			if paramsFirstName == QRBParameter.first.name {
				self = .either1
			} else if paramsFirstName == QRBParameter.second.name {
				self = .either2
			} else {
				return nil
			}
			return
		}

		self = rbFnEnum
		return
	}

	static func firstParameterFirstName(from decl: FunctionDeclSyntax) -> String? {
		decl.signature.parameterClause.parameters.first?.firstName.text
	}

	func builder() -> (any RBBuilder)? {
		switch self {
		case .block: RBBlock()
		case .array: RBArray()
		case .availability: RBLimitedAvailability()
		case .either1: RBEither(firstOrSecond: .first)
		case .either2: RBEither(firstOrSecond: .second)
		case .expression: RBExpression()
		case .optional: RBOptional()
		case .partial: RBPartialFirst()
		case .partialAcc: RBPartialAccumulated()
		case .final: nil
		}
	}
}
