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
			yourself
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
		sort := variables at: anOpName ifAbsent: nil.
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
LbSignatureBuilder >> addVar: anOpName ofSort: aSort [
	| op sort |
	self assert: aSort sortGraph == sortGraph.
	op := operators at: anOpName ifAbsent: nil.
	op ifNotNil:
		[ sort := op at: (LbArity sortGraph: sortGraph argSorts: #()) ifAbsent: nil.
		  self assert: sort isNil
				description: 'conflicting earlier operator definition with sort', sort asString ].
	sort := variables at: anOpName ifAbsentPut: aSort.
	self assert: sort = aSort
		  description: 'conflicting earlier variable definition with sort ', sort asString.
]

{ #category : #adding }
LbSignatureBuilder >> addVarsFromSignature: aSignature [
	aSignature withVariablesDo:
		[ :symbol :sort |
		  self addVar: symbol ofSort:  (self adoptSort: sort) ].
]

{ #category : #converting }
LbSignatureBuilder >> adoptSort: aSort [
	"Adopt a sort from a foreign sort graph, by name"
	^ sortGraph sortNamed: aSort name
]

{ #category : #inspecting }
LbSignatureBuilder >> gtDeclarationsFor: aView [ 
	<gtView>
	^ aView forward
		title: 'Declarations';
		priority: 1;
		object: [ self signature ];
		view: #gtDeclarationsFor:
]

{ #category : #inspecting }
LbSignatureBuilder >> gtOperatorsFor: aView [ 
	<gtView>
	^ aView forward
		title: 'Operators';
		priority: 0;
		object: [ self signature ];
		view: #gtOperatorsFor:
]

{ #category : #inspecting }
LbSignatureBuilder >> gtSortGraphFor: aView [ 
	<gtView>
	^ aView forward
		title: 'Sort graph';
		priority: 2;
		object: [ self signature ];
		view: #gtSortGraphFor:
]

{ #category : #inspecting }
LbSignatureBuilder >> gtVariablesFor: aView [ 
	<gtView>
	^ aView forward
		title: 'Variables';
		priority: 0;
		object: [ self signature ];
		view: #gtVariablesFor:
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
	opSpec isPetit2Failure ifTrue: [ Error signal: opSpec message ].
	op := opSpec first first.
	args := opSpec first second.
	sort := sortGraph sortNamed: opSpec second.
	argSorts := args collect: [ :each | sortGraph sortNamed: each last ].
	args select: [ :each | each size = 2 ]
		  thenDo: [ :each | self addVar: (LbPrefixOperatorName for: each first) ofSort: (sortGraph sortNamed: each second) ].
	args ifEmpty: [ self addOp: op ofSort: sort ]
		  ifNotEmpty: [ self addOp: op withArgs: argSorts ofSort: sort ]
]

{ #category : #adding }
LbSignatureBuilder >> parseAndAddVar: aString [
	| var name sort |
	var := LbSignatureParser parse: aString startingAt: #var.
	name := LbPrefixOperatorName for: var first.
	sort := sortGraph sortNamed: var second.
	self addVar: name ofSort: sort
]

{ #category : #accessing }
LbSignatureBuilder >> signature [
	^ LbSignature sortGraph: sortGraph builtins: builtins operators: operators deepCopy variables: variables deepCopy.


]

{ #category : #private }
LbSignatureBuilder >> sortGraph: aSortGraph [
	sortGraph := aSortGraph

]
