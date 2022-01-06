Class {
	#name : #LzPhlowTreeView,
	#superclass : #GtPhlowTreeView,
	#instVars : [
		'initiallyExpandedRootNodes'
	],
	#category : #'Leibniz2-Infrastructure'
}

{ #category : #'api - scripting tree node expansion' }
LzPhlowTreeView >> expandItems: anArray [
	initiallyExpandedRootNodes := anArray
]

{ #category : #'private - building' }
LzPhlowTreeView >> expandTree: aBrTree [ 
	aBrTree collapseAll.
	aBrTree viewModel root childrenNodes do: [ :each |
		(initiallyExpandedRootNodes includes: each value first)
			ifTrue: [ each expand ] ]
]
