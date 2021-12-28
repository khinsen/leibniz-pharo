Class {
	#name : #LzParser,
	#superclass : #LzGrammarRulesAndAxioms,
	#category : #'Leibniz2-Parser'
}

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

{ #category : #axioms }
LzParser >> equalityAxiom [
	^ super equalityAxiom ==> [ :nodes |
		[ :signature |
			| variables |
			variables := (nodes first collect: [ :each |
				each cull: signature cull: Dictionary new ])
					asDictionary.
			LbEqualityAxiom
				left: (nodes second cull: signature cull: variables)
				right: (nodes fourth cull: signature cull: variables)
				localVariables: variables
				condition: (nodes fifth ifNotNil:
								[ :c | c second cull: signature cull: variables ]) ] ]
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
		| varName sortName |
		varName := nodes second asSymbol asLbOperatorName.
		sortName := nodes fourth first
						value: LbFakeSignatureForSortParser new
						value: Dictionary new.
		[ :aSignature :aDictionary |
			varName -> (aSignature sortNamed: sortName) ] ]
]

{ #category : #signature }
LzParser >> infixOp [
	^ super infixOp ==> [ :nodes |
		{ LzInfixOperatorName for: nodes second. { nodes first. nodes third } } ]
]

{ #category : #terms }
LzParser >> nonInfixTerm [
	^ super nonInfixTerm ==> [ :nodes |
		nodes second
			ifNil: [ nodes first ] "simpleTerm, no suffix"
			ifNotNil: [ :suffixNode |
				| name args |
				name := suffixNode first.
				args := suffixNode second copyWithFirst: nodes first.
				{ name. args } ] ]
]

{ #category : #signature }
LzParser >> op [
	^ super op ==> [ :nodes |
		| variables opName opArgs opSort |
		variables := nodes first.
		opName := nodes second first.
		opArgs := nodes second second.
		opSort := nodes fourth.
		{ opName. opArgs. opSort } ]
]

{ #category : #terms }
LzParser >> pattern [
	^ super pattern ==> [ :nodes |
		| variables parsedTerm |
		variables := nodes first.
		parsedTerm := nodes second.
		{ variables. parsedTerm } ]
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
		| name args |
		name := LzPrefixOperatorName for: nodes first.
		args := (nodes at: 3) reject: [ :element | element = $, ].
		{ name. args } ]
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
		[ :signature |
			| variables |
			variables := (nodes first collect: [ :each |
				each cull: signature cull: Dictionary new ])
					asDictionary.
			LbSubsortAxiom
				subsort: (nodes second cull: signature cull: variables)
				supersort: (nodes fourth cull: signature cull: variables)
				localVariables: variables ] ]
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
				name := LzInfixOperatorName for: nodes first asSymbol.
				(nodes allButFirst: 2)
					inject: nodes second
					into: [ :result :nextArg |
						{ name. { result . nextArg } } ] ] ]
]

{ #category : #signature }
LzParser >> var [
	^ super var ==> [ :nodes |
		| variables varName sortTerm |
		variables := nodes first.
		varName := LzVarName for: nodes second.
		sortTerm := nodes fourth first.
		{ varName.  { variables. sortTerm } } ]
]

{ #category : #terms }
LzParser >> varTerm [
	^ super varTerm ==> [ :symbol |
		{ LzVarName for: symbol } ]
]

{ #category : #signature }
LzParser >> zeroArgOp [
	^ super zeroArgOp ==> [ :idString |
		{ LbPrefixOperatorName for: idString. #() } ]
]

{ #category : #terms }
LzParser >> zeroArgTerm [
	^ super zeroArgTerm ==> [ :symbol |
		{ LzPrefixOperatorName for: symbol } ]
]
