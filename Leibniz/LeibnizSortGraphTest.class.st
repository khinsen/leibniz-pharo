Class {
	#name : #LeibnizSortGraphTest,
	#superclass : #TestCase,
	#instVars : [
		'builder1',
		'builder2',
		'sortGraph1',
		'sortGraph2',
		'sortGraph3'
	],
	#category : #'Leibniz-1-SortGraphs'
}

{ #category : #running }
LeibnizSortGraphTest >> setUp [
	super setUp.

   builder1 := LbSortGraphBuilder new.
	builder1 add: #A;
         		add: #B;
         		add: #C;
  				add: #D;
				make: #A subsortOf: #B;
				make: #B subsortOf: #C;
				make: #A subsortOf: #D.
	sortGraph1 := builder1 sortGraph.

	builder2 := LbSortGraphBuilder new.
	builder2 add: #A;
				add: #X;
				add: #Y;
				make: #A subsortOf: #X;
				make: #X subsortOf: #Y.
	sortGraph2 := builder2 sortGraph.

	builder1 add: #V;
				add: #W;
				make: #V subsortOf: #W.
	sortGraph3 := builder1 sortGraph.

]

{ #category : #testing }
LeibnizSortGraphTest >> testCyclesForbidden [
	self should: [ builder1 make: #D subsortOf: #A ] raise: Error.
]

{ #category : #testing }
LeibnizSortGraphTest >> testEquality [
	self assert: sortGraph3 equals: builder1 sortGraph.
	self deny: sortGraph1 equals: 42.
	self deny: sortGraph1 equals: sortGraph2.
]

{ #category : #testing }
LeibnizSortGraphTest >> testKinds [
	| set1 |
	set1 := sortGraph1 asSet.
	set1 do: [ :sort | self assert: (sortGraph1 kindOf: sort) asSet equals: set1 ].
	self assert: sortGraph1 kinds size equals: 1.
	self assert: (sortGraph3 kindOf: #A) asSet equals: #(#A #B #C #D) asSet.
	self assert: (sortGraph3 kindOf: #V) asSet equals: #(#V #W) asSet.
	self assert: sortGraph3 kinds size equals: 2.
	self assert: (sortGraph1 kinds includes: (sortGraph1 kindOf: #A))
]

{ #category : #testing }
LeibnizSortGraphTest >> testMaximalSorts [
	self assert: sortGraph1 maximalSorts equals: #(#C #D) asSet.
	self assert: sortGraph3 maximalSorts equals: #(#C #D #W) asSet.

]

{ #category : #testing }
LeibnizSortGraphTest >> testSortGraphContents [
   self assert: sortGraph1 asSet equals: #(#A #B #C #D) asSet.
	self assert: (sortGraph1 includes: #A).
	self assert: (sortGraph1 includes: #B).
	self assert: (sortGraph1 includes: #C).
	self assert: (sortGraph1 includes: #D).
	self deny: (sortGraph1 includes: #E).
	self assert: (sortGraph1 is: #A subsortOf: #A).
	self assert: (sortGraph1 is: #A subsortOf: #B).
	self assert: (sortGraph1 is: #B subsortOf: #C).
	self assert: (sortGraph1 is: #A subsortOf: #D).
	self assert: (sortGraph1 is: #A subsortOf: #C).
	self deny: (sortGraph1 is: #C subsortOf: #A).
	self deny: (sortGraph1 is: #B subsortOf: #D).

]

{ #category : #testing }
LeibnizSortGraphTest >> testSortGraphUnion [
	| union1 union2 |
	union1 := (sortGraph1 union: sortGraph2).
	union2 := (sortGraph2 union: sortGraph1).
	self assert: union1 equals: union2.
	self assert: (union1 asSet) equals: (sortGraph1 asSet union: sortGraph2 asSet). 
	self assert: (union1 includes: #A).
	self assert: (union1 includes: #X).
	self assert: (union1 is: #A subsortOf: #C).
	self assert: (union1 is: #A subsortOf: #X).
	self assert: (sortGraph1 union: sortGraph1) equals: sortGraph1.
	self assert: (sortGraph1 union: LbSortGraphBuilder new sortGraph) equals: sortGraph1.

]

{ #category : #testing }
LeibnizSortGraphTest >> testSortParser [
   | builder |
	builder := LbSortGraphBuilder new.
	builder parseAndAdd: 'A ⊆ B';
			  parseAndAdd: 'B ⊆ C';
			  parseAndAdd: 'A ⊆ D'.
	self assert: builder sortGraph equals: sortGraph1
]

{ #category : #testing }
LeibnizSortGraphTest >> testSubsortQueries [
	self assert: (sortGraph1 is: #A subsortOf: #B).
	self deny:   (sortGraph1 is: #B subsortOf: #A).
	self assert: (sortGraph1 is: #B subsortOf: #B).
	self assert: (sortGraph1 directSubsortsOf: #A) equals: Set new.
	self assert: (sortGraph1 directSubsortsOf: #B) equals: (Set with: #A).
	self assert: (sortGraph1 subsortsOf: #B) equals: #(#A #B) asSet.

	self assert: (sortGraph1 directSubsortsOf: #C) equals: (Set with: #B).
	self assert: (sortGraph1 subsortsOf: #C) equals: #(#A #B #C) asSet.

	self assert: (sortGraph1 directSubsortsOf: #D) equals: (Set with: #A).
	self assert: (sortGraph1 subsortsOf: #D) equals: #(#A #D) asSet.
]
