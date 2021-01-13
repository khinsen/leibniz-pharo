"
!!Operators, variables, and signatures

Operators and variables are the building blocks of terms (see ${class:name=LbTerm}$). A signature is the collection of all operators and variables declared in a ${class:name=LbContext}$.

!!!Operators

Operators are used to construct terms that represent specific values. An operator is defined by its ''name'', its ''arity'', and its ''sort''. The arity is a list of sorts, possibly empty, that defines which sorts valid ''arguments'' must have. The combination of arity and sort is called the operator's ''rank''.

From a syntactical point of view, Leibniz has ''prefix'', ''infix'', and ''special'' operators. Infix operators must have exactly two arguments. There are no operator precedence rules, therefore parentheses are obligatory everywhere to make the order of application unambiguous. The only exception is repeated use of the same operator.

Example:
[[[
boolean := LeibnizExamples new contextNamed: 'boolean'.
boolean signature
]]]

!!!Variables

Variables are used in patterns that match different terms. A variable is defined by its ''name'' and its ''sort''. In pattern matching, a variable matches any term that is compatible with its sort.

"
Class {
	#name : #LbSignature,
	#superclass : #Object,
	#traits : 'EqualityThroughVariables',
	#classTraits : 'EqualityThroughVariables classTrait',
	#instVars : [
		'sortGraph',
		'operators',
		'variables',
		'builtins',
		'origins'
	],
	#category : #'Leibniz-2-Signatures'
}

