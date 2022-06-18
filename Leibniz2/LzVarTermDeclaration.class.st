Class {
	#name : #LzVarTermDeclaration,
	#superclass : #LzTermDeclaration,
	#instVars : [
		'name',
		'sort'
	],
	#category : #'Leibniz2-Declarations'
}

{ #category : #converting }
LzVarTermDeclaration >> addAsRopedTextTo: aRopedText [
	name addAsRopedTextTo: aRopedText.
	self includesVarDeclaration ifTrue: [
		| size |
		size := aRopedText size.
		aRopedText append: ':' asRopedText.
		self sort addAsRopedTextTo: aRopedText.
		aRopedText
			attribute: LzVarDeclarationAttribute new
			from: size + 1 to: aRopedText size + 1 ]
]

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
