Class {
	#name : #LzOpENode,
	#superclass : #LzENode,
	#type : #variable,
	#instVars : [
		'opName'
	],
	#category : #'Leibniz2-EGraphs'
}

{ #category : #accessing }
LzOpENode >> opName [
	^ opName
]

{ #category : #accessing }
LzOpENode >> opName: anOpName [
	opName := anOpName
]
