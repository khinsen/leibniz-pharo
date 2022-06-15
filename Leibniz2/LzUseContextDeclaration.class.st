Class {
	#name : #LzUseContextDeclaration,
	#superclass : #LzDeclaration,
	#instVars : [
		'contextName'
	],
	#category : #'Leibniz2-Declarations'
}

{ #category : #accessing }
LzUseContextDeclaration >> contextName [
	^ contextName
]

{ #category : #accessing }
LzUseContextDeclaration >> contextName: aString [
	contextName := aString
]

{ #category : #printing }
LzUseContextDeclaration >> printAsLeibnizSyntaxOn: aStream [
	contextName printOn: aStream
]
