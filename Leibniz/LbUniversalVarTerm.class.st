"
I represent a special Leibniz variable that matches terms of any sort.
"
Class {
	#name : #LbUniversalVarTerm,
	#superclass : #LbVarTerm,
	#category : #'Leibniz-3-Terms'
}

{ #category : #'instance creation' }
LbUniversalVarTerm class >> symbol: aSymbol forSignature: aSignature [
	^self basicNew
			initializeWithSymbol: aSymbol forSignature: aSignature;
			yourself.

]

{ #category : #converting }
LbUniversalVarTerm >> convertToSignature: aSignature extraVariables: aDictionary [
	^ self class symbol: varSymbol forSignature: aSignature

]

{ #category : #initialization }
LbUniversalVarTerm >> initializeWithSymbol: aSymbol forSignature: aSignature [
	varSymbol := aSymbol.
	signature := aSignature.
	sort := #boolean.
]

{ #category : #matching }
LbUniversalVarTerm >> match: otherTerm [
	otherTerm assertNotAVariable.
	^ LbSubstitution variable: varSymbol value: otherTerm
]
