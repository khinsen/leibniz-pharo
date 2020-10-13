Class {
	#name : #LbSortGraphExamples,
	#superclass : #Object,
	#traits : 'TGtExampleAssertable',
	#classTraits : 'TGtExampleAssertable classTrait',
	#category : #'Leibniz-1-SortGraphs'
}

{ #category : #example }
LbSortGraphExamples >> emptySortGraph [
	<gtExample>
	^ LbSortGraphBuilder new sortGraph
]

{ #category : #example }
LbSortGraphExamples >> kindOfA [
	<gtExample>
	^ self sortA kind
]

{ #category : #example }
LbSortGraphExamples >> maximalSortsABCDVW [
	<gtExample>
	| maximalSorts |
	maximalSorts := self sortGraphABCDVW maximalSorts.
	self assert: (maximalSorts collect: [ :each | each name ]) equals: #(#C #D #W) asSet.
	^ maximalSorts
]

{ #category : #example }
LbSortGraphExamples >> maximalSortsKindOfA [
	<gtExample>
	| maximalSorts |
	maximalSorts := self kindOfA maximalSorts.
	self assert: (maximalSorts collect: [ :each | each name ]) equals: #(#C #D) asSet.
	^ maximalSorts
]

{ #category : #example }
LbSortGraphExamples >> sortA [
	<gtExample>
	^ self sortGraphABCDVW sortNamed: #A
]

{ #category : #example }
LbSortGraphExamples >> sortGraphABCD [
	<gtExample>
	| sortGraph |
	sortGraph := self sortGraphBuilderABCD sortGraph.
    self assert: sortGraph equals: (self sortGraphABCDExplicit).
    self assert: sortGraph asSet
    	 equals: (#(#A #B #C #D) asSet collect: [ :each | sortGraph sortNamed: each ]).
    self shouldnt: [ sortGraph sortNamed: #A ] raise: Error.
    self shouldnt: [ sortGraph sortNamed: #B ] raise: Error.
    self shouldnt: [ sortGraph sortNamed: #C ] raise: Error.
    self shouldnt: [ sortGraph sortNamed: #D ] raise: Error.
    self should: [ sortGraph sortNamed: #E ] raise: Error.
    self assert: (sortGraph sortNamed: #A) <= (sortGraph sortNamed: #A).
    self assert: (sortGraph sortNamed: #A) <= (sortGraph sortNamed: #B).
    self assert: (sortGraph sortNamed: #B) <= (sortGraph sortNamed: #C).
    self assert: (sortGraph sortNamed: #A) <= (sortGraph sortNamed: #D).
    self assert: (sortGraph sortNamed: #A) <= (sortGraph sortNamed: #C).
	^ sortGraph
]

{ #category : #example }
LbSortGraphExamples >> sortGraphABCDExplicit [
	<gtExample>
	^ LbSortGraphBuilder new
		add: #A;
		add: #B;
		add: #C;
		add: #D;
		make: #A subsortOf: #B;
		make: #B subsortOf: #C;
		make: #A subsortOf: #D;
		sortGraph
]

{ #category : #example }
LbSortGraphExamples >> sortGraphABCDVW [
	<gtExample>
	^ LbSortGraphBuilder new
		addSortGraph: (self sortGraphABCDExplicit);
		parseAndAdd: 'V ⊆ W';
        sortGraph.
]

{ #category : #example }
LbSortGraphExamples >> sortGraphAXY [
	<gtExample>
	| sortGraph |
	sortGraph := LbSortGraphBuilder new
		parseAndAdd: 'A ⊆ X';
		parseAndAdd: 'X ⊆ Y';
		sortGraph.
	self assert: sortGraph equals: (self sortGraphAXYExplicit).
	^ sortGraph
]

{ #category : #example }
LbSortGraphExamples >> sortGraphAXYExplicit [
	<gtExample>
	^ LbSortGraphBuilder new
		add: #A;
		add: #X;
		add: #Y;
		make: #A subsortOf: #X;
		make: #X subsortOf: #Y;
		sortGraph
]

{ #category : #example }
LbSortGraphExamples >> sortGraphBuilderABCD [
	<gtExample>
	| builder |
	builder := LbSortGraphBuilder new
		parseAndAdd: 'A ⊆ B';
		parseAndAdd: 'B ⊆ C';
		parseAndAdd: 'A ⊆ D'.
	self should: [ builder make: #D subsortOf: #A ] raise: Error.
	^ builder
]

{ #category : #example }
LbSortGraphExamples >> sortGraphUnion [
	<gtExample>
	| sg1 sg2 union |
	sg1 := self sortGraphABCD.
	sg2 := self sortGraphAXY.
	union := (sg1 union: sg2).
	self assert: union equals: (sg2 union: sg1).
	self shouldnt: [ union sortNamed:#A ] raise: Error.
	self shouldnt: [ union sortNamed:#X ] raise: Error.
	self assert: (union sortNamed: #A) <= (union sortNamed: #C).
	self assert: (union sortNamed: #A) <= (union sortNamed: #Y).
	self assert: (union union: union) equals: union.
	self assert: (union union: self emptySortGraph) equals: union.
	self assert: (self emptySortGraph union: union) equals: union.
	^ union
]
