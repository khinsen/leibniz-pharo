Class {
	#name : #LzContext,
	#superclass : #Object,
	#instVars : [
		'signature'
	],
	#category : #'Leibniz2-Leibniz2'
}

{ #category : #accessing }
LzContext >> signature [
	^ signature
]

{ #category : #accessing }
LzContext >> signature: aSignature [
	signature := aSignature
]

{ #category : #accessing }
LzContext >> sortGraph [
	^ self signature sortGraph
]
