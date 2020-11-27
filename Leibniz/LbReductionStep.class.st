Class {
	#name : #LbReductionStep,
	#superclass : #Object,
	#instVars : [
		'initialTerm',
		'finalTerm',
		'rewriteSystem',
		'argReductionSteps'
	],
	#category : #'Leibniz-4-Rules'
}

{ #category : #accessing }
LbReductionStep >> finalTerm [
	^ finalTerm
]

{ #category : #accessing }
LbReductionStep >> initialTerm [
	^ initialTerm
]

{ #category : #testing }
LbReductionStep >> isFinal [
	^ initialTerm = finalTerm
]

{ #category : #accessing }
LbReductionStep >> rewriteSystem: aRewriteSystem [
	rewriteSystem := aRewriteSystem
]

{ #category : #rewriting }
LbReductionStep >> term: aTerm [
	initialTerm := aTerm.
	argReductionSteps := aTerm arguments collect: [ :each |
		LbReductionSteps new
			rewriteSystem: rewriteSystem;
			term: each ].
	finalTerm := rewriteSystem
		rewriteHeadOnce: (aTerm withTransformedArgs:
			(argReductionSteps collect: [ :each | each finalTerm ]))
]
