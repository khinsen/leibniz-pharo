Class {
	#name : #LzOpDeclaration,
	#superclass : #LzDeclarationWithVariables,
	#instVars : [
		'sort',
		'args',
		'name'
	],
	#category : #'Leibniz2-Declarations'
}

{ #category : #converting }
LzOpDeclaration >> addAsRopedTextTo: aRopedText [
	self name addForArity: args withSort: self sort asRopedTextTo: aRopedText
]

{ #category : #accessing }
LzOpDeclaration >> args [

	^ args
]

{ #category : #accessing }
LzOpDeclaration >> args: anObject [

	args := anObject
]

{ #category : #accessing }
LzOpDeclaration >> name [

	^ name
]

{ #category : #accessing }
LzOpDeclaration >> name: anObject [

	name := anObject
]

{ #category : #printing }
LzOpDeclaration >> printBodyAsLeibnizSyntaxOn: aStream [
	self name printForArity: args withSort: self sort on: aStream
]

{ #category : #accessing }
LzOpDeclaration >> sort [

	^ sort
]

{ #category : #accessing }
LzOpDeclaration >> sort: anObject [

	sort := anObject
]

{ #category : #accessing }
LzOpDeclaration >> valueSlots [
	^ #(name variables args sort)
]
