Class {
	#name : #LzASTPattern,
	#superclass : #LzASTNode,
	#instVars : [
		'term',
		'variables'
	],
	#category : #'Leibniz2-Parser'
}

{ #category : #accessing }
LzASTPattern >> term [
	^ term
]

{ #category : #accessing }
LzASTPattern >> term: anObject [
	term := anObject
]

{ #category : #accessing }
LzASTPattern >> valueSlots [
	^ #(term variables)
]

{ #category : #accessing }
LzASTPattern >> variables [
	^ variables
]

{ #category : #accessing }
LzASTPattern >> variables: anObject [
	variables := anObject
]
