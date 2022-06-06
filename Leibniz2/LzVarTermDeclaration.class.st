Class {
	#name : #LzVarTermDeclaration,
	#superclass : #LzTermDeclaration,
	#instVars : [
		'name',
		'sort'
	],
	#category : #'Leibniz2-Declarations'
}

{ #category : #constructing }
LzVarTermDeclaration >> buildFor: aSignature variables: aDictionary [
	^ aSignature varTerm: self name variables: aDictionary
]

{ #category : #testing }
LzVarTermDeclaration >> includesVarDeclaration [
	^ sort isNotNil
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
	aStream nextPutAll: name asSymbol.
	self includesVarDeclaration ifTrue: [
		aStream nextPut: $:.
		self sort printAsLeibnizSyntaxOn: aStream ]
]

{ #category : #accessing }
LzVarTermDeclaration >> sort [
	^ sort
]

{ #category : #accessing }
LzVarTermDeclaration >> sort: aTermDeclaration [
	sort := aTermDeclaration
]
