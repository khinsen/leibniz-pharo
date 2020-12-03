"
!! Sort graph builders

Sort graphs (${class:name=LbSortGraph}$) being immutable, they cannot be constructed by adding sorts and subsort relations one by one. However, such a step by step construction can be used to make a sort graph builder, which in the end is used to build an immutable sort graph.

An example:
${method:LeibnizSortGraphTest>>#setUp|expanded=}$

"
Class {
	#name : #LbSortGraphBuilder,
	#superclass : #Object,
	#instVars : [
		'sameKindSortsOf',
		'directSubsortsOf',
		'origins'
	],
	#category : #'Leibniz-1-SortGraphs'
}

{ #category : #adding }
LbSortGraphBuilder >> add: aSymbol [
	self add: aSymbol origins: nil
]

{ #category : #adding }
LbSortGraphBuilder >> add: aSymbol origins: aSet [
	| newOrigins |
	newOrigins := aSet ifNil: [ Set with: nil].
	(self includes: aSymbol)
		ifFalse: [
			sameKindSortsOf at: aSymbol put: (Set with: aSymbol).
			directSubsortsOf at: aSymbol put: Set new.
			origins at: aSymbol put: newOrigins ]
		ifTrue: [
			origins at: aSymbol put: ((origins at: aSymbol) union: newOrigins) ]
]

{ #category : #adding }
LbSortGraphBuilder >> addSortGraph: aSortGraph [ 
	self addSortGraph: aSortGraph origin: nil
]

{ #category : #adding }
LbSortGraphBuilder >> addSortGraph: aSortGraph origin: aContext [
	aSortGraph asSet do: [ :eachSort |
		self
			add: eachSort name
			origins: (eachSort origins collect: [ :each | each ifNil: [ aContext ] ]) ].
	aSortGraph withSubsortRelationsDo: [ :ssr |
		self
			make: ssr subsort name
			subsortOf: ssr supersort name
			origins: (ssr origins collect: [ :each | each ifNil: [ aContext ] ]) ]
]

{ #category : #accessing }
LbSortGraphBuilder >> gtDeclarationsFor: aView [ 
	<gtView>
	^ aView forward
		title: 'Declarations';
		priority: 1;
		object: [ self sortGraph ];
		view: #gtDeclarationsFor:
]

{ #category : #accessing }
LbSortGraphBuilder >> gtGraphFor: aView [ 
	<gtView>
	^ aView forward
		title: 'Graph';
		priority: 0;
		object: [ self sortGraph ];
		view: #gtGraphFor:
]

{ #category : #testing }
LbSortGraphBuilder >> includes: aSort [
	^ sameKindSortsOf keys includes: aSort

]

{ #category : #initializing }
LbSortGraphBuilder >> initialize [
	sameKindSortsOf := Dictionary new.
	directSubsortsOf := Dictionary new.
	origins := Dictionary new
]

{ #category : #private }
LbSortGraphBuilder >> is: aSort subsortOf: anotherSort [
	| ss |
	^ (aSort = anotherSort)
		or: [ ss := directSubsortsOf at: anotherSort.
				(ss includes: aSort)
				or: [ ss anySatisfy: [:each | self is: aSort subsortOf: each ]]]

]

{ #category : #adding }
LbSortGraphBuilder >> make: aSort subsortOf: anotherSort [
	self make: aSort subsortOf: anotherSort origins: nil
]

{ #category : #adding }
LbSortGraphBuilder >> make: aSort subsortOf: anotherSort origins: aSet [
	| newOrigins sortPair newKind |
	(aSort = anotherSort) ifTrue: [ ^ self ].
	(self is: anotherSort subsortOf: aSort)
		ifTrue: [
			self error: 'cycle in subsort relation: ',
					(anotherSort printString), '<=', (aSort printString ) ].
	newOrigins := aSet ifNil: [ Set with: nil].
	sortPair := { aSort. anotherSort }.
	((directSubsortsOf at: anotherSort) includes: aSort)
		ifFalse: [
			newKind := (sameKindSortsOf at: aSort) union: (sameKindSortsOf at: anotherSort).
			newKind do: [ :sort | sameKindSortsOf at: sort put: newKind].
			(directSubsortsOf at: anotherSort) add: aSort.
			origins at: sortPair put: newOrigins ]
		ifTrue: [
			origins at: sortPair put: ((origins at: sortPair) union: newOrigins)]
]

{ #category : #adding }
LbSortGraphBuilder >> parseAndAdd: aString [
	| declaration |
	declaration := LbSortParser parse: aString.
	declaration size = 1 ifTrue:
		[	self add: declaration first ].
	declaration size = 2 ifTrue:
		[	self add: declaration first.
			self add: declaration second.
			self make: declaration first subsortOf: declaration second ].

]

{ #category : #accessing }
LbSortGraphBuilder >> sortGraph [
	^ LbSortGraph
		fromSubsortRelations: directSubsortsOf deepCopy
		origins: origins deepCopy
]
