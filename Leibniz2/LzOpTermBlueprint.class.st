Class {
	#name : #LzOpTermBlueprint,
	#superclass : #LzTermBlueprint,
	#instVars : [
		'opName',
		'args'
	],
	#category : #'Leibniz2-Parser'
}

{ #category : #accessing }
LzOpTermBlueprint >> args [

	^ args
]

{ #category : #accessing }
LzOpTermBlueprint >> args: anObject [

	args := anObject
]

{ #category : #accessing }
LzOpTermBlueprint >> fieldNames [
	^ #(opName args)
]

{ #category : #accessing }
LzOpTermBlueprint >> opName [

	^ opName
]

{ #category : #acccessing }
LzOpTermBlueprint >> opName: anOpName [
	opName := anOpName 
]
