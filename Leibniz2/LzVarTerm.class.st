Class {
	#name : #LzVarTerm,
	#superclass : #LzTerm,
	#instVars : [
		'sort',
		'name'
	],
	#category : #'Leibniz2-Leibniz2'
}

{ #category : #accessing }
LzVarTerm >> name [
	^ name
]

{ #category : #accessing }
LzVarTerm >> name: aVarName [
	name := aVarName
]

{ #category : #accessing }
LzVarTerm >> sort [
	^ sort
]

{ #category : #accessing }
LzVarTerm >> sort: aSort [
	sort := aSort
]

{ #category : #accessing }
LzVarTerm >> valueSlots [
	^ #(signature name)
]
