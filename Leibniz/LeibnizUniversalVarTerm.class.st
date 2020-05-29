"
I represent a special Leibniz variable that matches terms of any sort.
"
Class {
	#name : #LeibnizUniversalVarTerm,
	#superclass : #LeibnizVarTerm,
	#category : #'Leibniz-3-Terms'
}

{ #category : #'instance creation' }
LeibnizUniversalVarTerm class >> symbol: aSymbol forSignature: aSignature [
	^self basicNew
			initializeWithSymbol: aSymbol forSignature: aSignature;
			yourself.

]

{ #category : #converting }
LeibnizUniversalVarTerm >> convertToSignature: aSignature extraVariables: aDictionary [
	^ self class symbol: varSymbol forSignature: aSignature

]

{ #category : #initialization }
LeibnizUniversalVarTerm >> initializeWithSymbol: aSymbol forSignature: aSignature [
	varSymbol := aSymbol.
	signature := aSignature.
	sort := #boolean.
]

{ #category : #matching }
LeibnizUniversalVarTerm >> match: otherTerm [
	otherTerm assertNotAVariable.
	^ LeibnizSubstitution variable: varSymbol value: otherTerm
]
