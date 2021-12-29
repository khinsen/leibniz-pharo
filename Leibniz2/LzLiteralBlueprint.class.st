Class {
	#name : #LzLiteralBlueprint,
	#superclass : #LzTermBlueprint,
	#instVars : [
		'value',
		'sort'
	],
	#category : #'Leibniz2-Parser'
}

{ #category : #accessing }
LzLiteralBlueprint >> fieldNames [
	^ #(sort value)
]

{ #category : #printing }
LzLiteralBlueprint >> printOn: aStream [
	super printOn: aStream.
	aStream nextPut: $(.
	sort printOn: aStream.
	aStream nextPutAll: ': '.
	value printOn: aStream.
	aStream nextPut: $)
]

{ #category : #accessing }
LzLiteralBlueprint >> sort [

	^ sort
]

{ #category : #accessing }
LzLiteralBlueprint >> sort: anObject [

	sort := anObject
]

{ #category : #accessing }
LzLiteralBlueprint >> value [
	^ value
]

{ #category : #accessing }
LzLiteralBlueprint >> value: anObject [
	value := anObject
]
