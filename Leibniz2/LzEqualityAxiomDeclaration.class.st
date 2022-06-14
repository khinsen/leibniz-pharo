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

{ #category : #accessing }
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

{ #category : #accessing }
LzEqualityAxiomDeclaration >> printAsLeibnizSyntaxOn: aStream [
	self printVariables: variables asLeibnizSyntaxOn: aStream.
	self printBodyAsLeibnizSyntaxOn: aStream
]

{ #category : #accessing }
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
