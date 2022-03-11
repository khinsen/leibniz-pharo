Class {
	#name : #LzASTVarTerm,
	#superclass : #LzASTTerm,
	#instVars : [
		'name'
	],
	#category : #'Leibniz2-Parser'
}

{ #category : #constructing }
LzASTVarTerm >> buildFor: aSignature variables: aDictionary [
	^ aSignature varTerm: self name variables: aDictionary
]

{ #category : #accessing }
LzASTVarTerm >> name [
	^ name
]

{ #category : #accessing }
LzASTVarTerm >> name: aVarName [
	name := aVarName
]

{ #category : #printing }
LzASTVarTerm >> printAsLeibnizSyntaxOn: aStream [
	aStream nextPutAll: name asSymbol
]
