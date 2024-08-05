Class {
	#name : #LzStepTermDeclaration,
	#superclass : #LzTermDeclaration,
	#instVars : [
		'steps'
	],
	#category : #'Leibniz2-Declarations'
}

{ #category : #converting }
LzStepTermDeclaration >> addAsRopedTextTo: aRopedText [
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
LzStepTermDeclaration >> buildFor: aSignature variables: aDictionary [
"	^ aSignature
		stepTerm: self."
]

{ #category : #accessing }
LzStepTermDeclaration >> gtStepsFor: aView [
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
LzStepTermDeclaration >> steps [
	^ steps
]

{ #category : #accessing }
LzStepTermDeclaration >> steps: anObject [
	steps := anObject
]
