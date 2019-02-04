Class {
	#name : #LeibnizMatch,
	#superclass : #Object,
	#instVars : [
		'substitutions'
	],
	#category : #'Leibniz-3-Terms'
}

{ #category : #'instance creation' }
LeibnizMatch class >> variable: aSymbol value: aTerm [
	^self basicNew
			initializeWithVariable: aSymbol value: aTerm;
			yourself.
]

{ #category : #accessing }
LeibnizMatch >> combineWith: anotherMatch [
	"TODO"
	anotherMatch substitutions keysAndValuesDo:
		[ :var :value |
		  substitutions at: var
				ifPresent: [ :priorValue | priorValue = value ifFalse: [ ^ nil ]].
		  substitutions at: var put: value ]
]

{ #category : #initialization }
LeibnizMatch >> initialize [
	substitutions := Dictionary new
]

{ #category : #initialization }
LeibnizMatch >> initializeWithVariable: aSymbol value: aTerm [
	self initialize.
	substitutions at: aSymbol put: aTerm.

]

{ #category : #accessing }
LeibnizMatch >> substitutions [
	^ substitutions
]
