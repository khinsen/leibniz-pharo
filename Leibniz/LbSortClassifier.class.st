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

{ #category : #accessing }
LbSortClassifier >> asSet [
	self subclassResponsibility
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
				shape: [ :x | sortGraph graphNodeForSort: x highlight: x = self ];
				with: self kind asSet.
			view edges
				shape: [ :x | sortGraph graphArrowForSubsortRelation: x ];
				fromCenterTop;
				toCenterBottom;
				connect: (sortGraph graphEdgesForSubset: self kind asSet)
					from: #subsort
					to: #supersort.
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

{ #category : #comparing }
LbSortClassifier >> sortBefore: aSortClassifier [
	"This is a total order used for uniquely sorting declarations,
	 to be distinguished from the partial order defined by <="
	self subclassResponsibility
]

{ #category : #accessing }
LbSortClassifier >> sortGraph [
	^sortGraph
]
