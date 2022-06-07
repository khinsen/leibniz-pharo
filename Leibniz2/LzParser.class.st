Class {
	#name : #LzParser,
	#superclass : #LzGrammarRulesAndAxioms,
	#category : #'Leibniz2-Parser'
}

{ #category : #parsing }
LzParser class >> parse: aString startingAt: aSymbol [
	| astNode |
	astNode := (self newStartingAt: aSymbol) parse: aString.
	astNode isPetit2Failure ifTrue:
		[ self error: astNode message, ' after ',
				 (aString sliceFrom: 1 to: astNode position) ].
	^ astNode
]

{ #category : #parsing }
LzParser class >> parse: aString startingAt: aSymbol yielding: aLzASTNodeSubclass [
	| astNode |
	astNode := self parse: aString startingAt: aSymbol.
	self assert: (astNode isKindOf: aLzASTNodeSubclass).
	^ astNode
]

{ #category : #terms }
LzParser >> arrayElements [
	^ super arrayElements
		==> [ :nodes |
				| elements |
				elements := nodes second.
				elements
					ifNil: [ #() ]
					ifNotNil: [
						(1 to: elements size by: 2) collect: [ :each |
							elements at: each ] ] ]
]

{ #category : #terms }
LzParser >> arrayTerm [
	^ super arrayTerm
		==> [ :nodes |
				LzArrayTermDeclaration new
					elements: nodes second ].
]

{ #category : #signature }
LzParser >> bracketOp [
	^ super bracketOp
		==> [ :nodes |
				| args |
				args := OrderedCollection with: nodes first.
				args addAll: (nodes third reject: [ :element | element = $,]).
				{ LzBracketOpName new. args asArray } ]
]

{ #category : #rules }
LzParser >> code [
	^ super code
		==> [ :nodes | { nodes second. nodes fifth } ]
]

{ #category : #terms }
LzParser >> decimalRationalNumberTerm [
	^ super decimalRationalNumberTerm
		==> [ :string |
				self flag: #todo. "Round-off-free conversion"
			  LzRationalLiteralDeclaration new
				value: string asNumber asFloat asFraction ]
]

{ #category : #axioms }
LzParser >> equalityAxiom [
	^ super equalityAxiom ==> [ :nodes |
		| axiom |
		axiom := LzEqualityAxiomDeclaration new
			variables: nodes first;
			left: nodes second;
			right: nodes fourth.
		nodes fifth ifNotNil: [ :c |
			axiom condition: c second ].
		axiom ]
]

{ #category : #rules }
LzParser >> fnRule [
	^ super fnRule ==> [ :nodes |
		| rule |
		rule := LzFunctionRuleDeclaration new
			variables: nodes first;
			pattern: nodes second;
			function: nodes fourth.
		nodes fifth ifNotNil: [ :c |
			rule condition: c second ].
		rule ]
]

{ #category : #signature }
LzParser >> forAllClause [
	^ super forAllClause ==> [ :nodes |
		nodes first = $∀
			"Old syntax"
			ifTrue: [ LzVarDeclaration new
						name: (LzVarName for: nodes second);
						sort: nodes fourth ]
			"New syntax"
			ifFalse: [ LzVarDeclaration new
						name: (LzVarName for: nodes first);
						sort: nodes third ] ]
]

{ #category : #terms }
LzParser >> fpNumberTerm [
	^ super fpNumberTerm
		==> [ :string |
		 	"In Pharo, a number with an exponent but without a fractional part
		 	 is an integer, not a float.
			  Workaround: convert the converted string explicitly to a float."
			  LzFPLiteralDeclaration new
				value: string asNumber asFloat ]
]

{ #category : #signature }
LzParser >> infixOp [
	^ super infixOp ==> [ :nodes |
		{ LzInfixOpName for: nodes second. { nodes first. nodes third } } ]
]

{ #category : #terms }
LzParser >> integerTerm [
	^ super integerTerm
		==> [ :string |
			  LzIntegerLiteralDeclaration new
					value: string asNumber ]
]

{ #category : #terms }
LzParser >> nonInfixTerm [
	^ super nonInfixTerm ==> [ :nodes |
		nodes second
			ifNil: [ nodes first ] "simpleTerm, no suffix"
			ifNotNil: [ :suffixNode |
				LzOpTermDeclaration new
					opName: suffixNode first;
					args: (suffixNode second copyWithFirst: nodes first) ] ]
]

{ #category : #signature }
LzParser >> op [
	^ super op ==> [ :nodes |
		LzOpDeclaration new
			name: nodes second first;
			args: nodes second second;
			sort: nodes fourth;
			variables: nodes first ]
]

{ #category : #terms }
LzParser >> parenthesizedTerm [
	^ super parenthesizedTerm ==> [ :innerTerm |
		LzParenthesesAnnotation new
			declaration: innerTerm ]
]

{ #category : #terms }
LzParser >> pattern [
	^ super pattern ==> [ :nodes |
		nodes isCollection ifTrue: [
			| variables parsedTerm |
			variables := nodes first.
			parsedTerm := nodes second.
			LzPatternDeclaration new
				variables: nodes first;
				term: nodes second ]
		ifFalse: [
			LzPatternDeclaration new
				variables: #();
				term: nodes ] ]
]

{ #category : #signature }
LzParser >> prefixOp [
	^ super prefixOp ==> [ :nodes |
		{
			LzPrefixOpName for: nodes first.
			nodes third reject: [ :element | element = $, ]
		} ]
]

{ #category : #terms }
LzParser >> prefixOpTerm [
	^ super prefixOpTerm ==> [ :nodes |
		LzOpTermDeclaration new
			opName: (LzPrefixOpName for: nodes first);
			args: ((nodes at: 3) reject: [ :element | element = $, ]) ]
]

{ #category : #terms }
LzParser >> rationalNumberTerm [
	^ super rationalNumberTerm
		==> [ :string |
			  LzRationalLiteralDeclaration new
				value: (Fraction readFromString: string) ]
]

{ #category : #rules }
LzParser >> rewriteRule [
	^ super rewriteRule ==> [ :nodes |
		| rule |
		rule := LzRewriteRuleDeclaration new
			variables: nodes first;
			pattern: nodes second;
			replacement: nodes fourth.
		nodes fifth ifNotNil: [ :c |
			rule condition: c second ].
		rule ]
]

{ #category : #accessing }
LzParser >> sort [
	^ super sort ==> [ :nodes |
		nodes isCollection
			ifTrue: [ nodes second ]
			ifFalse: [ nodes ] ]
]

{ #category : #terms }
LzParser >> stringTerm [
	^ super stringTerm
		==> [ :string |
			  LzStringLiteralDeclaration new
					value: string ]
]

{ #category : #signature }
LzParser >> subscriptOp [
	^ super subscriptOp ==> [ :nodes |
		| args |
		args := OrderedCollection with: nodes first.
		args addAll: (nodes fourth reject: [ :element | element = $, ]).
		{ LzSubscriptOpName new. args asArray } ]
]

{ #category : #axioms }
LzParser >> subsortAxiom [
	^ super subsortAxiom ==> [ :nodes |
		| variables subsort supersort |
		variables := nodes first.
		subsort := nodes second.
		supersort := nodes fourth.
		LzSubsortAxiomDeclaration new
			variables: nodes first;
			subsort: nodes second;
			supersort: nodes fourth ]
]

{ #category : #signature }
LzParser >> superscriptOp [
	^ super superscriptOp ==> [ :nodes |
		| args |
		args := OrderedCollection with: nodes first.
		args addAll: (nodes fourth reject: [ :element | element = $, ]).
		{ LzSuperscriptOpName new. args asArray } ]
]

{ #category : #terms }
LzParser >> term [
	^ super term  ==> [ :nodes |
		nodes size = 1
			ifTrue: [ nodes first ] "nonInfixTerm"
			ifFalse: [
				| name |
				"nodes contains the infix operator symbol followed by
				all the arguments. Example 'a + b + c' becomes
				{ '+'. a. b. c } with a b c already converted to blocks."
				name := LzInfixOpName
							for: nodes first asSymbol.
				(nodes allButFirst: 2)
					inject: nodes second
					into: [ :result :nextArg |
						LzOpTermDeclaration new
							opName: name;
							args: { result . nextArg } ] ] ]
]

{ #category : #signature }
LzParser >> var [
	^ super var ==> [ :nodes |
		LzVarDeclaration new
			name: (LzVarName for: nodes first);
			sort: nodes third ]
]

{ #category : #signature }
LzParser >> varArg [
	^ super varArg ==> [ :nodes |
		LzVarTermDeclaration new
			name: (LzVarName for: nodes first);
			sort: nodes third ]
]

{ #category : #terms }
LzParser >> varTerm [
	^ super varTerm ==> [ :symbol |
		LzVarTermDeclaration new
			name: (LzVarName for: symbol) ]
]

{ #category : #signature }
LzParser >> zeroArgOp [
	^ super zeroArgOp ==> [ :idString |
		{ LzPrefixOpName for: idString. #() } ]
]

{ #category : #terms }
LzParser >> zeroArgTerm [
	^ super zeroArgTerm ==> [ :symbol |
		LzOpTermDeclaration new
			opName: (LzPrefixOpName for: symbol);
			args: #() ]
]
