Class {
	#name : 'LbRewriteStep',
	#superclass : 'Object',
	#instVars : [
		'finalTerm',
		'initialTerm',
		'rewriteSystem'
	],
	#category : 'Leibniz-4-Rules'
}

{ #category : 'accessing' }
LbRewriteStep >> finalTerm [
	^ finalTerm
]

{ #category : 'accessing' }
LbRewriteStep >> finalTerm: aTerm [
	finalTerm := aTerm
]

{ #category : 'accessing' }
LbRewriteStep >> gtRulesFor: aView [
	<gtView>
	^ aView forward
		title: 'Matching rules';
		priority: 0;
		object: [ rewriteSystem rulesMatching: initialTerm ];
		view: #gtMatchesFor:;
		yourself
]

{ #category : 'accessing' }
LbRewriteStep >> initialTerm [
	^ initialTerm
]

{ #category : 'accessing' }
LbRewriteStep >> initialTerm: aTerm [
	initialTerm := aTerm
]

{ #category : 'accessing' }
LbRewriteStep >> rewriteSystem: aRewriteSystem [
	rewriteSystem := aRewriteSystem
]

{ #category : 'inspecting' }
LbRewriteStep >> steps [
	^ #()
]
