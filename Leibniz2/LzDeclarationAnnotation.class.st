Class {
	#name : #LzDeclarationAnnotation,
	#superclass : #LzDeclaration,
	#instVars : [
		'declaration'
	],
	#category : #'Leibniz2-Declarations'
}

{ #category : #converting }
LzDeclarationAnnotation >> addAsRopedTextTo: aRopedText [
	self declaration addAsRopedTextTo: aRopedText
]

{ #category : #accessing }
LzDeclarationAnnotation >> declaration [
	^ declaration
]

{ #category : #visiting }
LzDeclarationAnnotation >> declaration: aDeclaration [
	declaration := aDeclaration 
]

{ #category : #testing }
LzDeclarationAnnotation >> definesContext [
	^ self declaration definesContext
]

{ #category : #printing }
LzDeclarationAnnotation >> printAsLeibnizSyntaxOn: aStream [
	self declaration printAsLeibnizSyntaxOn: aStream
]
