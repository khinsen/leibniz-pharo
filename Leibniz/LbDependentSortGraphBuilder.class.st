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
	sortContextBuilder := (LbContextBuilder name: 'sorts')
							parseAndAddSort: 'sort'.
]

{ #category : 'accessing' }
LbDependentSortGraphBuilder >> parseAndAdd: aString [
	| declaration |
	declaration := (LbParser newStartingAt: #sortOrSubsort)
					parse: aString.
	declaration size = 1 ifTrue: [
		sortContextBuilder parseAndAddOp: aString, ' : sort'].
	declaration size = 2 ifTrue: [
		sortContextBuilder parseAndAddOp: declaration first asLeibnizSyntaxString, ' : sort'.
		sortContextBuilder parseAndAddOp: declaration second asLeibnizSyntaxString, ' : sort'.
		sortContextBuilder parseAndAddAxiom: aString ].
]

{ #category : 'building' }
LbDependentSortGraphBuilder >> sortGraph [
	self buildSortContext.
	^ LbDependentSortGraph sortContext: sortContext
]
