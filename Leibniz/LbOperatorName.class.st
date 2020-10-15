Class {
	#name : #LbOperatorName,
	#superclass : #Object,
	#instVars : [
		'internalSymbol'
	],
	#category : #'Leibniz-2-Signatures'
}

{ #category : #'instance creation' }
LbOperatorName class >> fromInternalSymbol: aSymbol [
	aSymbol = #'_' ifTrue: [ ^ LbSubscriptOperatorName new ].
	aSymbol = #'^' ifTrue: [ ^ LbSuperscriptOperatorName new ].
	aSymbol = #'[]' ifTrue: [ ^ LbBracketOperatorName new ].
	^ ((aSymbol beginsWith: '_')
		ifTrue: [  LbInfixOperatorName ]
		ifFalse: [ LbPrefixOperatorName ])
		new internalSymbol: aSymbol
]

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
