Class {
	#name : #LzDeclarationAnnotation,
	#superclass : #LzDeclaration,
	#instVars : [
		'declaration'
	],
	#category : #'Leibniz2-Declarations'
}

{ #category : #accessing }
LzDeclarationAnnotation >> declaration [
	^ declaration
]

{ #category : #visiting }
LzDeclarationAnnotation >> declaration: aDeclaration [
	declaration := aDeclaration 
]

{ #category : #accessing }
LzDeclarationAnnotation >> printAsLeibnizSyntaxOn: aStream [
	self declaration printAsLeibnizSyntaxOn: aStream
]
