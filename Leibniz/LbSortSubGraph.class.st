Class {
	#name : #LbSortSubGraph,
	#superclass : #Object,
	#traits : 'EqualityThroughVariables',
	#classTraits : 'EqualityThroughVariables classTrait',
	#instVars : [
		'sortGraph'
	],
	#category : #'Leibniz-1-SortGraphs'
}

{ #category : #inspecting }
LbSortSubGraph >> gtTreeViewFor: aView [
	<gtView>
	^ aView mondrian
		title: 'Tree view';
		priority: 0;
		painting: [ :view | 
			| edges |
			view nodes
				shape: [ :x | sortGraph nodeForSort: x ];
				with: self asSet.
			view edges
				shape: [ :x | sortGraph grayArrow ];
				fromCenterTop;
				toCenterBottom;
				connect: (sortGraph graphEdgesForSubset: self asSet)
					from: #key
					to: #value.
			view layout
				custom: (GtGradVerticalDominanceTreeLayout new reverse: true) ]
]

{ #category : #accessing }
LbSortSubGraph >> size [
	^ self asSet size
]

{ #category : #accessing }
LbSortSubGraph >> sortGraph [
	^sortGraph
]
