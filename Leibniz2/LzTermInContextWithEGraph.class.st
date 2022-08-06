Class {
	#name : #LzTermInContextWithEGraph,
	#superclass : #LzTermInContext,
	#instVars : [
		'eGraph'
	],
	#category : #'Leibniz2-Terms'
}

{ #category : #constructing }
LzTermInContextWithEGraph >> constructEGraph [
	eGraph := LzEGraph new
		context: context.
	term asENodeIn: eGraph.
	eGraph saturateFromRewriteSystem: context rewriteSystemWithEqualityAxioms.
]

{ #category : #accessing }
LzTermInContextWithEGraph >> eGraph [
	eGraph ifNil: [ self constructEGraph ].
	^ eGraph
]

{ #category : #inspecting }
LzTermInContextWithEGraph >> gtEquivalentTermsFor: aView [
	<gtView>
	^ aView forward
		title: 'Equivalent terms';
		priority: 2;
		object: [ self eGraph classForId: (self term asENodeIn: self eGraph) ];
		view: #gtTermsFor:;
		yourself
]
