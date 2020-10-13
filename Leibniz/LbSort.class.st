"
!Sorts

See ${class:name=LbSortGraph}$.

"
Class {
	#name : #LbSort,
	#superclass : #LbSortSubGraph,
	#instVars : [
		'name'
	],
	#category : #'Leibniz-1-SortGraphs'
}

{ #category : #'instance creation' }
LbSort class >> named: aSymbol in: aSortGraph [
	^self basicNew
			initializeWithName: aSymbol sortGraph: aSortGraph;
			yourself
]

{ #category : #comparing }
LbSort >> <= aSort [
	self sortGraph = aSort sortGraph ifFalse: [ ^ false ].
	^ self sortGraph is: self name subsortOf: aSort name
]

{ #category : #accessing }
LbSort >> asSet [
	^ self subsorts
]

{ #category : #initialization }
LbSort >> initializeWithName: aSymbol sortGraph: aSortGraph [
	sortGraph := aSortGraph.
	name := aSymbol
]

{ #category : #accessing }
LbSort >> kind [
	^ sortGraph kindOf: name
]

{ #category : #accessing }
LbSort >> name [
	^ name
]

{ #category : #printing }
LbSort >> printAsLeibnizSyntaxOn: aStream [
	aStream nextPutAll: name
]

{ #category : #printing }
LbSort >> printOn: aStream [
	super printOn: aStream.
	aStream nextPut: $(.
	aStream nextPutAll: name.
	aStream nextPut: $).
]

{ #category : #accessing }
LbSort >> subsorts [
	^ sortGraph subsortsOf: name
]