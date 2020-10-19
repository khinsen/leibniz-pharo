"
!Sorts and kinds

Sort graphs  (${class:name=LbSortGraph}$) have two important types of subgraphs: sorts (representing themselves and their subsorts) and kinds (the connected components of a sort graph.)
"
Class {
	#name : #LbSortClassifier,
	#superclass : #Object,
	#traits : 'EqualityThroughVariables',
	#classTraits : 'EqualityThroughVariables classTrait',
	#instVars : [
		'sortGraph'
	],
	#category : #'Leibniz-1-SortGraphs'
}

{ #category : #printing }
LbSortClassifier >> asLeibnizSyntaxString [
	^ String streamContents: [ :s | self printAsLeibnizSyntaxOn: s ]
]

{ #category : #inspecting }
LbSortClassifier >> gtGraphFor: aView [
	<gtView>
	^ aView mondrian
		title: 'Tree view';
		priority: 0;
		painting: [ :view | 
			| edges |
			view nodes
				shape: [ :x | sortGraph nodeForSort: x highlight: x = self ];
				with: self kind asSet.
			view edges
				shape: [ :x | sortGraph grayArrow ];
				fromCenterTop;
				toCenterBottom;
				connect: (sortGraph graphEdgesForSubset: self kind asSet)
					from: #key
					to: #value.
			view layout
				custom: (GtGradVerticalDominanceTreeLayout new reverse: true) ]
]

{ #category : #accessing }
LbSortClassifier >> kind [
	self subclassResponsibility
]

{ #category : #accessing }
LbSortClassifier >> size [
	^ self asSet size
]

{ #category : #accessing }
LbSortClassifier >> sortGraph [
	^sortGraph
]
