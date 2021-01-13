Class {
	#name : #LbDependentSignatureBuilder,
	#superclass : #Object,
	#instVars : [
		'sortGraph',
		'variables',
		'operators',
		'builtins',
		'opParser',
		'varParser'
	],
	#category : #'Leibniz-7-DependentSorts'
}

{ #category : #'instance creation' }
LbDependentSignatureBuilder class >> sortGraph: aSortGraph [
	^ self basicNew
		initializeWithSortGraph: aSortGraph;
		yourself
]

{ #category : #adding }
LbDependentSignatureBuilder >> addBuiltin: aSymbol [
	builtins add: aSymbol
]

{ #category : #adding }
LbDependentSignatureBuilder >> addOp: anOpName withArgs: aSortArray ofSort: aSortTerm [
	| arity kindArity |
	self checksForNewOp: anOpName withArgs: aSortArray ofSort: aSortTerm.

	arity := LbArity sortGraph: sortGraph argSorts: aSortArray.
	operators at: anOpName ifAbsentPut: [ Dictionary new ].
	(operators at: anOpName) at: arity size ifAbsentPut: [
		LbDependentOperator
			name: anOpName
			numArgs: arity size
			sortGraph: sortGraph ].
	((operators at: anOpName) at: arity size)
		addArity: arity withSort: aSortTerm
]

{ #category : #adding }
LbDependentSignatureBuilder >> addVar: anOpName ofSort: aSortTerm [
	self assert: (sortGraph includes: aSortTerm).
	operators at: anOpName ifPresent: [ :op |
		op at: (LbArity sortGraph: sortGraph argSorts: #()) ifPresent: [ :sort |
			self error: 'conflicting earlier operator definition with sort', sort asLeibnizSyntaxString ] ].

	variables at: anOpName
		ifPresent: [ :sort |
			self
				assert: sort = aSortTerm
				description: 'conflicting earlier variable definition with sort ', sort asLeibnizSyntaxString ]
		ifAbsent: [ variables at: anOpName put: aSortTerm ]
]

{ #category : #private }
LbDependentSignatureBuilder >> checksForNewOp: anOpName withArgs: aSortArray ofSort: aSortTerm [
	| argSortVariables |

		"All sorts belong to sortGraph"
	self assert: (sortGraph includes: aSortTerm).
	aSortArray do: [ :each | self assert: (sortGraph includes: each) ].

	"No conflict with variable declarations"
	aSortArray ifEmpty: [
		variables at: anOpName ifPresent: [ :sort |
			self error: 'conflicting earlier variable definition with sort ', sort asLeibnizSyntaxString ] ].

	"All variables in the result sort are used in the arg sorts"
	argSortVariables := Dictionary new.
	aSortArray do: [ :each |
		argSortVariables addAll: each term variables ].
	aSortTerm term variables associationsDo: [ :each |
		self
			assert: (argSortVariables includesAssociation: each)
			description: 'Variable ', each key asSymbol, ' in operator sort but not in arguments' ]
]

{ #category : #initialization }
LbDependentSignatureBuilder >> initializeParsersFor: aSignature [
	opParser := LbDependentSignatureParser newStartingAt: #opEnd.
	varParser := LbDependentSignatureParser newStartingAt: #varEnd
]

{ #category : #initialization }
LbDependentSignatureBuilder >> initializeWithSortGraph: aSortGraph [
	sortGraph := aSortGraph.
	builtins := Set new.
	operators := Dictionary new.
	variables := Dictionary new.
	self initializeParsersFor: aSortGraph sortContext signature
]

{ #category : #adding }
LbDependentSignatureBuilder >> parseAndAddOp: aString [
	| parsedOp argSorts |
	parsedOp := (opParser parse: aString).
	parsedOp isPetit2Failure ifTrue:
		[ self error: parsedOp message, ' after ',
				 (aString sliceFrom: 1 to: parsedOp position) ].
	parsedOp := parsedOp
					value: sortGraph sortContext signature
					value: Dictionary new.
	argSorts := parsedOp second collect: [ :each | sortGraph sortFor: each ].
	self addOp: parsedOp first withArgs: argSorts ofSort: (sortGraph sortFor: parsedOp third).
]

{ #category : #accessing }
LbDependentSignatureBuilder >> parseAndAddVar: aString [
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

{ #category : #accessing }
LbDependentSignatureBuilder >> signature [
	^ LbDependentSignature
		sortGraph: sortGraph
		builtins: builtins
		operators: operators
		variables:  variables
]
