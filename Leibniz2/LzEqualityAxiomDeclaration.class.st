Class {
	#name : #LzEqualityAxiomDeclaration,
	#superclass : #LzAxiomDeclaration,
	#instVars : [
		'left',
		'right',
		'condition'
	],
	#category : #'Leibniz2-Declarations'
}

{ #category : #converting }
LzEqualityAxiomDeclaration >> addBodyAsRopedTextTo: aRopedText [
	left addAsRopedTextTo: aRopedText.
	aRopedText append:
		(' = ' asRopedText attribute: LzEqualSignAttribute new).
	right addAsRopedTextTo: aRopedText.
	condition ifNotNil: [ :c |
		aRopedText append:
			(' | ' asRopedText attribute: LzConditionAttribute new).
		c addAsRopedTextTo: aRopedText ] 
]

{ #category : #printing }
LzEqualityAxiomDeclaration >> asLeibnizSyntaxTextColored: aColor [.
	^ (self variables: variables asLeibnizSyntaxTextColored: aColor),
		(self bodyAsLeibnizSyntaxTextColored: aColor)
]

{ #category : #accessing }
LzEqualityAxiomDeclaration >> axiomClass [
	^ LzEqualityAxiom
]

{ #category : #accessing }
LzEqualityAxiomDeclaration >> condition [
	^ condition
]

{ #category : #accessing }
LzEqualityAxiomDeclaration >> condition: aTermNode [
	condition := aTermNode
]

{ #category : #accessing }
LzEqualityAxiomDeclaration >> left [
	^ left
]

{ #category : #accessing }
LzEqualityAxiomDeclaration >> left: aTermNode [
	left := aTermNode
]

{ #category : #printing }
LzEqualityAxiomDeclaration >> printBodyAsLeibnizSyntaxOn: aStream [
	left printAsLeibnizSyntaxOn: aStream.
	aStream nextPutAll: ' = '.
	right printAsLeibnizSyntaxOn: aStream.
	condition ifNotNil: [ :c |
		aStream nextPutAll: ' | '.
		c printAsLeibnizSyntaxOn: aStream ]
]

{ #category : #accessing }
LzEqualityAxiomDeclaration >> right [
	^ right
]

{ #category : #accessing }
LzEqualityAxiomDeclaration >> right: aTermNode [
	right := aTermNode
]

{ #category : #accessing }
LzEqualityAxiomDeclaration >> terms [
	^ Dictionary
		with: #left -> self left
		with: #right -> self right
]
