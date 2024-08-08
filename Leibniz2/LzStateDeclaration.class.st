Class {
	#name : #LzStateDeclaration,
	#superclass : #LzDeclaration,
	#instVars : [
		'sort',
		'name'
	],
	#category : #'Leibniz2-Declarations'
}

{ #category : #converting }
LzStateDeclaration >> addAsRopedTextTo: aRopedText [
	self
		do: [ :t |
			name addAsRopedTextTo: t.
			t append:
				(':' asRopedText attribute: LzColonAttribute new).
			self
				do: [ :tt | sort addAsRopedTextTo: tt ]
				to: t
				withAttribute: LzSortAttribute new ]
		to: aRopedText
		withAttribute: LzVarDeclarationAttribute new
]

{ #category : #accessing }
LzStateDeclaration >> name [
	^ name
]

{ #category : #accessing }
LzStateDeclaration >> name: anObject [
	name := anObject
]

{ #category : #constructing }
LzStateDeclaration >> objectFor: aContext [
	^ aContext signature
		varTerm: self name
		variables: Dictionary new
]

{ #category : #printing }
LzStateDeclaration >> printAsLeibnizSyntaxOn: aStream [
	name printAsLeibnizSyntaxOn: aStream.
	aStream nextPut: $:.
	sort printAsLeibnizSyntaxOn: aStream.
]

{ #category : #accessing }
LzStateDeclaration >> sort [

	^ sort
]

{ #category : #accessing }
LzStateDeclaration >> sort: anObject [

	sort := anObject
]

{ #category : #accessing }
LzStateDeclaration >> valueSlots [
	^ #(name sort)
]
