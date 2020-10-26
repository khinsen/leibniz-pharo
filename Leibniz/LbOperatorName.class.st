Class {
	#name : #LbOperatorName,
	#superclass : #Object,
	#traits : 'EqualityThroughVariables',
	#classTraits : 'EqualityThroughVariables classTrait',
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
	^ ((aSymbol first = $_)
		ifTrue: [  LbInfixOperatorName ]
		ifFalse: [ LbPrefixOperatorName ])
		new internalSymbol: aSymbol
]

{ #category : #compar }
LbOperatorName >> <= opName [
	^ self asSymbol <= opName asSymbol
]

{ #category : #converting }
LbOperatorName >> asLbOperatorName [
	^ self
]

{ #category : #converting }
LbOperatorName >> asSymbol [
	^ internalSymbol
]

{ #category : #accessing }
LbOperatorName >> internalSymbol [
	^ internalSymbol
]

{ #category : #accessing }
LbOperatorName >> internalSymbol: aSymbolOrString [
	internalSymbol := aSymbolOrString asSymbol
]

{ #category : #printing }
LbOperatorName >> printForArity: anArity on: aStream [
	self subclassResponsibility
]

{ #category : #printing }
LbOperatorName >> printForArity: anArity withSort: aSort on: aStream [
	self printForArity: anArity on: aStream.
	aStream nextPutAll: ' : '.
	aStream nextPutAll: aSort asLeibnizSyntaxString.
]

{ #category : #accessing }
LbOperatorName >> printOn: aStream [
	super printOn: aStream.
	aStream nextPut: $(.
	aStream nextPutAll: internalSymbol.
	aStream nextPut: $)
]

{ #category : #accessing }
LbOperatorName >> printStringForArity: anArity [
	^ String streamContents: [ :s | self printForArity: anArity on: s ]
]

{ #category : #printing }
LbOperatorName >> synopsis [
	^ internalSymbol asString asRopedText
]