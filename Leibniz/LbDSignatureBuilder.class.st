Class {
	#name : 'LbDSignatureBuilder',
	#superclass : 'Object',
	#instVars : [
		'sortGraph',
		'variables',
		'operators',
		'builtins',
		'opParser',
		'varParser'
	],
	#category : 'Leibniz-7-DependentSorts'
}

{ #category : 'instance creation' }
LbDSignatureBuilder class >> sortGraph: aSortGraph [
	^ self basicNew
		initializeWithSortGraph: aSortGraph;
		yourself
]

{ #category : 'adding' }
LbDSignatureBuilder >> addBuiltin: aSymbol [
	builtins add: aSymbol
]

{ #category : 'adding' }
LbDSignatureBuilder >> addBuiltinsFromSignature: aSignature [
	aSignature withBuiltinsDo:
		[ :symbol |
		  self addBuiltin: symbol ]
]

{ #category : 'adding' }
LbDSignatureBuilder >> addOp: anOpName withArgs: aSortPatternArray ofSort: aSortPattern [
	| arity kindArity |
	self checksForNewOp: anOpName withArgs: aSortPatternArray ofSort: aSortPattern.

	arity := LbDArity sortGraph: sortGraph argSortPatterns: aSortPatternArray.
	kindArity := arity liftToKinds.
	operators at: anOpName ifAbsentPut: [ Dictionary new ].
	(operators at: anOpName) at: kindArity ifAbsentPut: [
		LbDOperator
			name: anOpName
			kindArity: kindArity
			kind: aSortPattern kind ].
	((operators at: anOpName) at: kindArity)
		addArity: arity withSort: aSortPattern
]

{ #category : 'adding' }
LbDSignatureBuilder >> addOpsFromSignature: aSignature [
	aSignature withOperatorsDo: [ :eachOp |
		eachOp withRanksDo: [ :argSorts :sort |
			self
				addOp: eachOp name
				withArgs: (argSorts collect: [ :each | self sortGraph parseSort: each asLeibnizSyntaxString ])
				ofSort: (self sortGraph parseSort: sort asLeibnizSyntaxString) ] ]
]

{ #category : 'adding' }
LbDSignatureBuilder >> addSignature: aSignature includeVars: aBoolean [
	self addBuiltinsFromSignature: aSignature.
	self addOpsFromSignature: aSignature.
	aBoolean ifTrue: [ self addVarsFromSignature: aSignature ]
]

{ #category : 'adding' }
LbDSignatureBuilder >> addVar: anOpName ofSort: aSortPattern [
	self assert: (sortGraph includes: aSortPattern).
	operators at: anOpName ifPresent: [ :op |
		op at: (LbArity sortGraph: sortGraph argSorts: #()) ifPresent: [ :sort |
			self error: 'conflicting earlier operator definition with sort', sort asLeibnizSyntaxString ] ].

	variables at: anOpName
		ifPresent: [ :sort |
			self
				assert: sort = aSortPattern
				description: 'conflicting earlier variable definition with sort ', sort asLeibnizSyntaxString ]
		ifAbsent: [ variables at: anOpName put: aSortPattern ]
]

{ #category : 'adding' }
LbDSignatureBuilder >> addVarsFromSignature: aSignature [
	aSignature withVariablesDo: [ :each |
		self
			addVar: each name
			ofSort: (self sortGraph parseSort: each sort asLeibnizSyntaxString) ]
]

{ #category : 'private' }
LbDSignatureBuilder >> checksForNewOp: anOpName withArgs: aSortPatternArray ofSort: aSortPattern [
	| argSortVariables |

	"All sorts belong to sortGraph"
	self assert: (sortGraph includes: aSortPattern).
	aSortPatternArray do: [ :each | self assert: (sortGraph includes: each) ].

	"No conflict with variable declarations"
	aSortPatternArray ifEmpty: [
		variables at: anOpName ifPresent: [ :sort |
			self error: 'conflicting earlier variable definition with sort ', sort asLeibnizSyntaxString ] ].

	"All variables in the result sort occur in the arg sorts"
	argSortVariables := Dictionary new.
	aSortPatternArray do: [ :each |
		argSortVariables addAll: each term variables ].
	aSortPattern term variables associationsDo: [ :each |
		self
			assert: (argSortVariables includesAssociation: each)
			description: 'Variable ', each key asSymbol, ' in operator sort but not in arguments' ]
]

{ #category : 'initialization' }
LbDSignatureBuilder >> initializeParsersFor: aSignature [
	opParser := LbDSignatureParser newStartingAt: #opEnd.
	varParser := LbDSignatureParser newStartingAt: #varEnd
]

{ #category : 'initialization' }
LbDSignatureBuilder >> initializeWithSortGraph: aSortGraph [
	sortGraph := aSortGraph.
	builtins := Set new.
	operators := Dictionary new.
	variables := Dictionary new.
	self initializeParsersFor: aSortGraph sortContext signature
]

{ #category : 'adding' }
LbDSignatureBuilder >> parseAndAddOp: aString [
	| parsedOp argSorts sort |
	parsedOp := (opParser parse: aString).
	parsedOp isPetit2Failure ifTrue:
		[ self error: parsedOp message, ' after ',
				 (aString sliceFrom: 1 to: parsedOp position) ].
	parsedOp := parsedOp
					value: sortGraph sortContext signature
					value: Dictionary new.
	argSorts := parsedOp second collect: [ :each | sortGraph sortFor: each ].
	sort := sortGraph sortFor: parsedOp third.
	self addOp: parsedOp first withArgs: argSorts ofSort: sort
]

{ #category : 'accessing' }
LbDSignatureBuilder >> parseAndAddVar: aString [
	| parsedVar |
	parsedVar := (varParser parse: aString).
	parsedVar isPetit2Failure ifTrue:
		[ self error: parsedVar message, ' after ',
				 (aString sliceFrom: 1 to: parsedVar position) ].
	parsedVar := parsedVar
					value: sortGraph sortContext signature
					value: Dictionary new.
	self addVar: parsedVar first ofSort: (sortGraph sortFor: parsedVar second)
]

{ #category : 'accessing' }
LbDSignatureBuilder >> signature [
	^ LbDSignature
		sortGraph: sortGraph
		builtins: builtins
		operators: operators
		variables:  variables
]

{ #category : 'accessing' }
LbDSignatureBuilder >> sortGraph [
	^ sortGraph
]
