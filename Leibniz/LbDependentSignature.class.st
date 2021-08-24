Class {
	#name : 'LbDependentSignature',
	#superclass : 'Object',
	#traits : 'EqualityThroughVariables',
	#classTraits : 'EqualityThroughVariables classTrait',
	#instVars : [
		'sortGraph',
		'variables',
		'operators',
		'builtins'
	],
	#category : 'Leibniz-7-DependentSorts'
}

{ #category : 'instace creation' }
LbDependentSignature class >> sortGraph: aSortGraph builtins: aSet operators: operatorDictionary variables: variableDictionary [
	^ self basicNew
		initializeWithSortGraph: aSortGraph
		builtins: aSet
		operators: operatorDictionary
		variables: variableDictionary;
		yourself
]

{ #category : 'lookup' }
LbDependentSignature >> assertBuiltin: aBuiltinSymbol [
	self
		assert: (builtins includes: aBuiltinSymbol)
		description: aBuiltinSymbol, ' are not defined in this signature'
]

{ #category : 'copying' }
LbDependentSignature >> copy [
	^ self
]

{ #category : 'copying' }
LbDependentSignature >> deepCopy [
	^ self
]

{ #category : 'inspecting' }
LbDependentSignature >> gtOperatorsFor: aView [
	<gtView>
	operators isEmpty ifTrue: [ ^ aView empty ].
	^ aView lbColumnedTree
		title: 'Operators' translated;
		priority: 0;
		items: [ operators keys sorted ];
		column: 'Kind arity' lbCode: [ :eachItem |
			(eachItem isKindOf: LbOperatorName)
				ifTrue: [ eachItem synopsis ]
				ifFalse: [ eachItem name printStringForArity: eachItem kindArity ]];
		column: 'Kind' lbCode: [ :eachItem |
			(eachItem isKindOf: LbOperatorName)
				ifTrue: [ '' ]
				ifFalse: [ eachItem kind asLeibnizSyntaxString ]];
		column: 'Ranks' text: [ :each |
			(each isKindOf: LbOperatorName)
				ifTrue: [ '' ]
				ifFalse: [ each size ] ];
		children: [ :each |
			(each isKindOf: LbOperatorName)
				ifTrue: [ (operators at: each) values
							sorted: [:a :b |
								a kindArity size < b kindArity size] ]
				ifFalse: [ #() ] ];
		expandItems:
			"Should be only the ops defined in the current context, but origin
			management isn't implemented yet."
			(operators associationsSelect: [ :each | true ])
			keys;
		yourself
]

{ #category : 'inspecting' }
LbDependentSignature >> gtVariablesFor: aView [
	<gtView>
	variables isEmpty ifTrue: [ ^ aView empty ].
	^ aView columnedList
		title: 'Variables' translated;
		priority: 1;
		items: [ variables associations sorted: [ :a :b | a key <= b key ]];
		send: [ :each |
			LbVariable
				named: each key
				sort: each value
				in: self
				origins: nil  ];
		column: 'Name' lbCode: [ :each | each key synopsis ];
		column: 'Sort' lbCode: [ :each | each value name ];
		yourself
]

{ #category : 'initialization' }
LbDependentSignature >> initializeWithSortGraph: aSortGraph builtins: aSet operators: operatorDictionary variables: variableDictionary [
	sortGraph := aSortGraph.
	builtins := aSet.
	operators := operatorDictionary.
	variables := variableDictionary.
	self beRecursivelyReadOnlyObject
]

{ #category : 'term construction' }
LbDependentSignature >> nonZeroArgTermNamed: anOpName withArgs: aTermArray [
	| argSorts |
	argSorts := aTermArray collect: #sort.
	(self sortOfOp: anOpName withArgSorts: argSorts)
		ifNil: [ ^ nil ]
		ifNotNil: [ :sort |
			^ LbOpTerm
				name: anOpName
				args: aTermArray
				sort: sort
				signature: self ]
]

{ #category : 'lookup' }
LbDependentSignature >> opNamed: anOpName withArgs: aSortArray [
	^ operators at: anOpName
		ifPresent: [ :ops |
			| arity kindArity |
			arity := LbDependentArity sortGraph: sortGraph argSortPatterns: aSortArray.
			kindArity := arity liftToKinds.
			ops at: kindArity ifAbsent: [ nil ] ]
		ifAbsent: [ nil ].
]

{ #category : 'term construction' }
LbDependentSignature >> parseTerm: aString [
	| parsedTerm |
	parsedTerm := (LbDependentSignatureParser newStartingAt: #termEnd)
		parse: aString.
	parsedTerm isPetit2Failure ifTrue:
		[ self error: parsedTerm message, ' after ',
				 (aString sliceFrom: 1 to: parsedTerm position) ].
	^ parsedTerm value: self value: Dictionary new
]

{ #category : 'lookup' }
LbDependentSignature >> sortNamed: aSymbol [
	self flag: #legacy.
	^ sortGraph sortNamed: aSymbol
]

{ #category : 'lookup' }
LbDependentSignature >> sortOfOp: anOpName withArgSorts: aSortArray [
	(self opNamed: anOpName withArgs: aSortArray)
		ifNotNil: [ :op | ^ op sortPatternForArgSortPatterns: aSortArray ].
	"A somewhat hacky special case: if the signature includes the
    #truth builtin, it also includes == for testing arbitrary terms
    for syntactic identity."
	((builtins includes: #truth) 
		and: [ anOpName = (LbInfixOperatorName for: '==')
				and: [ aSortArray size = 2 ] ])
		ifTrue: [ ^ sortGraph sortNamed: #boolean ].
	^ nil
]

{ #category : 'term construction' }
LbDependentSignature >> zeroArgTermNamed: anOpName [
	variables at: anOpName
		ifPresent: [ :sort | ^ LbVarTerm name: anOpName sort: sort signature: self ].
	(self sortOfOp: anOpName withArgSorts: #())
		ifNil: [ ^ nil ]
		ifNotNil: [ :sort |
			^ LbOpTerm
				name: anOpName
				args: #()
				sort: sort
				signature: self ]
]

{ #category : 'term construction' }
LbDependentSignature >> zeroArgTermNamed: anOpName extraVariables: aDictionary [
	aDictionary at: anOpName
		ifPresent: [ :sort | ^ LbVarTerm name: anOpName sort: sort signature: self ].
	^ self zeroArgTermNamed: anOpName
]
