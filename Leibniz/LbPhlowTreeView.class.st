Class {
	#name : #LbPhlowTreeView,
	#superclass : #GtPhlowTreeView,
	#instVars : [
		'initiallyExpandedRootNodes'
	],
	#category : 'Leibniz-0-Infrastructure'
}

{ #category : #'api - scripting tree node expansion' }
LbPhlowTreeView >> expandItems: anArray [
	initiallyExpandedRootNodes := anArray
]

{ #category : #'private - building' }
LbPhlowTreeView >> expandTree: aBrTree [ 
	aBrTree collapseAll.
	aBrTree viewModel root childrenNodes do: [ :each |
		(initiallyExpandedRootNodes includes: each value first)
			ifTrue: [ each expand ] ]
]
