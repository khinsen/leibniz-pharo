Class {
	#name : #LzVarTermBlueprint,
	#superclass : #LzTermBlueprint,
	#instVars : [
		'name'
	],
	#category : #'Leibniz2-Parser'
}

{ #category : #accessing }
LzVarTermBlueprint >> name [
	^ name
]

{ #category : #accessing }
LzVarTermBlueprint >> name: aVarName [
	name := aVarName
]
