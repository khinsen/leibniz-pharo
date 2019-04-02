"
!!Operators, variables, and signatures

Operators and variables are the building blocks of terms (see ${class:name=LeibnizTerm}$). A signature is the collection of all operators and variables declared in a ${class:name=LeibnizContext}$.

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
	#name : #LeibnizSignature,
	#superclass : #Object,
	#instVars : [
		'sortGraph',
		'operators',
		'variables',
		'builtins'
	],
	#category : #'Leibniz-2-Signatures'
}

{ #category : #'instance creation' }
LeibnizSignature class >> sortGraph: aSortGraph builtins: aSet operators: anOperatorDictionary variables: aVariableDictionary [
	^ self basicNew
			 initializeWithSortGraph: aSortGraph
								builtins: aSet
								operators: anOperatorDictionary
								variables: aVariableDictionary;
			 yourself.

]

{ #category : #inspecting }
LeibnizSignature >> childrenInInspector [
	^Array new.
]

{ #category : #copying }
LeibnizSignature >> copy [
	^self
]

{ #category : #copying }
LeibnizSignature >> deepCopy [
	^self
]

{ #category : #inspecting }
LeibnizSignature >> gtInspectorOperatorsIn: composite [
	"Show a list of all variables"

	<gtInspectorPresentationOrder: 0>
	composite fastTable 
		title: 'Operators';
		display: [ operators flatCollect: [ :each | each values ] ];
		column: 'Operator' evaluated: #title;
		column: 'Kind' evaluated:
			[ :each | String streamContents: [ :s | (each kind printAsLeibnizSyntaxOn: s) ] ];
		column: 'Ranks' evaluated: [ :each | each size asString ];
		when: [ operators isNotEmpty ]
]

{ #category : #inspecting }
LeibnizSignature >> gtInspectorVariablesIn: composite [
	"Show a list of all variables"

	<gtInspectorPresentationOrder: 1>
	composite fastTable 
		title: 'Variables';
		display: [ variables associations sorted: [ :v1 :v2 | v1 key < v2 key ] ] ;
		column: 'Name' evaluated: [ :each | each key asString ];
		column: 'Sort' evaluated: [ :each | each value asString ];
		when: [ variables isNotEmpty ]
]

{ #category : #testing }
LeibnizSignature >> hasBuiltin: aSymbol [
	^builtins includes: aSymbol
]

{ #category : #initializing }
LeibnizSignature >> initializeWithSortGraph: aSortGraph builtins: aSet operators: anOperatorDictionary variables: aVariableDictionary [
	sortGraph := aSortGraph.
	builtins := aSet.
	operators := anOperatorDictionary.
	variables := aVariableDictionary.
	self beRecursivelyReadOnlyObject.

]

{ #category : #'term construction' }
LeibnizSignature >> nonZeroArgTermNamed: aSymbol withArgs: aTermArray [
	| argSorts |
	argSorts := aTermArray collect: [ :t | t sort ].
	(self sortOfOp: aSymbol withArgSorts: argSorts)
		ifNil: [ ^ nil ]
		ifNotNil: [ :sort | ^ LeibnizOpTerm symbol: aSymbol
													  args: aTermArray
													  sort: sort
													  forSignature: self ].

]

{ #category : #'term construction' }
LeibnizSignature >> nonZeroArgTermNamed: aSymbol withArgs: aTermArray onError: aBlock [
	| result |
	result := self nonZeroArgTermNamed: aSymbol withArgs: aTermArray.
	result
		ifNil: [ ^ aBlock value: aSymbol value: (aTermArray collect: [ :t | t sort ]) ]
		ifNotNil: [ ^ result ]

]

{ #category : #accessing }
LeibnizSignature >> numberOfOperators [
	^operators size
]

{ #category : #accessing }
LeibnizSignature >> numberOfVariables [
	^variables size
]

{ #category : #accessing }
LeibnizSignature >> opNamed: aSymbol withArgs: aSortArray [
	| kindArity |
	kindArity := LeibnizArity sortGraph: sortGraph
									  argSortConstraints: (aSortArray collect:
																	[ :s | LeibnizKindConstraint sortGraph: sortGraph kind: (sortGraph kindOf: s)]).
	operators at: aSymbol
		ifPresent: [ :ops | ops at: kindArity
									ifPresent: [ :op | ^ op ]
									ifAbsent: [ ^ nil ]]
		ifAbsent: [ ^ nil ].

]

{ #category : #accessing }
LeibnizSignature >> ranksMatchingfOp: aSymbol withArgs: aSortArray [
	(self opNamed: aSymbol withArgs: aSortArray)
		ifNil: [ ^ OrderedCollection new. ]
		ifNotNil: [ :op | ^ op ranksMatchingArgSorts: aSortArray]
]

{ #category : #accessing }
LeibnizSignature >> sortGraph [
	^sortGraph
]

{ #category : #accessing }
LeibnizSignature >> sortOfOp: aSymbol withArgSorts: aSortArray [
	(self opNamed: aSymbol withArgs: aSortArray)
		ifNil: [ ^ nil ]
		ifNotNil: [ :op | ^ op sortForArgSorts: aSortArray ]

]

{ #category : #inspecting }
LeibnizSignature >> title [
	^'signature'

]

{ #category : #enumerating }
LeibnizSignature >> withBuiltinsDo: aBlock [
	builtins do: aBlock
]

{ #category : #enumerating }
LeibnizSignature >> withOperatorsDo: aBlock [
	operators keysAndValuesDo:
		[ :symbol :byKindArity |
		  byKindArity keysAndValuesDo:
			[ :kindArity :operator |
			  operator withRanksDo:
				[ :args :sort |
				  aBlock value: symbol value: args asArgSorts value: sort ]]]

]

{ #category : #enumerating }
LeibnizSignature >> withVariablesDo: aBlock [
	variables associationsDo: [ :v | aBlock value: v key value: v value ]

]

{ #category : #'term construction' }
LeibnizSignature >> zeroArgTermNamed: aSymbol [
	variables at: aSymbol
		ifPresent: [ :sort | ^ LeibnizVarTerm symbol: aSymbol sort: sort forSignature: self ].
	(self sortOfOp: aSymbol withArgSorts: #())
		ifNil: [ ^ nil ]
		ifNotNil: [ :sort | ^ LeibnizOpTerm symbol: aSymbol
													  args: #()
													  sort: sort
													  forSignature: self ].

]

{ #category : #'term construction' }
LeibnizSignature >> zeroArgTermNamed: aSymbol onError: aBlock [
	| result |
	result := self zeroArgTermNamed: aSymbol.
	result ifNil: [ ^ aBlock value: aSymbol ] ifNotNil: [ ^ result ]

]
