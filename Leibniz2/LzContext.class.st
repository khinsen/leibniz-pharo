Class {
	#name : #LzContext,
	#superclass : #Object,
	#traits : 'TLzEquality',
	#classTraits : 'TLzEquality classTrait',
	#instVars : [
		'signature'
	],
	#category : #'Leibniz2-Leibniz2'
}

{ #category : #constructing }
LzContext >> parsedPattern: anASTPatternNode [
	^ self signature parsedPattern: anASTPatternNode
]

{ #category : #constructing }
LzContext >> parsedTerm: anASTTermNode [
	^ self signature parsedTerm: anASTTermNode
]

{ #category : #constructing }
LzContext >> pattern: aString [
	^ self signature pattern: aString
]

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

{ #category : #constructing }
LzContext >> term: aString [
	^ self signature term: aString
]

{ #category : #accessing }
LzContext >> valueSlots [
	^ #(signature)
]
