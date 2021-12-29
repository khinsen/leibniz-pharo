Class {
	#name : #LzVarBlueprint,
	#superclass : #LzBlueprint,
	#instVars : [
		'sort',
		'name'
	],
	#category : #'Leibniz2-Parser'
}

{ #category : #accessing }
LzVarBlueprint >> fieldNames [
	^ #(name sort)
]

{ #category : #accessing }
LzVarBlueprint >> name [

	^ name
]

{ #category : #accessing }
LzVarBlueprint >> name: anObject [

	name := anObject
]

{ #category : #accessing }
LzVarBlueprint >> sort [

	^ sort
]

{ #category : #accessing }
LzVarBlueprint >> sort: anObject [

	sort := anObject
]
