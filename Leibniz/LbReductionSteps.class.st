Class {
	#name : #LbReductionSteps,
	#superclass : #Object,
	#instVars : [
		'rewriteSystem',
		'steps'
	],
	#category : 'Leibniz-4-Rules'
}

{ #category : #accessing }
LbReductionSteps >> finalTerm [
	^ steps last finalTerm
]

{ #category : #accessing }
LbReductionSteps >> gtStepsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Steps' translated;
		priority: 0;
		items: [ steps ];
		column: 'Initial' lbCode: [ :each |
			each initialTerm asLeibnizSyntaxString ];
		column: 'Final' lbCode: [ :each |
			each finalTerm asLeibnizSyntaxString ];
		yourself
]

{ #category : #accessing }
LbReductionSteps >> initialTerm [
	^ steps first initialTerm
]

{ #category : #accessing }
LbReductionSteps >> rewriteSystem: aRewriteSystem [
	rewriteSystem := aRewriteSystem
]

{ #category : #accessing }
LbReductionSteps >> steps [
	^ steps
]

{ #category : #rewriting }
LbReductionSteps >> term: aTerm [
	| step currentTerm |
	step := LbReductionStep new
				rewriteSystem: rewriteSystem;
				term: aTerm.
	currentTerm := step finalTerm.
	steps := OrderedCollection with: step.
	[ step isFinal ] whileFalse: [
		step := LbReductionStep new
					rewriteSystem: rewriteSystem;
					term: currentTerm.
		currentTerm := step finalTerm.
		steps add: step ]
]
