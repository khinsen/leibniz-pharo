Class {
	#name : #LzVarDeclaration,
	#superclass : #LzDeclaration,
	#instVars : [
		'sort',
		'name'
	],
	#category : #'Leibniz2-Declarations'
}

{ #category : #testing }
LzVarDeclaration >> isSortVar [
	^ name asSymbol endsWith: '__' 
]

{ #category : #accessing }
LzVarDeclaration >> name [
	^ name
]

{ #category : #accessing }
LzVarDeclaration >> name: anObject [
	name := anObject
]

{ #category : #printing }
LzVarDeclaration >> printAsLeibnizSyntaxOn: aStream [
	name printAsLeibnizSyntaxOn: aStream.
	aStream nextPut: $:.
	sort printAsLeibnizSyntaxOn: aStream.
]

{ #category : #accessing }
LzVarDeclaration >> sort [

	^ sort
]

{ #category : #accessing }
LzVarDeclaration >> sort: anObject [

	sort := anObject
]

{ #category : #accessing }
LzVarDeclaration >> valueSlots [
	^ #(name sort)
]
