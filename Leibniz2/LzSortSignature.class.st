Class {
	#name : #LzSortSignature,
	#superclass : #LzSignature,
	#instVars : [
		'clientSortGraph'
	],
	#category : #'Leibniz2-Sorts'
}

{ #category : #accessing }
LzSortSignature >> clientSortGraph [
	^ clientSortGraph
]

{ #category : #accessing }
LzSortSignature >> clientSortGraph: aSortGraph [
	clientSortGraph
		ifNil: [
			self beWritableObject.
			clientSortGraph := aSortGraph.
			self beReadOnlyObject ]
		ifNotNil: [ self assert: clientSortGraph == aSortGraph ]
]

{ #category : #constructing }
LzSortSignature >> opTerm: anOpName args: anArrayOfTerms [
	| sort term |
	sort := self operators
				sortForOp: anOpName
				arity: (LzArity forArgs: anArrayOfTerms).
	anArrayOfTerms do: [ :each |
		self assert: each signature == self ].
	term := sort isSortSort
		ifTrue: [ LzSortTerm new
					sortGraph: self clientSortGraph ]
		ifFalse: [ LzOpTerm new ].
	^ term
		signature: self;
		opName: anOpName;
		args: anArrayOfTerms;
		sort: sort;
		beRecursivelyReadOnlyObject;
		yourself 
]
