Class {
	#name : #LbPhlowColumnedTreeView,
	#superclass : #GtPhlowColumnedTreeView,
	#instVars : [
		'initiallyExpandedRootNodes'
	],
	#category : 'Leibniz-0-Infrastructure'
}

{ #category : #'api - scripting tree node expansion' }
LbPhlowColumnedTreeView >> expandItems: anArray [
	initiallyExpandedRootNodes := anArray
]

{ #category : #'private - actions' }
LbPhlowColumnedTreeView >> expandTree: aBrColumnedTree [ 
	aBrColumnedTree collapseAll.
	aBrColumnedTree viewModel root childrenNodes do: [ :each |
		(initiallyExpandedRootNodes includes: each value)
			ifTrue: [ each expand ] ]
]
