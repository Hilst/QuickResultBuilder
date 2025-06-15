@attached(member,
		  names: named(Component),
		  named(buildBlock),
		  named(buildPartialBlock),
		  named(buildOptional),
		  named(buildExpression),
		  named(buildEither),
		  named(buildArray),
		  named(buildLimitedAvailability)
)
public macro QuickResultBuilder<T>(_ type: T.Type? = Any.self) = #externalMacro(
	module: "QuickResultBuilderMacros",
	type: "QuickResultBuilderMacro"
)
