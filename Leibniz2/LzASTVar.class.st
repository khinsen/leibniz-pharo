Class {
	#name : #LzASTVar,
	#superclass : #LzASTNode,
	#instVars : [
		'sort',
		'name'
	],
	#category : #'Leibniz2-Parser'
}

{ #category : #testing }
LzASTVar >> isSortVar [
	^ name asSymbol endsWith: '__' 
]

{ #category : #accessing }
LzASTVar >> name [
	^ name
]

{ #category : #accessing }
LzASTVar >> name: anObject [
	name := anObject
]

{ #category : #printing }
LzASTVar >> printAsLeibnizSyntaxOn: aStream [
	name printAsLeibnizSyntaxOn: aStream.
	aStream nextPut: $:.
	sort printAsLeibnizSyntaxOn: aStream.
]

{ #category : #accessing }
LzASTVar >> sort [

	^ sort
]

{ #category : #accessing }
LzASTVar >> sort: anObject [

	sort := anObject
]

{ #category : #accessing }
LzASTVar >> valueSlots [
	^ #(name sort)
]
