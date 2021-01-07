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
	(operators at: #test ifAbsentPut: [ OrderedCollection new ])
		add: (opParser parse: aString)
]

{ #category : #accessing }
LbDependentSignatureBuilder >> signature [
	^ LbDependentSignature sortGraph: sortGraph
]
