Class {
	#name : #LzUseContextDeclaration,
	#superclass : #LzDeclaration,
	#instVars : [
		'contextName',
		'subcontext'
	],
	#category : #'Leibniz2-Declarations'
}

{ #category : #converting }
LzUseContextDeclaration >> addAsRopedTextTo: aRopedText [
	aRopedText append:
		(contextName asRopedText attribute: LzContextNameAttribute new).
	subcontext ifNotNil: [ :s |
		aRopedText append: '/' asRopedText.
		aRopedText append: (s asRopedText attribute: LzSubcontextNameAttribute new) ]
]

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
	aStream << contextName.
	subcontext ifNotNil: [ :s |
		aStream
			<< ', ';
			<< s ]
]

{ #category : #accessing }
LzUseContextDeclaration >> subcontext [
	^ subcontext
]

{ #category : #accessing }
LzUseContextDeclaration >> subcontext: aString [
	subcontext := aString
]
