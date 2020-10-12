Class {
	#name : #LbSortGraphExamples,
	#superclass : #Object,
	#category : #'Leibniz-1-SortGraphs'
}

{ #category : #accessing }
LbSortGraphExamples >> emptySortGraph [
	<gtExample>
	^ LbSortGraphBuilder new sortGraph
]

{ #category : #example }
LbSortGraphExamples >> maximalSorts [
	<gtExample>
	| maximalSorts |
	maximalSorts := self sortGraphABCDVW maximalSorts.
	self assert: maximalSorts equals: #(#C #D #W) asSet.
	^ maximalSorts
]

{ #category : #example }
LbSortGraphExamples >> sortGraphABCD [
	<gtExample>
	| sortGraph |
	sortGraph := LbSortGraphBuilder new
		parseAndAdd: 'A ⊆ B';
		parseAndAdd: 'B ⊆ C';
		parseAndAdd: 'A ⊆ D';
        sortGraph.
    self assert: sortGraph equals: (self sortGraphABCDExplicit).
    self assert: sortGraph asSet equals: #(#A #B #C #D) asSet.
	self assert: (sortGraph includes: #A).
	self assert: (sortGraph includes: #B).
	self assert: (sortGraph includes: #C).
	self assert: (sortGraph includes: #D).
	self assert: (sortGraph includes: #E) not.
	self assert: (sortGraph is: #A subsortOf: #A).
	self assert: (sortGraph is: #A subsortOf: #B).
	self assert: (sortGraph is: #B subsortOf: #C).
	self assert: (sortGraph is: #A subsortOf: #D).
	self assert: (sortGraph is: #A subsortOf: #C).
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

{ #category : #accessing }
LbSortGraphExamples >> sortGraphUnion [
	<gtExample>
	| sg1 sg2 union |
	sg1 := self sortGraphABCD.
	sg2 := self sortGraphAXY.
	union := (sg1 union: sg2).
	self assert: union equals: (sg2 union: sg1).
	self assert: (union includes: #A).
	self assert: (union includes: #X).
	self assert: (union is: #A subsortOf: #C).
	self assert: (union is: #A subsortOf: #Y).
	self assert: (union union: union) equals: union.
	self assert: (union union: self emptySortGraph) equals: union.
	self assert: (self emptySortGraph union: union) equals: union.
	^ union
]
