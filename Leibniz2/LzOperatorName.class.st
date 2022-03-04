Class {
	#name : #LzOperatorName,
	#superclass : #Object,
	#traits : 'TLzEquality + TLzPrintable',
	#classTraits : 'TLzEquality classTrait + TLzPrintable classTrait',
	#instVars : [
		'internalSymbol'
	],
	#category : #'Leibniz2-Parser'
}

{ #category : #comparing }
LzOperatorName >> <= opName [
	^ self asSymbol <= opName asSymbol
]

{ #category : #modifying }
LzOperatorName >> addPrefix: aSymbol [
	self shouldNotImplement
]

{ #category : #accessing }
LzOperatorName >> asString [
	^ internalSymbol asString
]

{ #category : #converting }
LzOperatorName >> asSymbol [
	^ internalSymbol
]

{ #category : #accessing }
LzOperatorName >> internalSymbol [
	^ internalSymbol
]

{ #category : #accessing }
LzOperatorName >> internalSymbol: aSymbolOrString [
	internalSymbol := aSymbolOrString asSymbol
]

{ #category : #testing }
LzOperatorName >> isEqualityOp [
	^ false
]

{ #category : #testing }
LzOperatorName >> isInfix [
	^ false
]

{ #category : #testing }
LzOperatorName >> isInfixOpOtherThan: anOpName [
	^ false
]

{ #category : #printing }
LzOperatorName >> printAsLeibnizSyntaxOn: aStream [
	aStream nextPutAll: internalSymbol
]

{ #category : #printing }
LzOperatorName >> printForArgs: aTermArray on: aStream [
	self printForArity: aTermArray on: aStream
]

{ #category : #printing }
LzOperatorName >> printForArgs: aTermArray on: aStream parents: aNodeSet [
	self subclassResponsibility
]

{ #category : #printing }
LzOperatorName >> printForArity: anArity on: aStream [
	self subclassResponsibility
]

{ #category : #printing }
LzOperatorName >> printForArity: anArity withSort: aSort on: aStream [
	self printForArity: anArity on: aStream.
	aStream nextPutAll: ' : '.
	aSort printAsLeibnizSyntaxOn: aStream.
]

{ #category : #accessing }
LzOperatorName >> printOn: aStream [
	super printOn: aStream.
	aStream nextPut: $(.
	aStream nextPutAll: internalSymbol.
	aStream nextPut: $)
]

{ #category : #accessing }
LzOperatorName >> printStringForArity: anArity [
	^ String streamContents: [ :s | self printForArity: anArity on: s ]
]

{ #category : #inspecting }
LzOperatorName >> synopsis [
	^ internalSymbol asString
]

{ #category : #accessing }
LzOperatorName >> valueSlots [
	^ #(internalSymbol)
]
