"
I represent a special Leibniz variable that matches terms of any sort.
"
Class {
	#name : #LbUniversalVarTerm,
	#superclass : #LbVarTerm,
	#category : #'Leibniz-3-Terms'
}

{ #category : #'instance creation' }
LbUniversalVarTerm class >> symbol: aSymbol signature: aSignature [
	^self basicNew
			initializeWithSymbol: aSymbol signature: aSignature;
			yourself
]

{ #category : #converting }
LbUniversalVarTerm >> convertToSignature: aSignature extraVariables: aDictionary [
	^ self class symbol: name signature: aSignature

]

{ #category : #initialization }
LbUniversalVarTerm >> initializeWithSymbol: aSymbol signature: aSignature [
	name := aSymbol.
	signature := aSignature.
	sort := #boolean.
]

{ #category : #matching }
LbUniversalVarTerm >> match: otherTerm [
	otherTerm assertNotAVariable.
	^ LbSubstitution variable: name value: otherTerm
]
