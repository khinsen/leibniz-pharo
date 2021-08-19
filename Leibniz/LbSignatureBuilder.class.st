"
I build LeibnizSignatures from a sequence of operator and variable declarations.
"
Class {
	#name : 'LbSignatureBuilder',
	#superclass : 'Object',
	#instVars : [
		'sortGraph',
		'builtins',
		'operators',
		'variables',
		'origins'
	],
	#category : 'Leibniz-2-Signatures'
}

{ #category : 'instance creation' }
LbSignatureBuilder class >> sortGraph: aSortGraph [
	^self basicNew
			initializeWithSortGraph: aSortGraph;
			yourself
]

{ #category : 'adding' }
LbSignatureBuilder >> addBuiltin: aSymbol [
	builtins add: aSymbol
]

{ #category : 'adding' }
LbSignatureBuilder >> addBuiltinsFromSignature: aSignature [
	aSignature withBuiltinsDo:
		[ :symbol |
		  self addBuiltin: symbol ].

]

{ #category : 'adding' }
LbSignatureBuilder >> addOp: anOpName ofSort: aSort [
	self addOp: anOpName withArgs: #() ofSort: aSort
]

{ #category : 'adding' }
LbSignatureBuilder >> addOp: anOpName withArgs: aSortArray ofSort: aSort [
	self addOp: anOpName withArgs: aSortArray ofSort: aSort origins: LbOrigins forCurrentContext
]

{ #category : 'adding' }
LbSignatureBuilder >> addOp: anOpName withArgs: aSortArray ofSort: aSort origins: anLbOrigins [
	| arity kindArity |
	aSortArray ifEmpty: [
		variables at: anOpName ifPresent: [ :sort |
			self error: 'conflicting earlier variable definition with sort ', sort name ] ].

	arity := LbArity sortGraph: sortGraph argSorts: aSortArray.
	kindArity := arity liftToKindLevel.
	operators at: anOpName ifAbsentPut: [ Dictionary new ].
	(operators at: anOpName) at: kindArity ifAbsentPut: [
		LbOperator
			name: anOpName
			argKinds: kindArity
			kind: aSort kind
			origins: anLbOrigins ].
	((operators at: anOpName) at: kindArity)
		addArity: arity withSort: aSort origins: anLbOrigins
]

{ #category : 'adding' }
LbSignatureBuilder >> addOpsFromSignature: aSignature origin: aContext [
	aSignature withOperatorsDo: [ :eachOp |
		eachOp withRanksDo: [ :argSorts :sort |
			self
				addOp: eachOp name
				withArgs: (argSorts collect: [ :each | self adoptSort: each ])
				ofSort: (self adoptSort: sort)
				origins: (eachOp origins from: aContext) ] ]
]

{ #category : 'adding' }
LbSignatureBuilder >> addSignature: aSignature includeVars: aBoolean [
	self addSignature: aSignature includeVars: aBoolean origin: nil
]

{ #category : 'adding' }
LbSignatureBuilder >> addSignature: aSignature includeVars: aBoolean origin: aContext [
	self addBuiltinsFromSignature: aSignature.
	self addOpsFromSignature: aSignature origin: aContext.
	aBoolean ifTrue: [ self addVarsFromSignature: aSignature origin: aContext ]
]

{ #category : 'adding' }
LbSignatureBuilder >> addVar: anOpName ofSort: aSort [
	self addVar: anOpName ofSort: aSort origins: LbOrigins forCurrentContext
]

{ #category : 'adding' }
LbSignatureBuilder >> addVar: anOpName ofSort: aSort origins: anLbOrigins [
	self assert: aSort sortGraph == sortGraph.
	operators at: anOpName ifPresent: [ :op |
		op at: (LbArity sortGraph: sortGraph argSorts: #()) ifPresent: [ :sort |
			self error: 'conflicting earlier operator definition with sort', sort name ] ].
	variables at: anOpName
		ifPresent: [ :sort |
			self assert: sort = aSort
				description: 'conflicting earlier variable definition with sort ', sort name.
			(origins at: anOpName) merge: anLbOrigins ]
		ifAbsent: [
			   variables at: anOpName put: aSort.
			   origins at: anOpName put: anLbOrigins ]
]

{ #category : 'adding' }
LbSignatureBuilder >> addVarsFromSignature: aSignature origin: aContext [
	aSignature withVariablesDo: [ :each |
		self
			addVar: each name
			ofSort:  (self adoptSort: each sort)
			origins: (each origins from: aContext) ]
]

{ #category : 'converting' }
LbSignatureBuilder >> adoptSort: aSort [
	"Adopt a sort from a foreign sort graph, by name"
	^ sortGraph sortNamed: aSort name
]

{ #category : 'inspecting' }
LbSignatureBuilder >> gtDeclarationsFor: aView [ 
	<gtView>
	^ aView forward
		title: 'Declarations';
		priority: 1;
		object: [ self signature ];
		view: #gtDeclarationsFor:
]

{ #category : 'inspecting' }
LbSignatureBuilder >> gtOperatorsFor: aView [ 
	<gtView>
	^ aView forward
		title: 'Operators';
		priority: 0;
		object: [ self signature ];
		view: #gtOperatorsFor:
]

{ #category : 'inspecting' }
LbSignatureBuilder >> gtSortGraphFor: aView [ 
	<gtView>
	^ aView forward
		title: 'Sort graph';
		priority: 2;
		object: [ self signature ];
		view: #gtSortGraphFor:
]

{ #category : 'inspecting' }
LbSignatureBuilder >> gtVariablesFor: aView [ 
	<gtView>
	^ aView forward
		title: 'Variables';
		priority: 0;
		object: [ self signature ];
		view: #gtVariablesFor:
]

{ #category : 'initializing' }
LbSignatureBuilder >> initializeWithSortGraph: aSortGraph [
	sortGraph := aSortGraph.
	builtins := Set new.
	operators := Dictionary new.
	variables := Dictionary new.
	origins := Dictionary new
]

{ #category : 'adding' }
LbSignatureBuilder >> parseAndAddOp: aString [
	| opSpec op args sort argSorts |
	opSpec := (LbParser2 newStartingAt: #op)
				parse: aString.
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

{ #category : 'adding' }
LbSignatureBuilder >> parseAndAddVar: aString [
	| var name sort |
	var := (LbParser2 newStartingAt: #var)
				parse: aString.
	var isPetit2Failure ifTrue: [ Error signal: var message ].
	name := LbPrefixOperatorName for: var first.
	sort := sortGraph sortNamed: var second.
	self addVar: name ofSort: sort
]

{ #category : 'accessing' }
LbSignatureBuilder >> signature [
	^ LbSignature
		sortGraph: sortGraph
		builtins: builtins
		operators: operators deepCopy
		variables: variables deepCopy
		origins: origins deepCopy
]

{ #category : 'private' }
LbSignatureBuilder >> sortGraph: aSortGraph [
	sortGraph := aSortGraph

]
