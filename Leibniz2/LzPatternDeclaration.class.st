Class {
	#name : #LzPatternDeclaration,
	#superclass : #LzDeclaration,
	#instVars : [
		'term',
		'variables'
	],
	#category : #'Leibniz2-Declarations'
}

{ #category : #constructing }
LzPatternDeclaration >> buildFor: aSignature [
	^ self term
		buildFor: aSignature
		variables: (aSignature parsedVariables:  self variables)
]

{ #category : #printing }
LzPatternDeclaration >> printAsLeibnizSyntaxOn: aStream [
	variables do: [ :each |
		aStream nextPutAll: '∀ '.
		each printAsLeibnizSyntaxOn: aStream.
		aStream nextPut: Character space ].
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

{ #category : #accessing }
LzPatternDeclaration >> variables [
	^ variables
]

{ #category : #accessing }
LzPatternDeclaration >> variables: anObject [
	variables := anObject
]
