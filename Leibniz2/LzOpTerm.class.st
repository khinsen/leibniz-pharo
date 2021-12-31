Class {
	#name : #LzOpTerm,
	#superclass : #LzTerm,
	#instVars : [
		'opName',
		'sort',
		'arguments'
	],
	#category : #'Leibniz2-Leibniz2'
}

{ #category : #accessing }
LzOpTerm >> arguments [
	^ arguments
]

{ #category : #accessing }
LzOpTerm >> arguments: anArray [
	arguments := anArray
]

{ #category : #accessing }
LzOpTerm >> opName [
	^ opName
]

{ #category : #accessing }
LzOpTerm >> opName: anOpName [
	opName := anOpName
]

{ #category : #accessing }
LzOpTerm >> sort [
	^ sort
]

{ #category : #accessing }
LzOpTerm >> sort: aSort [
	sort := aSort
]