{ #category : #'instance creation' }
LbSignature class >> sortGraph: aSortGraph builtins: aSet operators: anOperatorDictionary variables: aVariableDictionary origins: anOriginDictionary [
	^ self basicNew
			 initializeWithSortGraph: aSortGraph
								builtins: aSet
								operators: anOperatorDictionary
								variables: aVariableDictionary
								origins: anOriginDictionary;
			 yourself
]

{ #category : #asserting }
LbSignature >> assertBuiltin: aBuiltinSymbol [
	self assert: (builtins includes: aBuiltinSymbol) description: aBuiltinSymbol, ' are not defined in this signature'
]

{ #category : #'term construction' }
LbSignature >> atomicTerm: aValue [
	^ aValue lbAtomicTermClass value: aValue signature: self
]

{ #category : #copying }
LbSignature >> copy [
	^self
]

{ #category : #accessing }
LbSignature >> declarations [
	| declarations opDecls |
	declarations := self sortGraph declarations.
	declarations at: #variables put:
		(variables keys sorted collect:
			[ :each | each synopsis, ':', (variables at: each) name ]).

	opDecls := OrderedCollection new.
	operators keys sorted do: [ :eachName |
		| kindArities |
		kindArities := (operators at: eachName) keys sorted: [ :x :y | x sortBefore: y ].
		kindArities do: [ :eachKArity |
			opDecls addAll: ((operators at: eachName) at: eachKArity) declarations ] ].
	declarations at: #operators put: opDecls asArray.
	^ declarations
]

{ #category : #copying }
LbSignature >> deepCopy [
	^self
]

{ #category : #inspecting }
LbSignature >> gtDeclarationsFor: aView [
	<gtView>
	| addEmptyChildList |
	self isEmpty ifTrue: [ ^ aView empty ].
	addEmptyChildList :=
		[ :aList | aList collect: [ :each | {each. #()} ]].
	^ aView lbTree
		title: 'Declarations' translated;
		priority: 3;
		items: [ | d categories |
			d := self declarations.
			categories := OrderedCollection new.
			#(sorts subsorts variables operators) do: [ :each |
				(d at: each) ifNotEmpty: [
					categories add: {
						each asString capitalized.
						(d at: each) collect: [ :aString |
							{ aString. #() } ] } ] ].
			categories ];
		itemLbCode: #first;
		children: #second;
		send: #first;
		expandItems: #('Variables' 'Operators');
		yourself
]

{ #category : #inspecting }
LbSignature >> gtOperatorsFor: aView [
	<gtView>
	operators ifEmpty: [ ^ aView empty ].
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
				ifTrue: [ '']
				ifFalse: [ each size asString ] ];
		children: [ :each |
			(each isKindOf: LbOperatorName)
				ifTrue: [ (operators at: each) values sorted: [:a :b | a kindArity size < b kindArity size] ]
				ifFalse: [ #() ] ];
		expandItems:
			(operators associationsSelect: [ :each |
				each  value values first origins onlyIncludes not ])
			keys;
		yourself
]

{ #category : #inspecting }
LbSignature >> gtSortGraphFor: aView [ 
	<gtView>
	^ aView forward
		title: 'Sort graph';
		priority: 2;
		object: [ self sortGraph ];
		view: #gtGraphFor:
]

{ #category : #inspecting }
LbSignature >> gtVariablesFor: aView [
	<gtView>
	variables isEmpty ifTrue: [ ^ aView empty ].
	^ aView columnedList
		title: 'Variables' translated;
		priority: 1;
		items: [ variables associations sorted: [ :a :b | a key <= b key ]];
		send: [ :each | LbVariable named: each key sort: each value in: self origins: (origins at: each key) ];
		column: 'Name' lbCode: [ :each | each key synopsis ];
		column: 'Sort' lbCode: [ :each | each value name ];
		yourself
]

{ #category : #testing }
LbSignature >> hasBuiltin: aSymbol [
	^builtins includes: aSymbol
]

{ #category : #initializing }
LbSignature >> initializeWithSortGraph: aSortGraph builtins: aSet operators: anOperatorDictionary variables: aVariableDictionary origins: anOriginDictionary [
	sortGraph := aSortGraph.
	builtins := aSet.
	operators := anOperatorDictionary.
	variables := aVariableDictionary.
	origins := anOriginDictionary.
	self beRecursivelyReadOnlyObject
]

{ #category : #testing }
LbSignature >> isEmpty [
	^ sortGraph isEmpty and: [ operators isEmpty and: [ variables isEmpty ] ]
]

{ #category : #'term construction' }
LbSignature >> nonZeroArgTermNamed: anOpName withArgs: aTermArray [
	| argSorts |
	argSorts := aTermArray collect: [ :t | t sort ].
	(self sortOfOp: anOpName withArgSorts: argSorts)
		ifNil: [ ^ nil ]
		ifNotNil: [ :sort |
			^ LbOpTerm name: anOpName
					   args: aTermArray
					   sort: sort
					   signature: self ]
]

{ #category : #'term construction' }
LbSignature >> nonZeroArgTermNamed: anOpName withArgs: aTermArray onError: aBlock [
	| result |
	result := self nonZeroArgTermNamed: anOpName withArgs: aTermArray.
	result
		ifNil: [ ^ aBlock value: anOpName value: (aTermArray collect: [ :t | t sort ]) ]
		ifNotNil: [ ^ result ]
]

{ #category : #accessing }
LbSignature >> numberOfOperators [
	^operators size
]

{ #category : #accessing }
LbSignature >> numberOfVariables [
	^variables size
]

{ #category : #accessing }
LbSignature >> opNamed: anOpName withArgs: aSortArray [
	| kindArity |
	kindArity := (LbArity sortGraph: sortGraph
						  argSorts: aSortArray)
					liftToKindLevel.
	^ operators at: anOpName
		ifPresent: [ :ops | ops at: kindArity
								ifAbsent: [ nil ]]
		ifAbsent: [ nil ].
]

{ #category : #accessing }
LbSignature >> opsOfKind: aKind [
	| ops |
	ops := Set new.
	self withOperatorsDo: [ :eachOp |
		(eachOp kind = aKind)
			ifTrue: [ ops add: eachOp ] ].
	^ ops
]

{ #category : #'asset construction' }
LbSignature >> parseRule: aString [
	| rule |
	rule := (LbRuleParser signature: self)
				parse: aString
				onError: [ :message :position |
					self error: 'Parse error for: ', aString, ' (', message, ')'].
	^ rule
]

{ #category : #'term construction' }
LbSignature >> parseTerm: aString [
	^ self parseTerm: aString extraVariables: Dictionary new
]

{ #category : #'term construction' }
LbSignature >> parseTerm: aString extraVariables: aDictionary [
	^ (LbTermParser signature: self extraVariables: aDictionary)
		parse: aString
]

{ #category : #accessing }
LbSignature >> ranksMatchingfOp: anOpName withArgs: aSortArray [
	(self opNamed: anOpName withArgs: aSortArray)
		ifNil: [ ^ OrderedCollection new. ]
		ifNotNil: [ :op | ^ op ranksMatchingArgSorts: aSortArray]
]

{ #category : #accessing }
LbSignature >> sortGraph [
	^sortGraph
]

{ #category : #accessing }
LbSignature >> sortNamed: aSymbol [
	^ sortGraph sortNamed: aSymbol
]

{ #category : #accessing }
LbSignature >> sortOfOp: anOpName withArgSorts: aSortArray [
	(self opNamed: anOpName withArgs: aSortArray)
		ifNotNil: [ :op | ^ op sortForArgSorts: aSortArray ].
	"A somewhat hacky special case: if the signature includes the
    #truth builtin, it includes == for equality of arbitrary terms."
	((builtins includes: #truth) 
		and: [ anOpName = (LbInfixOperatorName for: '==')
				and: [ aSortArray size = 2 ] ])
		ifTrue: [ ^ sortGraph sortNamed: #boolean ].
	^ nil
]

{ #category : #enumerating }
LbSignature >> withBuiltinsDo: aBlock [
	builtins do: aBlock
]

{ #category : #enumerating }
LbSignature >> withOperatorsDo: aBlock [
	operators do: [ :aDictionary |
		aDictionary do: [ :anOperator |
			aBlock value: anOperator ] ]
]

{ #category : #enumerating }
LbSignature >> withVariablesDo: aBlock [
	variables associationsDo: [ :v |
		aBlock value: (LbVariable
						named: v key
						sort: v value
						in: self
						origins: (origins at: v key )) ]
]

{ #category : #'term construction' }
LbSignature >> zeroArgTermNamed: anOpName [
	variables at: anOpName
		ifPresent: [ :sort | ^ LbVarTerm name: anOpName sort: sort signature: self ].
	(self sortOfOp: anOpName withArgSorts: #())
		ifNil: [ ^ nil ]
		ifNotNil: [ :sort | ^ LbOpTerm name: anOpName
									   args: #()
									   sort: sort
									   signature: self ]
]

{ #category : #'term construction' }
LbSignature >> zeroArgTermNamed: anOpName extraVariables: aDictionary [
	aDictionary at: anOpName
		ifPresent: [ :sort | ^ LbVarTerm name: anOpName sort: sort signature: self ].
	^ self zeroArgTermNamed: anOpName
]

{ #category : #'term construction' }
LbSignature >> zeroArgTermNamed: anOpName extraVariables: aDictionary onError: aBlock [
	| result |
	result := self zeroArgTermNamed: anOpName extraVariables: aDictionary.
	result ifNil: [ ^ aBlock value: anOpName ] ifNotNil: [ ^ result ]
]

{ #category : #'term construction' }
LbSignature >> zeroArgTermNamed: aSymbol onError: aBlock [
	| result |
	result := self zeroArgTermNamed: aSymbol.
	result ifNil: [ ^ aBlock value: aSymbol ] ifNotNil: [ ^ result ]

]
