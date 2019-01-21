"
I represent an abstract Leibniz term. My subclasses represent concrete terms. 
"
Class {
	#name : #LeibnizTerm,
	#superclass : #Object,
	#traits : 'EqualityThroughVariables',
	#classTraits : 'EqualityThroughVariables classTrait',
	#instVars : [
		'signature'
	],
	#category : #'Leibniz-3-Terms'
}

{ #category : #accessing }
LeibnizTerm >> signature [
	^signature
]

{ #category : #accessing }
LeibnizTerm >> sort [
	^self subclassResponsibility
]
