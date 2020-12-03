"
!Sorts

See ${class:name=LbSortGraph}$.

"
Class {
	#name : #LbSort,
	#superclass : #LbSortClassifier,
	#instVars : [
		'name',
		'origins'
	],
	#category : #'Leibniz-1-SortGraphs'
}

{ #category : #'instance creation' }
LbSort class >> named: aSymbol in: aSortGraph origins: aSet [
	^self basicNew
			initializeWithName: aSymbol sortGraph: aSortGraph origins: aSet;
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

{ #category : #enumerating }
LbSort >> conformingSorts [
	^ self subsorts
]

{ #category : #inspecting }
LbSort >> gtOriginsFor: aView [
	<gtView>
	origins ifNil: [ ^ aView empty ].
	^ aView forward
		title: 'Origins';
		priority: 2;
		object: [ origins collect: [ :each | each ifNil: 'current context' ] ];
		view: #gtItemsFor:
]

{ #category : #initialization }
LbSort >> initializeWithName: aSymbol sortGraph: aSortGraph origins: aSet [
	sortGraph := aSortGraph.
	name := aSymbol.
	origins := aSet
]

{ #category : #testing }
LbSort >> isConformingSort: aSort [
	^ aSort <= self
]

{ #category : #accessing }
LbSort >> kind [
	^ sortGraph kindOf: name
]

{ #category : #accessing }
LbSort >> name [
	^ name
]

{ #category : #accessing }
LbSort >> origins [
	^ origins
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

{ #category : #'private - comparing' }
LbSort >> sortAfterKind: aKind [
	^ false
]

{ #category : #'private - comparing' }
LbSort >> sortAfterSort: aSort [
	^ self name > aSort name
]

{ #category : #comparing }
LbSort >> sortBefore: aSort [
	^ aSort sortAfterSort: self
]

{ #category : #enumerating }
LbSort >> subsorts [
	^ sortGraph subsortsOf: name
]
