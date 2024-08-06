Class {
	#name : #LzCompoundStepTermDeclaration,
	#superclass : #LzTermDeclaration,
	#instVars : [
		'steps'
	],
	#category : #'Leibniz2-Declarations'
}

{ #category : #converting }
LzCompoundStepTermDeclaration >> addAsRopedTextTo: aRopedText [
	aRopedText append: '{. ' asRopedText.
	1 to: steps size do: [ :eachIndex |
		| step |
		step := steps at: eachIndex.
		step first addAsRopedTextTo: aRopedText.
		step second ifNotNil: [ :v |
			aRopedText append: ' ⇒ ' asRopedText.
			v addAsRopedTextTo: aRopedText ].
		eachIndex < steps size ifTrue: [ aRopedText append: ', ' asRopedText ] ].
	aRopedText append: ' .}' asRopedText
]

{ #category : #constructing }
LzCompoundStepTermDeclaration >> buildFor: aSignature variables: aDictionary [
	| vars |
	vars := aDictionary copy.
	^ aSignature compoundStepTerm:
		(self steps collect: [ :each |
			| term sort var |
			term := each first buildFor: aSignature variables: vars.
			each second ifNotNil: [ :v |
			  sort := aSignature sortForVar: v name variables: vars.
			  vars at: v name put: sort.
			  var := v name ].
			{ term . var . sort } ])
]

{ #category : #accessing }
LzCompoundStepTermDeclaration >> gtStepsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Steps';
		priority: 2;
		items: [ steps ];
		column: 'Term' text: [ :each |
			each first asLeibnizSyntax ];
		column: 'Var' text: [ :each |
			each second ifNil: ['']
				ifNotNil: [ :v | v asLeibnizSyntax ]];
		yourself
]

{ #category : #accessing }
LzCompoundStepTermDeclaration >> steps [
	^ steps
]

{ #category : #accessing }
LzCompoundStepTermDeclaration >> steps: anObject [
	steps := anObject
]
