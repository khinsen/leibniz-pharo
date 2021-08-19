"
!! Sort graph builders

Sort graphs (${class:name=LbSortGraph}$) being immutable, they cannot be constructed by adding sorts and subsort relations one by one. However, such a step by step construction can be used to make a sort graph builder, which in the end is used to build an immutable sort graph.

An example:
${method:LeibnizSortGraphTest>>#setUp|expanded=}$

"
Class {
	#name : 'LbSortGraphBuilder',
	#superclass : 'Object',
	#instVars : [
		'directSubsortsOf',
		'origins',
		'collectionSortsOf',
		'baseSortOf'
	],
	#category : 'Leibniz-1-SortGraphs'
}

{ #category : 'adding' }
LbSortGraphBuilder >> add: aSymbol [
	self add: aSymbol origins: LbOrigins forCurrentContext
]

{ #category : 'adding' }
LbSortGraphBuilder >> add: aSymbol origins: anLbOrigins [
	| prefix baseName |
	(self includes: aSymbol)
		ifFalse: [
			directSubsortsOf at: aSymbol put: Set new.
			origins at: aSymbol put: anLbOrigins ]
		ifTrue: [
			(origins at: aSymbol) merge: anLbOrigins ]
]

{ #category : 'adding' }
LbSortGraphBuilder >> addSortGraph: aSortGraph [ 
	self addSortGraph: aSortGraph origin: nil
]

{ #category : 'adding' }
LbSortGraphBuilder >> addSortGraph: aSortGraph origin: aContext [
	aSortGraph asSet do: [ :eachSort |
		self
			add: eachSort name
			origins: (eachSort origins from: aContext) ].
	aSortGraph withSubsortRelationsDo: [ :ssr |
		self
			make: ssr subsort name
			subsortOf: ssr supersort name
			origins: (ssr origins from: aContext) ]
]

{ #category : 'private' }
LbSortGraphBuilder >> checkIf: aSort canBeMadeSubsortOf: anotherSort [
	(self is: anotherSort subsortOf: aSort)
		ifTrue: [
			self error: 'cycle in subsort relation: ',
					(anotherSort printString), '<=', (aSort printString ) ].
]

{ #category : 'accessing' }
LbSortGraphBuilder >> gtDeclarationsFor: aView [ 
	<gtView>
	^ aView forward
		title: 'Declarations';
		priority: 1;
		object: [ self sortGraph ];
		view: #gtDeclarationsFor:
]

{ #category : 'accessing' }
LbSortGraphBuilder >> gtGraphFor: aView [ 
	<gtView>
	^ aView forward
		title: 'Graph';
		priority: 0;
		object: [ self sortGraph ];
		view: #gtGraphFor:
]

{ #category : 'testing' }
LbSortGraphBuilder >> includes: aSort [
	^ directSubsortsOf keys includes: aSort
]

{ #category : 'initializing' }
LbSortGraphBuilder >> initialize [
	directSubsortsOf := Dictionary new.
	baseSortOf := Dictionary new.
	collectionSortsOf := Dictionary new.
	origins := Dictionary new
]

{ #category : 'private' }
LbSortGraphBuilder >> is: aSort subsortOf: anotherSort [
	| ss |
	^ (aSort = anotherSort) or: [
		ss := directSubsortsOf at: anotherSort.
		(ss includes: aSort) or: [
			ss anySatisfy: [:each |
				self is: aSort subsortOf: each ] ] ]
]

{ #category : 'adding' }
LbSortGraphBuilder >> make: aSort subsortOf: anotherSort [
	self make: aSort subsortOf: anotherSort origins: LbOrigins forCurrentContext
]

{ #category : 'adding' }
LbSortGraphBuilder >> make: aSort subsortOf: anotherSort origins: anLbOrigins [
	| sortPair newKind |
	(aSort = anotherSort) ifTrue: [ ^ self ].
	self checkIf: aSort canBeMadeSubsortOf: anotherSort.

	sortPair := { aSort. anotherSort }.
	((directSubsortsOf at: anotherSort) includes: aSort)
		ifFalse: [
			(directSubsortsOf at: anotherSort) add: aSort.
			origins at: sortPair put: anLbOrigins ]
		ifTrue: [
			(origins at: sortPair) merge: anLbOrigins ]
]

{ #category : 'adding' }
LbSortGraphBuilder >> parseAndAdd: aString [
	| declaration |
	declaration := (LbParser2 newStartingAt: #sortOrSubsort)
					parse: aString.
	declaration size = 1 ifTrue:
		[	self add: declaration first ].
	declaration size = 2 ifTrue:
		[	self add: declaration first.
			self add: declaration second.
			self make: declaration first subsortOf: declaration second ].
]

{ #category : 'accessing' }
LbSortGraphBuilder >> sortGraph [
	^ LbSortGraph
		fromSubsortRelations: directSubsortsOf deepCopy
		andCollectionSorts: collectionSortsOf deepCopy
		origins: origins deepCopy
]
