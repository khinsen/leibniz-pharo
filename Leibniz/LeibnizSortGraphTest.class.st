Class {
	#name : #LeibnizSortGraphTest,
	#superclass : #TestCase,
	#instVars : [
		'sortGraph1',
		'sortGraph2',
		'sortGraph3'
	],
	#category : 'Leibniz'
}

{ #category : #running }
LeibnizSortGraphTest >> setUp [
   sortGraph1 := LeibnizSortGraph new.
	sortGraph1 add: #A;
              add: #B;
              add: #C;
              add: #D;
				  make: #A subsortOf: #B;
				  make: #B subsortOf: #C;
				  make: #A subsortOf: #D.
	sortGraph2 := LeibnizSortGraph new.
	sortGraph2 add: #A;
				  add: #X;
				  add: #Y;
				  make: #A subsortOf: #X;
				  make: #X subsortOf: #Y.
	sortGraph3 := sortGraph1 copy.
	sortGraph3 add: #V;
				  add: #W;
				  make: #V subsortOf: #W.

]

{ #category : #testing }
LeibnizSortGraphTest >> testCyclesForbidden [
	self should: [ sortGraph1 make: #D subsortOf: #A ] raise: Error.
]

{ #category : #testing }
LeibnizSortGraphTest >> testKinds [
	| set1 |
	set1 := sortGraph1 asSet.
	set1 do: [ :sort | self assert: (sortGraph1 kindOf: sort) equals: set1 ].
	self assert: (sortGraph3 kindOf: #A) equals: #(#A #B #C #D) asSet.
	self assert: (sortGraph3 kindOf: #V) equals: #(#V #W) asSet.

]

{ #category : #testing }
LeibnizSortGraphTest >> testMaximalSorts [
	self assert: (sortGraph1 maximalSorts: sortGraph1 asSet) equals: #(#C #D) asSet.
	self assert: (sortGraph3 maximalSorts: sortGraph3 asSet) equals: #(#C #D #W) asSet.

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
	self assert: (sortGraph1 union: sortGraph1 class new) equals: sortGraph1.

]

{ #category : #testing }
LeibnizSortGraphTest >> testSubsortQueries [
	self assert: (sortGraph1 directSubsortsOf: #A) equals: Set new.
	self assert: (sortGraph1 subsortsOf: #B) equals: (Set with: #A).
	self assert: (sortGraph1 directSubsortsOf: #B) equals: (Set with: #A).
	self assert: (sortGraph1 subsortsOf: #B) equals: (Set with: #A).
	self assert: (sortGraph1 directSubsortsOf: #C) equals: (Set with: #B).
	self assert: (sortGraph1 subsortsOf: #C) equals: #(#A #B) asSet.
	self assert: (sortGraph1 directSubsortsOf: #D) equals: (Set with: #A).
	self assert: (sortGraph1 subsortsOf: #D) equals: (Set with: #A).

]
