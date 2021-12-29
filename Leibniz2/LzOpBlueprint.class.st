Class {
	#name : #LzOpBlueprint,
	#superclass : #LzBlueprint,
	#instVars : [
		'sort',
		'args',
		'name',
		'variables'
	],
	#category : #'Leibniz2-Parser'
}

{ #category : #accessing }
LzOpBlueprint >> args [

	^ args
]

{ #category : #accessing }
LzOpBlueprint >> args: anObject [

	args := anObject
]

{ #category : #accessing }
LzOpBlueprint >> fieldNames [
	^ #(name variables args sort)
]

{ #category : #accessing }
LzOpBlueprint >> name [

	^ name
]

{ #category : #accessing }
LzOpBlueprint >> name: anObject [

	name := anObject
]

{ #category : #accessing }
LzOpBlueprint >> sort [

	^ sort
]

{ #category : #accessing }
LzOpBlueprint >> sort: anObject [

	sort := anObject
]

{ #category : #accessing }
LzOpBlueprint >> variables [
	^ variables
]

{ #category : #accessing }
LzOpBlueprint >> variables: aCollection [
	variables := aCollection
]
