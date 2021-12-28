Class {
	#name : #LbReductionStep,
	#superclass : #Object,
	#instVars : [
		'initialTerm',
		'finalTerm',
		'rewriteSystem',
		'argReductionSteps',
		'termWithReducedArgs',
		'rewriteStep'
	],
	#category : 'Leibniz-4-Rules'
}

{ #category : #accessing }
LbReductionStep >> finalTerm [
	^ finalTerm
]

{ #category : #inspecting }
LbReductionStep >> gtStepsFor: aView [
	<gtView>
	^ aView columnedTree
		title: 'Steps';
		priority: 0;
		items: [ argReductionSteps asOrderedCollection
					addLast: rewriteStep;
					yourself ];
		children: #steps;
		column: 'Initial' lbCode: [ :each |
			each initialTerm asLeibnizSyntaxString ];
		column: 'Final' lbCode: [ :each |
			each finalTerm asLeibnizSyntaxString ];
		yourself
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

{ #category : #inspecting }
LbReductionStep >> steps [
	^ #()
]

{ #category : #rewriting }
LbReductionStep >> term: aTerm [
	initialTerm := aTerm.
	argReductionSteps := aTerm arguments collect: [ :each |
		LbReductionSteps new
			rewriteSystem: rewriteSystem;
			term: each ].
	termWithReducedArgs :=
		aTerm withTransformedArgs:
			(argReductionSteps collect: [ :each | each finalTerm ]).
	finalTerm := rewriteSystem
		rewriteHeadOnce: termWithReducedArgs.
	rewriteStep := LbRewriteStep new
					rewriteSystem: rewriteSystem;
					initialTerm: termWithReducedArgs;
					finalTerm: finalTerm
]
