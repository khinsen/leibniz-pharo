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
LzVarTerm >> hasVars [
	^ true
]

{ #category : #testing }
LzVarTerm >> isVarTerm [
	^ true
]

{ #category : #unifying }
LzVarTerm >> match: otherTerm bindings: bindings [
	bindings defineVar: name sort: sort.
	otherTerm matchVar: name sort: sort bindings: bindings
]

{ #category : #unifying }
LzVarTerm >> matchOpTerm: otherTerm op: anOpName args: anArgList bindings: bindings [
	self error: 'Variable in term being matched to'
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
