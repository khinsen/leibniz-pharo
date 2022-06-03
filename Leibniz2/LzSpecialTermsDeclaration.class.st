Class {
	#name : #LzSpecialTermsDeclaration,
	#superclass : #LzDeclaration,
	#instVars : [
		'termTypes'
	],
	#category : #'Leibniz2-Declarations'
}

{ #category : #printing }
LzSpecialTermsDeclaration >> printAsLeibnizSyntaxOn: aStream [
	termTypes allButLastDo: [ :each |
		each printOn: aStream.
		aStream << ', ' ].
	termTypes last printOn: aStream
]

{ #category : #accessing }
LzSpecialTermsDeclaration >> termTypes [
	^ termTypes
]

{ #category : #accessing }
LzSpecialTermsDeclaration >> termTypes: aSymbol [
	termTypes := aSymbol 
]
