Class {
	#name : 'LbParser',
	#superclass : 'LbGrammarRulesAndAxioms',
	#category : 'Leibniz-0-Infrastructure'
}

{ #category : 'signature' }
LbParser >> bracketOp [
	^ super bracketOp
		==> [ :nodes |
				| args |
				args := OrderedCollection with: nodes first.
				args addAll: (nodes third reject: [ :element | element = $,]).
				{ LbBracketOperatorName new. args asArray } ]
]

{ #category : 'rules' }
LbParser >> code [
	^ super code
		==> [ :nodes | { nodes second. nodes fifth } ]
]

{ #category : 'terms' }
LbParser >> delayedTermWithOp: anOpName args: anArgList [
	^ [ :aSignature :aDictionary |
		aSignature
			nonZeroArgTermNamed: anOpName
			withArgs: (anArgList collect: [ :each |
				each cull: aSignature cull: aDictionary ]) ]
]

{ #category : 'axioms' }
LbParser >> equalityAxiom [
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

{ #category : 'rules' }
LbParser >> fnRule [
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

{ #category : 'signature' }
LbParser >> forAllClause [
	^ super forAllClause ==> [ :nodes |
		| varName sortName |
		varName := nodes second asSymbol asLbOperatorName.
		sortName := nodes fourth first asSymbol.
		[ :aSignature :aDictionary |
			varName -> (aSignature sortNamed: sortName) ] ]
]

{ #category : 'terms' }
LbParser >> fpNumberTerm [
	^ super fpNumberTerm ==> [ :value | 
		"Converting the string to a float requires some trickery:
		 - Pharo doesn't allow a dot followed by an exponent without any fractional part.
			Workaround: replace '.e' by '.0e'
		 - In Pharo, a number with an exponent but without a fractional part is an integer, not a float.
		Workaround: convert the converted string explicitly to a float."
		| floatValue |
		floatValue := (value copyReplaceAll: '.e' with: '.0e') asNumber asFloat.
		[ :aSignature :aDictionary |
			aSignature assertBuiltin: #fpNumbers.
			LbFPNumberTerm value: floatValue signature: aSignature ] ]
]

{ #category : 'signature' }
LbParser >> infixOp [
	^ super infixOp ==> [ :nodes |
		{ LbInfixOperatorName for: nodes second. { nodes first. nodes third } } ]
]

{ #category : 'signature' }
LbParser >> infixVarArg [
	^ super infixVarArg ==> [ :nodes |
		{ nodes first. nodes third first } ]
]

{ #category : 'terms' }
LbParser >> integerTerm [
	^ super integerTerm ==> [ :value |
		| intValue |
		intValue := value asNumber.
		[ :aSignature :aDictionary |
			aSignature assertBuiltin: #integers.
			LbIntegerTerm value: intValue signature: aSignature ] ]
]

{ #category : 'terms' }
LbParser >> nonInfixTerm [
	^ super nonInfixTerm ==> [ :nodes |
		nodes second
			ifNil: [ nodes first ] "simpleTerm, no suffix"
			ifNotNil: [
				| name args |
				name := LbOperatorName fromInternalSymbol: nodes second first.
				args := nodes second second copyWithFirst: nodes first.
				self delayedTermWithOp: name args: args ] ]
]

{ #category : 'signature' }
LbParser >> op [
	^ super op ==> [ :nodes |
		self assert: nodes first isEmpty. "Variables, only used for dependent sorts"
		{
			nodes second. "opAndArgs"
			nodes fourth first "sort"
		} ]
]

{ #category : 'terms' }
LbParser >> pattern [
	^ super pattern ==> [ :nodes |
		| variables parsedTerm |
		variables := nodes first.
		parsedTerm := nodes second.
		[ :aSignature :aDictionary |
			| allVariables |
			allVariables := aDictionary copy.
			variables do: [ :each |
				| newVar |
				newVar := each value: aSignature value: aDictionary.
				allVariables at: newVar key put: newVar value ].
			parsedTerm value: aSignature value: allVariables ] ]
]

{ #category : 'signature' }
LbParser >> prefixOp [
	^ super prefixOp ==> [ :nodes |
		{
			LbPrefixOperatorName for: nodes first.
			nodes third reject: [ :element | element = $, ]
		} ]
]

{ #category : 'terms' }
LbParser >> prefixOpTerm [
	^ super prefixOpTerm ==> [ :nodes |
		| name args |
		name := LbPrefixOperatorName for: nodes first.
		args := (nodes at: 3) reject: [ :element | element = $, ].
		self delayedTermWithOp: name args: args ]
]

{ #category : 'terms' }
LbParser >> rationalNumberTerm [
	^ super rationalNumberTerm==> [ :value |
		| rationalValue |
		rationalValue := Fraction readFromString: value.
		[ :aSignature :aDictionary |
			aSignature assertBuiltin: #rationalNumbers.
			LbRationalNumberTerm value: rationalValue signature: aSignature ] ]
]

{ #category : 'rules' }
LbParser >> rewriteRule [
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

{ #category : 'signature' }
LbParser >> sort [
	^ super sort
		==> [ :id | {id} ]
]

{ #category : 'terms' }
LbParser >> stringTerm [
	^ super stringTerm ==> [ :value |
		| stringValue |
		stringValue := value copyFrom: 2 to: value size - 1.
		[ :aSignature :aDictionary |
			aSignature assertBuiltin: #strings.
			LbStringTerm value: stringValue signature: aSignature ] ]
]

{ #category : 'signature' }
LbParser >> subscriptOp [
	^ super subscriptOp ==> [ :nodes |
		| args |
		args := OrderedCollection with: nodes first.
		args addAll: (nodes fourth reject: [ :element | element = $, ]).
		{ LbSubscriptOperatorName new. args asArray } ]
]

{ #category : 'signature' }
LbParser >> subsort [
	^ super subsort
		==> [ :nodes | { nodes first first. nodes third first } ]
]

{ #category : 'axioms' }
LbParser >> subsortAxiom [
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

{ #category : 'signature' }
LbParser >> superscriptOp [
	^ super superscriptOp ==> [ :nodes |
		| args |
		args := OrderedCollection with: nodes first.
		args addAll: (nodes fourth reject: [ :element | element = $, ]).
		{ LbSuperscriptOperatorName new. args asArray } ]
]

{ #category : 'terms' }
LbParser >> term [
	^ super term  ==> [ :nodes |
		nodes size = 1
			ifTrue: [ nodes first ] "nonInfixTerm"
			ifFalse: [
				| name |
				"nodes contains the infix operator symbol followed by
				all the arguments. Example 'a + b + c' becomes
				{ '+'. a. b. c } with a b c already converted to blocks."
				name := LbInfixOperatorName for: nodes first asSymbol.
				(nodes allButFirst: 2)
					inject: nodes second
					into: [ :result :nextArg |
						self delayedTermWithOp: name args: { result . nextArg } ] ] ]
]

{ #category : 'signature' }
LbParser >> var [
	^ super var ==> [ :nodes |
		self assert: nodes first isEmpty. "Variables, only used for dependent sorts"
		{ nodes second. nodes fourth first } ]
]

{ #category : 'signature' }
LbParser >> varArg [
	^ super varArg ==> [ :nodes |
		{ nodes first. nodes third first } ]
]

{ #category : 'signature' }
LbParser >> zeroArgOp [
	^ super zeroArgOp ==> [ :idString |
		{ LbPrefixOperatorName for: idString. #() } ]
]

{ #category : 'terms' }
LbParser >> zeroArgTerm [
	^ super zeroArgTerm ==> [ :symbol |
		| name |
		name := LbPrefixOperatorName for: symbol.
		[ :aSignature :aDictionary |
			aSignature
				zeroArgTermNamed: name
				extraVariables: aDictionary ] ]
]
