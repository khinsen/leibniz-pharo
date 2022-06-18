Class {
	#name : #LzDeclarationWithVariables,
	#superclass : #LzDeclaration,
	#instVars : [
		'variables'
	],
	#category : #'Leibniz2-Declarations'
}

{ #category : #converting }
LzDeclarationWithVariables >> addAsRopedTextTo: aRopedText [
	self addVariablesAsRopedTextTo: aRopedText.
	self addBodyAsRopedTextTo: aRopedText
]

{ #category : #converting }
LzDeclarationWithVariables >> addBodyAsRopedTextTo: aRopedText [
	self subclassResponsibility
]

{ #category : #converting }
LzDeclarationWithVariables >> addVariablesAsRopedTextTo: aRopedText [
	(variables reject: #isDerived)
		do: [ :var |
			var addAsRopedTextTo: aRopedText.
			aRopedText append:
				(', ' asRopedText attribute: LzVarDeclarationAttribute new) ]
]

{ #category : #printing }
LzDeclarationWithVariables >> printAsLeibnizSyntaxOn: aStream [
	self printVariablesAsLeibnizSyntaxOn: aStream.
	self printBodyAsLeibnizSyntaxOn: aStream
]

{ #category : #printing }
LzDeclarationWithVariables >> printVariablesAsLeibnizSyntaxOn: aStream [
	(variables reject: #isDerived)
		do: [ :var |
			var printAsLeibnizSyntaxOn: aStream.
			aStream nextPutAll: ', ' ]
]

{ #category : #accessing }
LzDeclarationWithVariables >> variables [

	^ variables
]

{ #category : #accessing }
LzDeclarationWithVariables >> variables: anObject [

	variables := anObject
]
