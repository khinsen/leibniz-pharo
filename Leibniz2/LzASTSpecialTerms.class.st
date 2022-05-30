Class {
	#name : #LzASTSpecialTerms,
	#superclass : #LzASTNode,
	#instVars : [
		'termTypes'
	],
	#category : #'Leibniz2-Parser'
}

{ #category : #printing }
LzASTSpecialTerms >> printAsLeibnizSyntaxOn: aStream [
	termTypes printOn: aStream
]

{ #category : #accessing }
LzASTSpecialTerms >> termTypes [
	^ termTypes
]

{ #category : #accessing }
LzASTSpecialTerms >> termTypes: aSymbol [
	termTypes := aSymbol 
]
