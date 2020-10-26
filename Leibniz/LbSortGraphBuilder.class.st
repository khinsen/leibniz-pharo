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
		'directSubsortsOf'
	],
	#category : #'Leibniz-1-SortGraphs'
}

{ #category : #adding }
LbSortGraphBuilder >> add: aSymbol [
   (self includes: aSymbol)
     ifFalse: [ sameKindSortsOf at: aSymbol put: (Set with: aSymbol).
                directSubsortsOf at: aSymbol put: Set new. ].
   ^ aSymbol
]

{ #category : #adding }
LbSortGraphBuilder >> addSortGraph: aSortGraph [ 
	aSortGraph asSet do: [ :each | self add: each name ].
	aSortGraph withSubsortRelationsDo: [ :s1 :s2 | self make: s1 name subsortOf: s2 name ].
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

]

{ #category : #testing }
LbSortGraphBuilder >> is: aSort subsortOf: anotherSort [
	| ss |
	^ (aSort = anotherSort)
		or: [ ss := directSubsortsOf at: anotherSort.
				(ss includes: aSort)
				or: [ ss anySatisfy: [:each | self is: aSort subsortOf: each ]]]

]

{ #category : #adding }
LbSortGraphBuilder >> make: aSort subsortOf: anotherSort [
	| new_kind |
	(aSort = anotherSort) ifTrue: [ ^ aSort ].
	(self is: anotherSort subsortOf: aSort)
		ifTrue: [ self error: 'cycle in subsort relation: ',
			                   (anotherSort printString), '<', (aSort printString ) ].
	new_kind := (sameKindSortsOf at: aSort) union: (sameKindSortsOf at: anotherSort).
	new_kind do: [ :sort | sameKindSortsOf at: sort put: new_kind].
	(directSubsortsOf at: anotherSort) add: aSort.
	^ aSort
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
	^ LbSortGraph fromSubsortRelations: directSubsortsOf deepCopy.
]
