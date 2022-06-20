Class {
	#name : #LzSpecialTermsDeclaration,
	#superclass : #LzDeclaration,
	#instVars : [
		'termTypes'
	],
	#category : #'Leibniz2-Declarations'
}

{ #category : #converting }
LzSpecialTermsDeclaration >> addAsRopedTextTo: aRopedText [
	termTypes do: [ :each |
		aRopedText append: (each asRopedText attribute: LzSpecialTermAttribute new) ]
	separatedBy: [
		aRopedText append: ', ' asRopedText ]
]

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
