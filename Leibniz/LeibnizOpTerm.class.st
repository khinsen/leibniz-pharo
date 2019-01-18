"
I represent a standard Leibniz term defined by a operator and its arguments.
"
Class {
	#name : #LeibnizOpTerm,
	#superclass : #LeibnizTerm,
	#instVars : [
		'opSymbol',
		'argList',
		'sort'
	],
	#category : #'Leibniz-3-Terms'
}

{ #category : #accessing }
LeibnizOpTerm >> sort [
	^sort
]
