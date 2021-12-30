Class {
	#name : #LzASTLiteral,
	#superclass : #LzASTTerm,
	#instVars : [
		'value',
		'sort'
	],
	#category : #'Leibniz2-Parser'
}

{ #category : #accessing }
LzASTLiteral >> fieldNames [
	^ #(sort value)
]

{ #category : #printing }
LzASTLiteral >> printOn: aStream [
	super printOn: aStream.
	aStream nextPut: $(.
	sort printOn: aStream.
	aStream nextPutAll: ': '.
	value printOn: aStream.
	aStream nextPut: $)
]

{ #category : #accessing }
LzASTLiteral >> sort [

	^ sort
]

{ #category : #accessing }
LzASTLiteral >> sort: anObject [

	sort := anObject
]

{ #category : #accessing }
LzASTLiteral >> value [
	^ value
]

{ #category : #accessing }
LzASTLiteral >> value: anObject [
	value := anObject
]
