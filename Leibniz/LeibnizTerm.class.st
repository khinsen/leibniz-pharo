"
I represent an abstract Leibniz term. My subclasses represent concrete terms. 
"
Class {
	#name : #LeibnizTerm,
	#superclass : #Object,
	#instVars : [
		'context'
	],
	#category : #'Leibniz-3-Terms'
}

{ #category : #accessing }
LeibnizTerm >> context [
	^context
]

{ #category : #accessing }
LeibnizTerm >> sort [
	^self subclassResponsibility
]
