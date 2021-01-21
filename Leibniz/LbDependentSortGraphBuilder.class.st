Class {
	#name : #LbDependentSortGraphBuilder,
	#superclass : #Object,
	#instVars : [
		'sortContextBuilder',
		'sortContext'
	],
	#category : #'Leibniz-7-DependentSorts'
}

{ #category : #adding }
LbDependentSortGraphBuilder >> addSortContext: aContext [
	sortContextBuilder include: aContext mode: #extend
]

{ #category : #building }
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

{ #category : #initializing }
LbDependentSortGraphBuilder >> initialize [
	sortContextBuilder := LbContextBuilder name: 'sorts'.
]

{ #category : #building }
LbDependentSortGraphBuilder >> sortGraph [
	self buildSortContext.
	^ LbDependentSortGraph sortContext: sortContext
]
