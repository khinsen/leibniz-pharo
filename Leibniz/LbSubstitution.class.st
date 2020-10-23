"
I represent the mapping from variables to values that results from matching a term to a pattern.
"
Class {
	#name : #LbSubstitution,
	#superclass : #Object,
	#instVars : [
		'variables'
	],
	#category : #'Leibniz-3-Terms'
}

{ #category : #'instance creation' }
LbSubstitution class >> variable: aSymbol value: aTerm [
	^self basicNew
			initializeWithVariable: aSymbol value: aTerm;
			yourself.
]

{ #category : #accessing }
LbSubstitution >> combineWith: anotherMatch [
	anotherMatch variables keysAndValuesDo:
		[ :name :value |
		  variables at: name
				ifPresent: [ :priorValue | priorValue = value ifFalse: [ ^ nil ]].
		  variables at: name put: value ]
]

{ #category : #initialization }
LbSubstitution >> initialize [
	variables := Dictionary new
]

{ #category : #initialization }
LbSubstitution >> initializeWithVariable: aSymbol value: aTerm [
	self initialize.
	variables at: aSymbol put: aTerm.

]

{ #category : #accessing }
LbSubstitution >> variables [
	^ variables
]
