Class {
	#name : #LzUseContextDeclaration,
	#superclass : #LzDeclaration,
	#instVars : [
		'contextName',
		'subcontext'
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

{ #category : #accessing }
LzUseContextDeclaration >> subcontext [
	^ subcontext
]

{ #category : #accessing }
LzUseContextDeclaration >> subcontext: aString [
	subcontext := aString
]
