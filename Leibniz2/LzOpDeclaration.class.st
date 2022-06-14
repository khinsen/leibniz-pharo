Class {
	#name : #LzOpDeclaration,
	#superclass : #LzDeclaration,
	#instVars : [
		'sort',
		'args',
		'name',
		'variables'
	],
	#category : #'Leibniz2-Declarations'
}

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
LzOpDeclaration >> printAsLeibnizSyntaxOn: aStream [
	self printVariables: variables asLeibnizSyntaxOn: aStream.
	self printBodyAsLeibnizSyntaxOn: aStream
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

{ #category : #accessing }
LzOpDeclaration >> variables [
	^ variables
]

{ #category : #accessing }
LzOpDeclaration >> variables: aCollection [
	variables := aCollection
]
