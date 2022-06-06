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
		aStream nextPutAll: each.
		aStream << ', ' ].
	aStream nextPutAll: termTypes last
]

{ #category : #accessing }
LzSpecialTermsDeclaration >> termTypes [
	^ termTypes
]

{ #category : #accessing }
LzSpecialTermsDeclaration >> termTypes: aSymbol [
	termTypes := aSymbol 
]
