"
I build LeibnizSignatures from a sequence of operator and variable declarations.
"
Class {
	#name : #LbSignatureBuilder,
	#superclass : #Object,
	#instVars : [
		'sortGraph',
		'builtins',
		'operators',
		'variables'
	],
	#category : #'Leibniz-2-Signatures'
}

{ #category : #'instance creation' }
LbSignatureBuilder class >> sortGraph: aSortGraph [
	^self basicNew
			initializeWithSortGraph: aSortGraph;
			yourself.


]

{ #category : #adding }
LbSignatureBuilder >> addBuiltin: aSymbol [
	builtins add: aSymbol
]

{ #category : #adding }
LbSignatureBuilder >> addBuiltinsFromSignature: aSignature [
	aSignature withBuiltinsDo:
		[ :symbol |
		  self addBuiltin: symbol ].

]

{ #category : #adding }
LbSignatureBuilder >> addOp: anOpName ofSort: aSortSymbol [
	self addOp: anOpName withArgs: #() ofSort: aSortSymbol
]

{ #category : #adding }
LbSignatureBuilder >> addOp: anOpName withArgs: aSortNameArray ofSort: aSortName [
	| sort arity kindArity operator |
	aSortNameArray ifEmpty: [
		sort := variables at: anOpName asSymbol ifAbsent: nil.
		self assert: sort isNil
			 description: [ 'conflicting earlier variable definition with sort ', sort name asString ] ].
	arity := LbArity sortGraph: sortGraph
					 argSorts: (aSortNameArray collect: [ :name | sortGraph sortNamed: name ]).
	kindArity := arity liftToKindLevel.
	sort := sortGraph sortNamed: aSortName.
	operator := (operators at: anOpName
						   ifAbsentPut: [ Dictionary new ])
					at: kindArity
					ifAbsentPut: [ LbOperator name: anOpName
											  argKinds: kindArity
											  kind: sort kind ].
	operator addArity: arity withSort: sort.
]

{ #category : #adding }
LbSignatureBuilder >> addOpsFromSignature: aSignature [
	aSignature withOperatorsDo:
		[ :symbol :args :sort |
		  self addOp: symbol withArgs: args ofSort: sort ].

]

{ #category : #adding }
LbSignatureBuilder >> addSignature: aSignature includeVars: aBoolean [
	self addBuiltinsFromSignature: aSignature.
	self addOpsFromSignature: aSignature.
	aBoolean ifTrue: [ self addVarsFromSignature: aSignature ]

]

{ #category : #adding }
LbSignatureBuilder >> addVar: aSymbolOrOperatorName ofSort: aSortSymbol [
	| symbol op sort |
	symbol := aSymbolOrOperatorName asSymbol.
	op := operators at: symbol ifAbsent: nil.
	op ifNotNil:
		[ sort := op at: (LbArity sortGraph: sortGraph argSorts: #()) ifAbsent: nil.
		  self assert: sort isNil
				 description: 'conflicting earlier operator definition with sort', sort asString ].
	sort := variables at: symbol ifAbsentPut: aSortSymbol.
	self assert: sort = aSortSymbol
		  description: 'conflicting earlier variable definition with sort ', sort asString.
]

{ #category : #adding }
LbSignatureBuilder >> addVarsFromSignature: aSignature [
	aSignature withVariablesDo:
		[ :symbol :sort |
		  self addVar: symbol ofSort:  sort ].

]

{ #category : #initializing }
LbSignatureBuilder >> initializeWithSortGraph: aSortGraph [
	sortGraph := aSortGraph.
	builtins := Set new.
	operators := Dictionary new.
	variables := Dictionary new.
]

{ #category : #adding }
LbSignatureBuilder >> parseAndAddOp: aString [
	| opSpec op args sort argSorts |
	opSpec := LbSignatureParser parse: aString.
	op := opSpec first first.
	args := opSpec first second.
	sort := opSpec second.
	argSorts := args collect: [ :each | each last ].
	args select: [ :each | each size = 2 ]
		  thenDo: [ :each | self addVar: each first ofSort:  each second ].
	args ifEmpty: [ self addOp: op ofSort: sort ]
		  ifNotEmpty: [ self addOp: op withArgs: argSorts ofSort: sort ]
]

{ #category : #adding }
LbSignatureBuilder >> parseAndAddVar: aString [
	| var |
	var := LbSignatureParser parse: aString startingAt: #var.
	self addVar: var first ofSort: var second.
]

{ #category : #accessing }
LbSignatureBuilder >> signature [
	^ LbSignature sortGraph: sortGraph builtins: builtins operators: operators deepCopy variables: variables deepCopy.


]

{ #category : #private }
LbSignatureBuilder >> sortGraph: aSortGraph [
	sortGraph := aSortGraph

]
