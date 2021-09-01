Class {
	#name : 'LbDependentSortGraphBuilder',
	#superclass : 'Object',
	#instVars : [
		'sortContextBuilder',
		'sortContext'
	],
	#category : 'Leibniz-7-DependentSorts'
}

{ #category : 'instance creation' }
LbDependentSortGraphBuilder class >> fromSortContext: aContext [
	^ self new
		addSortContext: aContext;
		yourself
]

{ #category : 'adding' }
LbDependentSortGraphBuilder >> addSortContext: aContext [
	sortContextBuilder include: aContext mode: #extend
]

{ #category : 'building' }
LbDependentSortGraphBuilder >> buildSortContext [
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
LbDependentSortGraphBuilder >> initialize [
	| basicSortContext |
	basicSortContext := (LbContextBuilder name: 'sorts')
							parseAndAddSort: 'sort';
							context.
	sortContextBuilder := LbContextBuilder name: 'sorts'.
	self addSortContext: basicSortContext
]

{ #category : 'accessing' }
LbDependentSortGraphBuilder >> parseAndAdd: aString [
	| declaration partialSortContext |
	declaration := (LbParser newStartingAt: #sortOrSubsort)
					parse: aString.
	declaration size = 1 ifTrue: [
		partialSortContext := (LbContextBuilder name: 'temp')
								parseAndAddSort: 'sort';
								parseAndAddOp: aString, ' : sort';
								context ].
	declaration size = 2 ifTrue: [
		partialSortContext := (LbContextBuilder name: 'temp')
								parseAndAddSort: 'sort';
								parseAndAddOp: declaration first, ' : sort';
								parseAndAddOp: declaration second, ' : sort';
								parseAndAddAxiom: aString;
								context ].
	self addSortContext: partialSortContext
]

{ #category : 'building' }
LbDependentSortGraphBuilder >> sortGraph [
	self buildSortContext.
	^ LbDependentSortGraph sortContext: sortContext
]
