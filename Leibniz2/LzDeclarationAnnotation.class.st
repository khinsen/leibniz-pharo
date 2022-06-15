Class {
	#name : #LzDeclarationAnnotation,
	#superclass : #LzDeclaration,
	#instVars : [
		'declaration'
	],
	#category : #'Leibniz2-Declarations'
}

{ #category : #printing }
LzDeclarationAnnotation >> asLeibnizSyntaxTextColored: aColor [
	^ self declaration asLeibnizSyntaxTextColored: aColor
]

{ #category : #accessing }
LzDeclarationAnnotation >> declaration [
	^ declaration
]

{ #category : #visiting }
LzDeclarationAnnotation >> declaration: aDeclaration [
	declaration := aDeclaration 
]

{ #category : #printing }
LzDeclarationAnnotation >> printAsLeibnizSyntaxOn: aStream [
	self declaration printAsLeibnizSyntaxOn: aStream
]
