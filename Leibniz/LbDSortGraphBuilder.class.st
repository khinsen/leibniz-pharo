Class {
	#name : 'LbDSortGraphBuilder',
	#superclass : 'Object',
	#instVars : [
		'sortContextBuilder',
		'sortContext'
	],
	#category : 'Leibniz-7-DependentSorts'
}

{ #category : 'instance creation' }
LbDSortGraphBuilder class >> fromSortContext: aContext [
	^ self new
		addSortContext: aContext;
		yourself
]

{ #category : 'adding' }
LbDSortGraphBuilder >> addSortContext: aContext [
	sortContextBuilder include: aContext mode: #extend
]

{ #category : 'adding' }
LbDSortGraphBuilder >> addSortGraph: aSortGraph [
	self addSortContext:  aSortGraph sortContext
]

{ #category : 'building' }
LbDSortGraphBuilder >> buildSortContext [
	| sortSort |
	sortContext := sortContextBuilder context.
	[ sortSort := sortContext sortGraph sortNamed: #sort ]
		on: Error
		do: [ self error: 'No sorts in sort context.' ].
	self
		assert: (sortSort kind maximalSorts = (Set with: sortSort))
		description: 'Sort sort may not have supersorts'.
]

{ #category : 'initializing' }
LbDSortGraphBuilder >> initialize [
	| basicSortContext |
	basicSortContext := (LbContextBuilder name: 'sorts')
							parseAndAddSort: 'sort';
							context.
	sortContextBuilder := LbContextBuilder name: 'sorts'.
	self addSortContext: basicSortContext
]

{ #category : 'accessing' }
LbDSortGraphBuilder >> parseAndAdd: aString [
	"Note: this works for plain sorts only.
	It's a quick hack to re-use code for constructing LbSortGraphs"
	| declaration partialSortContext |
	declaration := (LbParser newStartingAt: #sortOrSubsort)
					parse: aString.
	declaration isPetit2Failure ifTrue:
		[ self error: declaration message, ' after ',
				 (aString sliceFrom: 1 to: declaration position) ].
	declaration size = 1 ifTrue: [
		partialSortContext := (LbContextBuilder name: 'temp')
								parseAndAddSort: 'sort';
								parseAndAddOp: aString, ' : sort';
								context ].
	declaration size = 2 ifTrue: [
		| sort1 sort2 |
		sort1 := declaration first
			value: LbFakeSignatureForSortParser new
			value: Dictionary new.
		sort2 := declaration second
			value: LbFakeSignatureForSortParser new
			value: Dictionary new.
		partialSortContext := (LbContextBuilder name: 'temp')
								parseAndAddSort: 'sort';
								parseAndAddOp: sort1, ' : sort';
								parseAndAddOp: sort2, ' : sort';
								parseAndAddAxiom: aString;
								context ].
	self addSortContext: partialSortContext
]

{ #category : 'building' }
LbDSortGraphBuilder >> sortGraph [
	self buildSortContext.
	^ LbDSortGraph sortContext: sortContext
]
