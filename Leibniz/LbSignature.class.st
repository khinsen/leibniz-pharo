"
!!Operators, variables, and signatures

Operators and variables are the building blocks of terms (see ${class:name=LbTerm}$). A signature is the collection of all operators and variables declared in a ${class:name=LeibnizContext}$.

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
		'builtins'
	],
	#category : #'Leibniz-2-Signatures'
}

{ #category : #'instance creation' }
LbSignature class >> sortGraph: aSortGraph builtins: aSet operators: anOperatorDictionary variables: aVariableDictionary [
	^ self basicNew
			 initializeWithSortGraph: aSortGraph
								builtins: aSet
								operators: anOperatorDictionary
								variables: aVariableDictionary;
			 yourself.

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
			[ :each | each, ':', (variables at: each) name ]).

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
	^ aView tree
		title: 'Declarations' translated;
		priority: 3;
		items: [ | d |
			d := self declarations.
			{{'Sorts'. addEmptyChildList value: (d at: #sorts) }.
			 {'Subsorts'. addEmptyChildList value: (d at: #subsorts) }.
			 {'Variables'. addEmptyChildList value: (d at: #variables) }.
			 {'Operators'. addEmptyChildList value: (d at: #operators) } } ];
		itemStencil: LbCodeFont brLabelCellStencil;
		itemDataBinder: [ :eachLabel :eachItem |
			eachLabel text: eachItem first ];
		children: [ :each | each second ];
		expandOneLevel;
		yourself
]

{ #category : #inspecting }
LbSignature >> gtOperatorsFor: aView [
	<gtView>
	operators isEmpty ifTrue: [ ^ aView empty ].
	^ aView columnedTree
		title: 'Operators' translated;
		priority: 0;
		items: [ operators keys sorted ];
		column: 'Kind arity' do: [ :aColumn |
			aColumn cellStencil: LbCodeFont brLabelCellStencil;
			dataBinder: [ :eachLabel :eachItem |
				eachLabel text:
					((eachItem isKindOf: LbOperatorName)
						ifTrue: [ eachItem synopsis ]
						ifFalse: [ eachItem name printStringForArity: eachItem kindArity ]) ] ];
		column: 'Kind' do: [ :aColumn |
			aColumn cellStencil: LbCodeFont brLabelCellStencil;
			dataBinder: [ :eachLabel :eachItem |
				eachLabel text:
					((eachItem isKindOf: LbOperatorName)
						ifTrue: [ '' ]
						ifFalse: [ eachItem kind asLeibnizSyntaxString ]) ] ];
"		column: 'Kind' item: [:each |
			(each isKindOf: LbOperatorName)
				ifTrue: [ '' asRopedText ]
				ifFalse: [ each kind asLeibnizSyntaxString asRopedText fontName: (LbCodeFont defaultFamily) ] ];"
		children: [ :each |
			(each isKindOf: LbOperatorName)
				ifTrue: [ (operators at: each) values sorted: [:a :b | a kindArity size < b kindArity size] ]
				ifFalse: [ #() ] ];
		expandOneLevel;
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
		items: [ variables associations sorted: [ :a :b | a key < b key ]];
		column: 'Name' item: [ :each | each key ];
		column: 'Sort' item: [ :each | each value ];
		yourself
]

{ #category : #testing }
LbSignature >> hasBuiltin: aSymbol [
	^builtins includes: aSymbol
]

{ #category : #initializing }
LbSignature >> initializeWithSortGraph: aSortGraph builtins: aSet operators: anOperatorDictionary variables: aVariableDictionary [
	sortGraph := aSortGraph.
	builtins := aSet.
	operators := anOperatorDictionary.
	variables := aVariableDictionary.
	self beRecursivelyReadOnlyObject.
]

{ #category : #testing }
LbSignature >> isEmpty [
	^ sortGraph isEmpty and: [ operators isEmpty and: [ variables isEmpty ] ]
]

{ #category : #'term construction' }
LbSignature >> nonZeroArgTermNamed: aSymbol withArgs: aTermArray [
	| argSorts |
	argSorts := aTermArray collect: [ :t | t sort ].
	(self sortOfOp: aSymbol withArgSorts: argSorts)
		ifNil: [ ^ nil ]
		ifNotNil: [ :sort | ^ LbOpTerm symbol: aSymbol
													  args: aTermArray
													  sort: sort
													  forSignature: self ].

]

{ #category : #'term construction' }
LbSignature >> nonZeroArgTermNamed: aSymbol withArgs: aTermArray onError: aBlock [
	| result |
	result := self nonZeroArgTermNamed: aSymbol withArgs: aTermArray.
	result
		ifNil: [ ^ aBlock value: aSymbol value: (aTermArray collect: [ :t | t sort ]) ]
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
LbSignature >> sortOfOp: aSymbol withArgSorts: aSortArray [
	self flag: #todo.
	(self opNamed: aSymbol withArgs: aSortArray)
		ifNotNil: [ :op | ^ op sortForArgSorts: aSortArray ].
	"A somewhat hacky special case: if the signature includes the
    #truth builtin, it includes == for equality of arbitrary terms."
	((builtins includes: #truth) 
		and: [ aSymbol = #'_=='
				and: [ aSortArray size = 2 ] ])
		ifTrue: [ ^ #boolean ].
	^ nil

]

{ #category : #enumerating }
LbSignature >> withBuiltinsDo: aBlock [
	builtins do: aBlock
]

{ #category : #enumerating }
LbSignature >> withOperatorsDo: aBlock [
	operators keysAndValuesDo:
		[ :symbol :byKindArity |
		  byKindArity keysAndValuesDo:
			[ :kindArity :operator |
			  operator withRanksDo:
				[ :args :sort |
				  aBlock value: symbol value: args value: sort ]]]

]

{ #category : #enumerating }
LbSignature >> withVariablesDo: aBlock [
	variables associationsDo: [ :v | aBlock value: v key value: v value ]

]

{ #category : #'term construction' }
LbSignature >> zeroArgTermNamed: aSymbol [
	variables at: aSymbol
		ifPresent: [ :sort | ^ LbVarTerm symbol: aSymbol sort: sort forSignature: self ].
	(self sortOfOp: aSymbol withArgSorts: #())
		ifNil: [ ^ nil ]
		ifNotNil: [ :sort | ^ LbOpTerm symbol: aSymbol
													  args: #()
													  sort: sort
													  forSignature: self ].

]

{ #category : #'term construction' }
LbSignature >> zeroArgTermNamed: aSymbol extraVariables: aDictionary [
	aDictionary at: aSymbol
		ifPresent: [ :sort | ^ LbVarTerm symbol: aSymbol sort: sort forSignature: self ].
	^ self zeroArgTermNamed: aSymbol
]

{ #category : #'term construction' }
LbSignature >> zeroArgTermNamed: aSymbol extraVariables: aDictionary onError: aBlock [
	| result |
	result := self zeroArgTermNamed: aSymbol extraVariables: aDictionary.
	result ifNil: [ ^ aBlock value: aSymbol ] ifNotNil: [ ^ result ]

]

{ #category : #'term construction' }
LbSignature >> zeroArgTermNamed: aSymbol onError: aBlock [
	| result |
	result := self zeroArgTermNamed: aSymbol.
	result ifNil: [ ^ aBlock value: aSymbol ] ifNotNil: [ ^ result ]

]
