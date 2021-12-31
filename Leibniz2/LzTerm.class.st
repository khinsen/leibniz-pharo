Class {
	#name : #LzTerm,
	#superclass : #Object,
	#instVars : [
		'signature'
	],
	#category : #Leibniz2
}

{ #category : #accessing }
LzTerm >> signature [
	^ signature
]

{ #category : #accessing }
LzTerm >> signature: aSignature [
	signature := aSignature
]

{ #category : #accessing }
LzTerm >> sort [
	self subclassResponsibility
]
