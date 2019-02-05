Class {
	#name : #LeibnizSubstitution,
	#superclass : #Object,
	#instVars : [
		'variables'
	],
	#category : #'Leibniz-3-Terms'
}

{ #category : #'instance creation' }
LeibnizSubstitution class >> variable: aSymbol value: aTerm [
	^self basicNew
			initializeWithVariable: aSymbol value: aTerm;
			yourself.
]

{ #category : #accessing }
LeibnizSubstitution >> combineWith: anotherMatch [
	anotherMatch variables keysAndValuesDo:
		[ :name :value |
		  variables at: name
				ifPresent: [ :priorValue | priorValue = value ifFalse: [ ^ nil ]].
		  variables at: name put: value ]
]

{ #category : #initialization }
LeibnizSubstitution >> initialize [
	variables := Dictionary new
]

{ #category : #initialization }
LeibnizSubstitution >> initializeWithVariable: aSymbol value: aTerm [
	self initialize.
	variables at: aSymbol put: aTerm.

]

{ #category : #accessing }
LeibnizSubstitution >> variables [
	^ variables
]
