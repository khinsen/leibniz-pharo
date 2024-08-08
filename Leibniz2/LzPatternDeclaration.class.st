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

{ #category : #constructing }
LzPatternDeclaration >> buildFor: aSignature variables: aDictionary [
	| localVars |
	localVars := aSignature parsedVariables:  self variables.
	aDictionary keysAndValuesDo: [ :var :sort |
		| localSort |
		localSort := localVars at: var ifAbsent: [ sort ].
		localSort = sort ifFalse: [
			self error: 'Local var definition inconsistent with global definition' ].
		localVars at: var put: sort ].
	^ self term
		buildFor: aSignature
		variables: localVars
]

{ #category : #testing }
LzPatternDeclaration >> definesContext [
	^ false
]

{ #category : #constructing }
LzPatternDeclaration >> objectFor: aContext [
	^ LzTermInContext
		term: (aContext parsedPattern: self)
		context: aContext
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
