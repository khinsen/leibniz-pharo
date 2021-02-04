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
LbSort class >> classFor: aSymbol [
	(((self allSubclasses
		select: [ :each | each sortNamePrefix isNotNil ])
		collect: [ :each | { each sortNamePrefix. each } ])
		sorted: [ :a :b | a first size > b first size ])
		do: [ :each |
		(aSymbol beginsWith: each first)
			ifTrue: [ ^ each second ] ].
	^ LbPlainSort
]

{ #category : #'instance creation' }
LbSort class >> named: aSymbol in: aSortGraph origins: anLbOrigins [
	^ (self classFor: aSymbol) basicNew
			initializeWithName: aSymbol
			sortGraph: aSortGraph
			origins: anLbOrigins;
			yourself
]

{ #category : #'instance creation' }
LbSort class >> sortNamePrefix [
	^ nil
]

{ #category : #'instance creation' }
LbSort class >> splitName: aSymbol [
	^ { #''. aSymbol }
]

{ #category : #comparing }
LbSort >> <= aSort [
	self subclassResponsibility
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

{ #category : #testing }
LbSort >> isFromInclude [
	^ origins containsIncludes
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
