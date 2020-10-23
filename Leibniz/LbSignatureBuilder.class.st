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
LbSignatureBuilder >> addOp: anOpName ofSort: aSort [
	self addOp: anOpName withArgs: #() ofSort: aSort
]

{ #category : #adding }
LbSignatureBuilder >> addOp: anOpName withArgs: aSortArray ofSort: aSort [
	| arity kindArity operator |
	aSortArray ifEmpty: [
		| sort |
		sort := variables at: anOpName asSymbol ifAbsent: nil.
		self assert: sort isNil
			 description: [ 'conflicting earlier variable definition with sort ', sort name asString ] ].
	arity := LbArity sortGraph: sortGraph argSorts: aSortArray.
	kindArity := arity liftToKindLevel.
	operator := (operators at: anOpName
						   ifAbsentPut: [ Dictionary new ])
					at: kindArity
					ifAbsentPut: [ LbOperator name: anOpName
											  argKinds: kindArity
											  kind: aSort kind ].
	operator addArity: arity withSort: aSort.
]

{ #category : #adding }
LbSignatureBuilder >> addOpsFromSignature: aSignature [
	aSignature withOperatorsDo:
		[ :name :args :sort |
		  | adoptedArgs |
		  adoptedArgs := args collect: [ :each | self adoptSort: each ].
		  self addOp: name withArgs: adoptedArgs ofSort: (self adoptSort: sort) ]
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

{ #category : #converting }
LbSignatureBuilder >> adoptSort: aSort [
	"Adopt a sort from a foreign sort graph, by name"
	^ sortGraph sortNamed: aSort name
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
	sort := sortGraph sortNamed: opSpec second.
	argSorts := args collect: [ :each | sortGraph sortNamed: each last ].
	args select: [ :each | each size = 2 ]
		  thenDo: [ :each | self addVar: each first ofSort:  each second ].
	args ifEmpty: [ self addOp: op ofSort: sort ]
		  ifNotEmpty: [ self addOp: op withArgs: argSorts ofSort: sort ]
]

{ #category : #adding }
LbSignatureBuilder >> parseAndAddVar: aString [
	| var |
	var := LbSignatureParser parse: aString startingAt: #var.
	self addVar: var first ofSort: (sortGraph sortNamed: var second).
]

{ #category : #accessing }
LbSignatureBuilder >> signature [
	^ LbSignature sortGraph: sortGraph builtins: builtins operators: operators deepCopy variables: variables deepCopy.


]

{ #category : #private }
LbSignatureBuilder >> sortGraph: aSortGraph [
	sortGraph := aSortGraph

]
