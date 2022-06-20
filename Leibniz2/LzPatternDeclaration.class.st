Class {
	#name : #LzPatternDeclaration,
	#superclass : #LzDeclarationWithVariables,
	#instVars : [
		'term'
	],
	#category : #'Leibniz2-Declarations'
}

{ #category : #converting }
LzPatternDeclaration >> addBodyAsRopedTextTo: aRopedText [
	term addAsRopedTextTo: aRopedText
]

{ #category : #constructing }
LzPatternDeclaration >> buildFor: aSignature [
	^ self term
		buildFor: aSignature
		variables: (aSignature parsedVariables:  self variables)
]

{ #category : #printing }
LzPatternDeclaration >> printBodyAsLeibnizSyntaxOn: aStream [
	term printAsLeibnizSyntaxOn: aStream
]

{ #category : #accessing }
LzPatternDeclaration >> term [
	^ term
]

{ #category : #accessing }
LzPatternDeclaration >> term: anObject [
	term := anObject
]

{ #category : #accessing }
LzPatternDeclaration >> valueSlots [
	^ #(term variables)
]
