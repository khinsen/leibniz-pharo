"
I build LeibnizSortGraphs from a sequence of sort and subsort declarations.
"
Class {
	#name : #LeibnizSortGraphBuilder,
	#superclass : #Object,
	#instVars : [
		'sameKindSortsOf',
		'directSubsortsOf'
	],
	#category : #'Leibniz-1-SortGraphs'
}

{ #category : #adding }
LeibnizSortGraphBuilder >> add: aSymbol [
   (self includes: aSymbol)
     ifFalse: [ sameKindSortsOf at: aSymbol put: (Set with: aSymbol).
                directSubsortsOf at: aSymbol put: Set new. ].
   ^ aSymbol

]

{ #category : #adding }
LeibnizSortGraphBuilder >> addSortGraph: aSortGraph [ 
	aSortGraph asSet do: [ :each | self add: each ].
	aSortGraph withSubsortRelationsDo: [ :s1 :s2 | self make: s1 subsortOf: s2 ].

]

{ #category : #testing }
LeibnizSortGraphBuilder >> includes: aSort [
	^ sameKindSortsOf keys includes: aSort

]

{ #category : #initializing }
LeibnizSortGraphBuilder >> initialize [
   sameKindSortsOf := Dictionary new.
	directSubsortsOf := Dictionary new.

]

{ #category : #testing }
LeibnizSortGraphBuilder >> is: aSort subsortOf: anotherSort [
	| ss |
	^ (aSort = anotherSort)
		or: [ ss := directSubsortsOf at: anotherSort.
				(ss includes: aSort)
				or: [ ss anySatisfy: [:each | self is: aSort subsortOf: each ]]]

]

{ #category : #adding }
LeibnizSortGraphBuilder >> make: aSort subsortOf: anotherSort [
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

{ #category : #accessing }
LeibnizSortGraphBuilder >> sortGraph [
	^ LeibnizSortGraph subsortRelations: directSubsortsOf deepCopy.

]
