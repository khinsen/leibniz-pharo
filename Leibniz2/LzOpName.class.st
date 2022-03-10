Class {
	#name : #LzOpName,
	#superclass : #Object,
	#traits : 'TLzEquality + TLzPrintable',
	#classTraits : 'TLzEquality classTrait + TLzPrintable classTrait',
	#instVars : [
		'internalSymbol'
	],
	#category : #'Leibniz2-Parser'
}

{ #category : #comparing }
LzOpName >> <= opName [
	^ self asSymbol <= opName asSymbol
]

{ #category : #modifying }
LzOpName >> addPrefix: aSymbol [
	self shouldNotImplement
]

{ #category : #accessing }
LzOpName >> asString [
	^ internalSymbol asString
]

{ #category : #converting }
LzOpName >> asSymbol [
	^ internalSymbol
]

{ #category : #accessing }
LzOpName >> internalSymbol [
	^ internalSymbol
]

{ #category : #accessing }
LzOpName >> internalSymbol: aSymbolOrString [
	internalSymbol := aSymbolOrString asSymbol
]

{ #category : #testing }
LzOpName >> isEqualityOp [
	^ false
]

{ #category : #testing }
LzOpName >> isInfix [
	^ false
]

{ #category : #testing }
LzOpName >> isInfixOpOtherThan: anOpName [
	^ false
]

{ #category : #printing }
LzOpName >> printAsLeibnizSyntaxOn: aStream [
	aStream nextPutAll: internalSymbol
]

{ #category : #printing }
LzOpName >> printForArgs: aTermArray on: aStream [
	self printForArity: aTermArray on: aStream
]

{ #category : #printing }
LzOpName >> printForArgs: aTermArray on: aStream parents: aNodeSet [
	self subclassResponsibility
]

{ #category : #printing }
LzOpName >> printForArity: anArity on: aStream [
	self subclassResponsibility
]

{ #category : #printing }
LzOpName >> printForArity: anArity withSort: aSort on: aStream [
	self printForArity: anArity on: aStream.
	aStream nextPutAll: ' : '.
	aSort printAsLeibnizSyntaxOn: aStream.
]

{ #category : #accessing }
LzOpName >> printOn: aStream [
	super printOn: aStream.
	aStream nextPut: $(.
	aStream nextPutAll: internalSymbol.
	aStream nextPut: $)
]

{ #category : #accessing }
LzOpName >> printStringForArity: anArity [
	^ String streamContents: [ :s | self printForArity: anArity on: s ]
]

{ #category : #inspecting }
LzOpName >> synopsis [
	^ internalSymbol asString
]

{ #category : #accessing }
LzOpName >> valueSlots [
	^ #(internalSymbol)
]
