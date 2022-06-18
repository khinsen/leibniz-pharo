Class {
	#name : #LzSpecialTermsDeclaration,
	#superclass : #LzDeclaration,
	#instVars : [
		'termTypes'
	],
	#category : #'Leibniz2-Declarations'
}

{ #category : #converting }
LzSpecialTermsDeclaration >> adAsRopedTextTo: aRopedText [
	termTypes allButLastDo: [ :each |
		aRopedText appendString: each.
		aRopedText appendString: ', ' ].
	aRopedText appendString: termTypes last
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
