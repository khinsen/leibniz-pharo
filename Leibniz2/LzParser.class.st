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

{ #category : #signature }
LzParser >> bracketOp [
	^ super bracketOp
		==> [ :nodes |
				| args |
				args := OrderedCollection with: nodes first.
				args addAll: (nodes third reject: [ :element | element = $,]).
				{ LzBracketOperatorName new. args asArray } ]
]

{ #category : #rules }
LzParser >> code [
	^ super code
		==> [ :nodes | { nodes second. nodes fifth } ]
]

{ #category : #rules }
LzParser >> fnRule [
	^ super fnRule ==> [ :nodes |
		[ :signature |
			| variables |
			variables := (nodes first collect: [ :each |
				each cull: signature cull: Dictionary new ])
					asDictionary.
			LbFunctionRule
				pattern: (nodes second cull: signature cull: variables)
				localVariables: variables
				condition: (nodes fifth ifNotNil:
								[ :c | c second cull: signature cull: variables ])
				function: nodes fourth ] ]
]

{ #category : #signature }
LzParser >> forAllClause [
	^ super forAllClause ==> [ :nodes |
		LzASTVar new
			name: (LzVarName for: nodes second);
			sort: nodes fourth ]
]

{ #category : #terms }
LzParser >> fpNumberTerm [
	^ super fpNumberTerm
		==> [ :string |
		 	"In Pharo, a number with an exponent but without a fractional part
		 	 is an integer, not a float.
			  Workaround: convert the converted string explicitly to a float."
			  LzASTLiteral new
					value: string asNumber asFloat;
					sort: (LzASTOpTerm new
							opName: (LzPrefixOperatorName for: #fpNumber)) ]
]

{ #category : #signature }
LzParser >> infixOp [
	^ super infixOp ==> [ :nodes |
		{ LzInfixOperatorName for: nodes second. { nodes first. nodes third } } ]
]

{ #category : #terms }
LzParser >> integerTerm [
	^ super integerTerm
		==> [ :string |
			  LzASTLiteral new
					value: string asNumber;
					sort: (LzASTOpTerm new
							opName: (LzPrefixOperatorName for: #integer)) ]
]

{ #category : #terms }
LzParser >> nonInfixTerm [
	^ super nonInfixTerm ==> [ :nodes |
		nodes second
			ifNil: [ nodes first ] "simpleTerm, no suffix"
			ifNotNil: [ :suffixNode |
				LzASTOpTerm new
					opName: suffixNode first;
					args: (suffixNode second copyWithFirst: nodes first) ] ]
]

{ #category : #signature }
LzParser >> op [
	^ super op ==> [ :nodes |
		LzASTOp new
			name: nodes second first;
			args: nodes second second;
			sort: nodes fourth;
			variables: nodes first ]
]

{ #category : #terms }
LzParser >> pattern [
	^ super pattern ==> [ :nodes |
		| variables parsedTerm |
		variables := nodes first.
		parsedTerm := nodes second.
		LzASTPattern new
			variables: nodes first;
			term: nodes second ]
]

{ #category : #signature }
LzParser >> prefixOp [
	^ super prefixOp ==> [ :nodes |
		{
			LzPrefixOperatorName for: nodes first.
			nodes third reject: [ :element | element = $, ]
		} ]
]

{ #category : #terms }
LzParser >> prefixOpTerm [
	^ super prefixOpTerm ==> [ :nodes |
		LzASTOpTerm new
			opName: (LzPrefixOperatorName for: nodes first);
			args: ((nodes at: 3) reject: [ :element | element = $, ]) ]
]

{ #category : #terms }
LzParser >> rationalNumberTerm [
	^ super rationalNumberTerm
		==> [ :string |
			  LzASTLiteral new
				value: (Fraction readFromString: string);
				sort: (LzASTOpTerm new
						opName: (LzPrefixOperatorName for: #rational)) ]
]

{ #category : #rules }
LzParser >> rewriteRule [
	^ super rewriteRule ==> [ :nodes |
		[ :signature |
			| variables |
			variables := (nodes first collect: [ :each |
				each cull: signature cull: Dictionary new ])
					asDictionary.
			LbRewriteRule
				pattern: (nodes second cull: signature cull: variables)
				localVariables: variables
				condition: (nodes fifth ifNotNil:
								[ :c | c second cull: signature cull: variables ])
				replacement: (nodes fourth cull: signature cull: variables) ] ]
]

{ #category : #terms }
LzParser >> stringTerm [
	^ super stringTerm
		==> [ :string |
			  LzASTLiteral new
					value: string;
					sort: (LzASTOpTerm new
							opName: (LzPrefixOperatorName for: #string)) ]
]

{ #category : #signature }
LzParser >> subscriptOp [
	^ super subscriptOp ==> [ :nodes |
		| args |
		args := OrderedCollection with: nodes first.
		args addAll: (nodes fourth reject: [ :element | element = $, ]).
		{ LzSubscriptOperatorName new. args asArray } ]
]

{ #category : #axioms }
LzParser >> subsortAxiom [
	^ super subsortAxiom ==> [ :nodes |
		| variables subsort supersort |
		variables := nodes first.
		subsort := nodes second.
		supersort := nodes fourth.
		{ variables. subsort. supersort } ]
]

{ #category : #signature }
LzParser >> superscriptOp [
	^ super superscriptOp ==> [ :nodes |
		| args |
		args := OrderedCollection with: nodes first.
		args addAll: (nodes fourth reject: [ :element | element = $, ]).
		{ LzSuperscriptOperatorName new. args asArray } ]
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
				name := LzInfixOperatorName
							for: nodes first asSymbol.
				(nodes allButFirst: 2)
					inject: nodes second
					into: [ :result :nextArg |
						LzASTOpTerm new
							opName: name;
							args: { result . nextArg } ] ] ]
]

{ #category : #signature }
LzParser >> var [
	^ super var ==> [ :nodes |
		LzASTVar new
			name: (LzVarName for: nodes first);
			sort: nodes third ]
]

{ #category : #signature }
LzParser >> varArg [
	^ super varArg ==> [ :nodes |
		LzASTVar new
			name: (LzVarName for: nodes first);
			sort: nodes third ]
]

{ #category : #terms }
LzParser >> varTerm [
	^ super varTerm ==> [ :symbol |
		LzASTVarTerm new
			name: (LzVarName for: symbol) ]
]

{ #category : #signature }
LzParser >> zeroArgOp [
	^ super zeroArgOp ==> [ :idString |
		{ LzPrefixOperatorName for: idString. #() } ]
]

{ #category : #terms }
LzParser >> zeroArgTerm [
	^ super zeroArgTerm ==> [ :symbol |
		LzASTOpTerm new
			opName: (LzPrefixOperatorName for: symbol);
			args: #() ]
]
