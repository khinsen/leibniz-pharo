Class {
	#name : 'LbDSignature',
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
LbDSignature class >> sortGraph: aSortGraph builtins: aSet operators: operatorDictionary variables: variableDictionary [
	^ self basicNew
		initializeWithSortGraph: aSortGraph
		builtins: aSet
		operators: operatorDictionary
		variables: variableDictionary;
		yourself
]

{ #category : 'lookup' }
LbDSignature >> assertBuiltin: aBuiltinSymbol [
	self
		assert: (builtins includes: aBuiltinSymbol)
		description: aBuiltinSymbol, ' are not defined in this signature'
]

{ #category : 'copying' }
LbDSignature >> copy [
	^ self
]

{ #category : 'copying' }
LbDSignature >> deepCopy [
	^ self
]

{ #category : 'inspecting' }
LbDSignature >> gtOperatorsFor: aView [
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
				ifFalse: [ eachItem kind asLeibnizSyntaxString ]]
			weight: 0.3;
		column: 'Ranks' text: [ :each |
			(each isKindOf: LbOperatorName)
				ifTrue: [ '' ]
				ifFalse: [ each size ] ]
			weight: 0.2;
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
LbDSignature >> gtSortGraphFor: aView [ 
	<gtView>
	^ aView forward
		title: 'Sort graph';
		priority: 2;
		object: [ self sortGraph ];
		view: #gtGraphFor:
]

{ #category : 'inspecting' }
LbDSignature >> gtVariablesFor: aView [
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
		column: 'Sort' lbCode: [ :each | each value asLeibnizSyntaxString ];
		yourself
]

{ #category : 'initialization' }
LbDSignature >> initializeWithSortGraph: aSortGraph builtins: aSet operators: operatorDictionary variables: variableDictionary [
	sortGraph := aSortGraph.
	builtins := aSet.
	operators := operatorDictionary.
	variables := variableDictionary.
	self beRecursivelyReadOnlyObject
]

{ #category : 'term construction' }
LbDSignature >> nonZeroArgTermNamed: anOpName withArgs: aTermArray [
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
LbDSignature >> opNamed: anOpName withArgs: aSortArray [
	operators at: anOpName
		ifPresent: [ :ops |
			| arity kindArity |
			arity := LbDArity sortGraph: sortGraph argSortPatterns: aSortArray.
			kindArity := arity liftToKinds.
			kindArity withUniversalVariantsDo: [ :eachArity |
				ops at: eachArity ifPresent: [ :op | ^ op ] ] ].
	^ nil
]

{ #category : 'term construction' }
LbDSignature >> parseTerm: aString [
	| parsedTerm |
	parsedTerm := (LbDSignatureParser newStartingAt: #termEnd)
		parse: aString.
	parsedTerm isPetit2Failure ifTrue:
		[ self error: parsedTerm message, ' after ',
				 (aString sliceFrom: 1 to: parsedTerm position) ].
	^ parsedTerm value: self value: Dictionary new
]

{ #category : 'accessing' }
LbDSignature >> sortGraph [
	^ sortGraph
]

{ #category : 'lookup' }
LbDSignature >> sortNamed: aSymbol [
	self flag: #legacy.
	^ sortGraph sortNamed: aSymbol
]

{ #category : 'lookup' }
LbDSignature >> sortOfOp: anOpName withArgSorts: aSortArray [
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

{ #category : 'enumerating' }
LbDSignature >> withBuiltinsDo: aBlock [
	builtins do: aBlock
]

{ #category : 'enumerating' }
LbDSignature >> withOperatorsDo: aBlock [
	operators do: [ :aDictionary |
		aDictionary do: [ :anOperator |
			aBlock value: anOperator ] ]
]

{ #category : 'enumerating' }
LbDSignature >> withVariablesDo: aBlock [
	variables associationsDo: [ :v |
		aBlock value: (LbVariable
						named: v key
						sort: v value
						in: self
						origins: nil) ]
]

{ #category : 'term construction' }
LbDSignature >> zeroArgTermNamed: anOpName [
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
LbDSignature >> zeroArgTermNamed: anOpName extraVariables: aDictionary [
	aDictionary at: anOpName
		ifPresent: [ :sort | ^ LbVarTerm name: anOpName sort: sort signature: self ].
	^ self zeroArgTermNamed: anOpName
]
