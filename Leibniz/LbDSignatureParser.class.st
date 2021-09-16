Class {
	#name : 'LbDSignatureParser',
	#superclass : 'LbGrammarSignaturesAndTerms',
	#category : 'Leibniz-7-DependentSorts'
}

{ #category : 'accessing' }
LbDSignatureParser class >> signature: aSignature extraVariables: aDictionary [
	| parser |
	parser := self newStartingAt: self startSymbol.
	parser signature: aSignature.
	parser extraVariables: aDictionary.
	^ parser
]

{ #category : 'productions - signature' }
LbDSignatureParser >> bracketOp [
	^ super bracketOp
		==> [ :nodes |
				| args |
				args := OrderedCollection with: nodes first.
				args addAll: (nodes third reject: [ :element | element = $,]).
				{ LbBracketOperatorName new. args asArray } ]
]

{ #category : 'term construction' }
LbDSignatureParser >> delayedTermWithOp: anOpName args: anArgList [
	^ [ :aSignature :aDictionary |
		aSignature
			nonZeroArgTermNamed: anOpName
			withArgs: (anArgList collect: [ :each |
				each cull: aSignature cull: aDictionary ]) ]
]

{ #category : 'productions - signature' }
LbDSignatureParser >> forAllClause [
	^ super forAllClause ==> [ :nodes |
		| varName sortName |
		varName := nodes second asSymbol asLbOperatorName.
		sortName := nodes fourth first asSymbol.
		[ :aSignature :aDictionary |
			varName -> (aSignature sortNamed: sortName) ] ]
]

{ #category : 'productions - term' }
LbDSignatureParser >> fpNumberTerm [
	^ super fpNumberTerm ==> [ :value | 
		"Converting the string to a float requires some trickery:
		 - Pharo doesn't allow a dot followed by an exponent without any fractional part.
			Workaround: replace '.e' by '.0e'
		 - In Pharo, a number with an exponent but without a fractional part is an integer, not a float.
		Workaround: convert the converted string explicitly to a float."
		| floatValue |
		floatValue := (value copyReplaceAll: '.e' with: '.0e') asNumber asFloat.
		[ :aSignature |
			aSignature assertBuiltin: #fpNumbers.
			LbFPNumberTerm value: floatValue signature: aSignature ] ]
]

{ #category : 'productions - signature' }
LbDSignatureParser >> infixOp [
	^ super infixOp ==> [ :nodes |
		{ LbInfixOperatorName for: nodes second. { nodes first. nodes third } } ]
]

{ #category : 'productions - term' }
LbDSignatureParser >> integerTerm [
	^ super integerTerm ==> [ :value |
		| intValue |
		intValue := value asNumber.
		[ :aSignature |
			aSignature assertBuiltin: #integers.
			LbIntegerTerm value: intValue signature: aSignature ] ]
]

{ #category : 'productions - term' }
LbDSignatureParser >> nonInfixTerm [
	^ super nonInfixTerm ==> [ :nodes |
		nodes second
			ifNil: [ nodes first ] "simpleTerm, no suffix"
			ifNotNil: [
				| name args |
				name := LbOperatorName fromInternalSymbol: nodes second first.
				args := nodes second second copyWithFirst: nodes first.
				self delayedTermWithOp: name args: args ] ]
]

{ #category : 'productions - signature' }
LbDSignatureParser >> op [
	^ super op ==> [ :nodes |
		| variables opName opArgs opSort |
		variables := nodes first.
		opName := nodes second first.
		opArgs := nodes second second.
		opSort := nodes fourth.
		[ :aSignature :aDictionary |
			| allVariables |
			allVariables := aDictionary copy.
			variables do: [ :each |
				| newVar |
				newVar := each value: aSignature value: aDictionary.
				allVariables at: newVar key put: newVar value ].
			{
				opName.
				opArgs collect: [ :each |
					each cull: aSignature cull: allVariables ].
				opSort cull: aSignature cull: allVariables
			} ] ]
]

{ #category : 'productions - signature' }
LbDSignatureParser >> prefixOp [
	^ super prefixOp ==> [ :nodes |
		{
			LbPrefixOperatorName for: nodes first.
			nodes third reject: [ :element | element = $, ]
		} ]
]

{ #category : 'productions - term' }
LbDSignatureParser >> prefixOpTerm [
	^ super prefixOpTerm ==> [ :nodes |
		| name args |
		name := LbPrefixOperatorName for: nodes first.
		args := (nodes at: 3) reject: [ :element | element = $, ].
		self delayedTermWithOp: name args: args ]
]

{ #category : 'productions - term' }
LbDSignatureParser >> rationalNumberTerm [
	^ super rationalNumberTerm==> [ :value |
		| rationalValue |
		rationalValue := Fraction readFromString: value.
		[ :aSignature |
			aSignature assertBuiltin: #rationalNumbers.
			LbRationalNumberTerm value: rationalValue signature: aSignature ] ]
]

{ #category : 'productions - signature' }
LbDSignatureParser >> sort [
	^ super sort ==> [ :id |
		{ id } ]
]

{ #category : 'productions - term' }
LbDSignatureParser >> stringTerm [
	^ super stringTerm ==> [ :value |
		| stringValue |
		stringValue := value copyFrom: 2 to: value size - 1.
		[ :aSignature |
			aSignature assertBuiltin: #strings.
			LbStringTerm value: stringValue signature: aSignature ] ]
]

{ #category : 'productions - signature' }
LbDSignatureParser >> subscriptOp [
	^ super subscriptOp ==> [ :nodes |
		| args |
		args := OrderedCollection with: nodes first.
		args addAll: (nodes fourth reject: [ :element | element = $, ]).
		{ LbSubscriptOperatorName new. args asArray } ]
]

{ #category : 'productions - signature' }
LbDSignatureParser >> superscriptOp [
	^ super superscriptOp ==> [ :nodes |
		| args |
		args := OrderedCollection with: nodes first.
		args addAll: (nodes fourth reject: [ :element | element = $, ]).
		{ LbSuperscriptOperatorName new. args asArray } ]
]

{ #category : 'productions - term' }
LbDSignatureParser >> term [
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

{ #category : 'accessing' }
LbDSignatureParser >> termEnd [
	^ term end
]

{ #category : 'productions - signature' }
LbDSignatureParser >> var [
	^ super var ==> [ :nodes |
		| variables |
		variables := nodes first.
		[ :aSignature :aDictionary |
			| allVariables |
			allVariables := aDictionary copy.
			variables do: [ :each |
				| newVar |
				newVar := each value: aSignature value: aDictionary.
				allVariables at: newVar key put: newVar value ].
			{ nodes second. nodes fourth cull: aSignature cull: allVariables } ] ]
]

{ #category : 'productions - signature' }
LbDSignatureParser >> zeroArgOp [
	^ super zeroArgOp ==> [ :idString |
		{ LbPrefixOperatorName for: idString. #() } ]
]

{ #category : 'productions - term' }
LbDSignatureParser >> zeroArgTerm [
	^ super zeroArgTerm ==> [ :symbol |
		| name |
		name := LbPrefixOperatorName for: symbol.
		[ :aSignature :aDictionary |
			aSignature
				zeroArgTermNamed: name
				extraVariables: aDictionary ] ]
]
