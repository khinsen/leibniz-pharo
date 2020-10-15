Class {
	#name : #LbOperatorName,
	#superclass : #Object,
	#instVars : [
		'internalSymbol'
	],
	#category : #'Leibniz-2-Signatures'
}

{ #category : #converting }
LbOperatorName >> asSymbol [
	^ internalSymbol
]

{ #category : #accessing }
LbOperatorName >> internalSymbol: aSymbolOrString [
	internalSymbol := aSymbolOrString asSymbol
]

{ #category : #accessing }
LbOperatorName >> printOn: aStream [
	self printOn: aStream.
	aStream nextPut: $(.
	aStream nextPutAll: internalSymbol.
	aStream nextPut: $)
]
