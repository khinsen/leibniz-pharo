"
I represent a rewrite rule in a Leibniz context.
"
Class {
	#name : #LeibnizRule,
	#superclass : #Object,
	#instVars : [
		'pattern',
		'variables',
		'condition',
		'replacement'
	],
	#category : #'Leibniz-4-Rules'
}

{ #category : #'instance creation' }
LeibnizRule class >> pattern: aPattern condition: aBooleanTerm replacement: aTerm [
	^ self pattern: aPattern localVariables: Dictionary new condition: aBooleanTerm replacement: aTerm

]

{ #category : #'instance creation' }
LeibnizRule class >> pattern: aPattern localVariables: aDictionary condition: aBooleanTerm replacement: aTerm [
	^ self basicNew
			 initializeWithPattern: aPattern
								localVariables: aDictionary
								condition: aBooleanTerm
								replacement: aTerm;
			 yourself

]

{ #category : #'instance creation' }
LeibnizRule class >> pattern: aPattern localVariables: aDictionary replacement: aTerm [
	^ self pattern: aPattern localVariables: aDictionary condition: nil replacement: aTerm

]

{ #category : #'instance creation' }
LeibnizRule class >> pattern: aPattern replacement: aTerm [
	^ self pattern: aPattern condition: nil replacement: aTerm

]

{ #category : #initializing }
LeibnizRule >> initializeWithPattern: aPattern localVariables: aDictionary condition: aBooleanTerm replacement: aTerm [
	pattern := aPattern.
	variables := aDictionary.
	condition := aBooleanTerm.
	replacement := aTerm.
]
