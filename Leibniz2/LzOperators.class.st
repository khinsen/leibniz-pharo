Class {
	#name : #LzOperators,
	#superclass : #Object,
	#instVars : [
		'sortGraph',
		'opTable'
	],
	#category : #'Leibniz2-Leibniz2'
}

{ #category : #defining }
LzOperators >> addOp: anASTOpNode [
	| argSorts resultSort |
	argSorts := anASTOpNode args collect: [ :each |
		self sortGraph
			parsedSortTerm: each
			variables: anASTOpNode variables ].
	resultSort := self sortGraph
		parsedSortTerm: anASTOpNode sort
		variables: anASTOpNode variables.
	self notYetImplemented
]

{ #category : #defining }
LzOperators >> operators: aSetOfASTOpNodes [
	opTable := Dictionary new.
	aSetOfASTOpNodes do: [ :each |
		self addOp: each ]
]

{ #category : #accessing }
LzOperators >> sortForOp: anOpName args: anArrayOfTerms [
	self notYetImplemented
]

{ #category : #accessing }
LzOperators >> sortGraph [
	^ sortGraph
]

{ #category : #accessing }
LzOperators >> sortGraph: aSortGraph [
	sortGraph := aSortGraph
]
