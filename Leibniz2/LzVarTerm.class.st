Class {
	#name : #LzVarTerm,
	#superclass : #LzTerm,
	#instVars : [
		'sort',
		'name'
	],
	#category : #'Leibniz2-Leibniz2'
}

{ #category : #testing }
LzVarTerm >> isVarTerm [
	^ true
]

{ #category : #accessing }
LzVarTerm >> name [
	^ name
]

{ #category : #accessing }
LzVarTerm >> name: aVarName [
	name := aVarName
]

{ #category : #printing }
LzVarTerm >> printAsLeibnizSyntaxOn: aStream [
	aStream nextPutAll: name asSymbol
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
	^ #(name sort)
]

{ #category : #accessing }
LzVarTerm >> vars [
	^ Dictionary with: name -> sort
]
