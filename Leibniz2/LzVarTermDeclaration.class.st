Class {
	#name : #LzVarTermDeclaration,
	#superclass : #LzTermDeclaration,
	#instVars : [
		'name'
	],
	#category : #'Leibniz2-Declarations'
}

{ #category : #constructing }
LzVarTermDeclaration >> buildFor: aSignature variables: aDictionary [
	^ aSignature varTerm: self name variables: aDictionary
]

{ #category : #accessing }
LzVarTermDeclaration >> name [
	^ name
]

{ #category : #accessing }
LzVarTermDeclaration >> name: aVarName [
	name := aVarName
]

{ #category : #printing }
LzVarTermDeclaration >> printAsLeibnizSyntaxOn: aStream [
	aStream nextPutAll: name asSymbol
]
