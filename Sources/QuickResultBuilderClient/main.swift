import QuickResultBuilder

@QuickResultBuilder
@resultBuilder
struct StringBuilder {
	static func buildFinalResult(_ component: [String]) -> String {
		component.joined(separator: " ")
	}
}

@QuickResultBuilder
@resultBuilder
struct StringBuilderReal {
	typealias Component = [String]
	static func buildFinalResult(_ component: [String]) -> String {
		component.joined(separator: " ")
	}
}

func use(@StringBuilderReal b: () -> String) {
	print(b())
}

func useTwo(@StringBuilder b: () -> String) {
	print(b())
}

let r = Bool.random()

use {
	"a"
	"b"
	for i in 0..<10 { "\(i)" }
	if r { "c" } else { "d" }
	r ? "e" : "f"
	if let x = Optional(Int(10)) { "\(x)" }
	if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *) {
		"g"
	}
	if #available(macOS 35.0, *) {
		"NOT h"
	} else {
		"h"
	}
}

useTwo {
	"a"
	"b"
	for i in 0..<10 { "\(i)" }
	if r { "c" } else { "d" }
	r ? "e" : "f"
	if let x = Optional(Int(10)) { "\(x)" }
	if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *) {
		"g"
	}
	if #available(macOS 35.0, *) {
		"NOT h"
	} else {
		"h"
	}
}
