Class {
	#name : #LzPhlowColumnedTreeView,
	#superclass : #GtPhlowColumnedTreeView,
	#instVars : [
		'initiallyExpandedRootNodes'
	],
	#category : #'Leibniz2-Infrastructure'
}

{ #category : #'api - scripting tree node expansion' }
LzPhlowColumnedTreeView >> expandItems: anArray [
	initiallyExpandedRootNodes := anArray
]

{ #category : #'private - actions' }
LzPhlowColumnedTreeView >> expandTree: aBrColumnedTree [ 
	aBrColumnedTree collapseAll.
	aBrColumnedTree viewModel root childrenNodes do: [ :each |
		(initiallyExpandedRootNodes includes: each value)
			ifTrue: [ each expand ] ]
]
