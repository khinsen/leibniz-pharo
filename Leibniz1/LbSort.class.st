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
	#category : 'Leibniz-1-SortGraphs'
}

{ #category : #'instance creation' }
LbSort class >> named: aSymbol in: aSortGraph origins: anLbOrigins [
	^ self basicNew
			initializeWithName: aSymbol
			sortGraph: aSortGraph
			origins: anLbOrigins;
			yourself
]

{ #category : #comparing }
LbSort >> <= aSort [
	| dss |
	self = aSort ifTrue: [ ^ true ].
	self sortGraph = aSort sortGraph ifFalse: [ ^ false ].
	dss := sortGraph directSubsortsOf: aSort name.
	(dss includes: self) ifTrue: [ ^ true ].
	dss do: [ :each |
		self <= each ifTrue: [ ^ true ] ].
	^ false
]

{ #category : #converting }
LbSort >> asLeibnizSyntaxString [
	^ name asString
]

{ #category : #accessing }
LbSort >> asSet [
	^ self subsorts
]

{ #category : #inspecting }
LbSort >> gtOriginsFor: aView [
	<gtView>
	origins ifNil: [ ^ aView empty ].
	^ aView forward
		title: 'Origins';
		priority: 2;
		object: [ origins ];
		view: #gtItemsFor:;
		yourself
]

{ #category : #initialization }
LbSort >> initializeWithName: aSymbol sortGraph: aSortGraph origins: aSet [
	sortGraph := aSortGraph.
	name := aSymbol.
	origins := aSet
]

{ #category : #comparing }
LbSort >> instVarsExcludedFromEquality [
	^#(origins)
]

{ #category : #testing }
LbSort >> isFromInclude [
	^ origins containsIncludes
]

{ #category : #accessing }
LbSort >> kind [
	^ sortGraph kindOf: name
]

{ #category : #accessing }
LbSort >> min: aSort [
	self <= aSort ifTrue: [ ^ self ].
	aSort <= self ifTrue: [ ^ aSort ].
	^ nil
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
