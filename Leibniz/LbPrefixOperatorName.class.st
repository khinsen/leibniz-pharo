Class {
	#name : #LbPrefixOperatorName,
	#superclass : #LbOperatorName,
	#category : #'Leibniz-2-Signatures'
}

{ #category : #'instance creation' }
LbPrefixOperatorName class >> for: aStringOrSymbol [
	^ self new internalSymbol: aStringOrSymbol
]

{ #category : #modifying }
LbPrefixOperatorName >> addPrefix: aSymbol [
	^ LbPrefixOperatorName for: aSymbol, internalSymbol
]

{ #category : #printing }
LbPrefixOperatorName >> printForArity: anArity on: aStream [
	aStream nextPutAll: internalSymbol.
	anArity ifNotEmpty: [
		aStream nextPut: $(.
		anArity allButLastDo: [ :each |
			each printAsLeibnizSyntaxOn: aStream.
			aStream nextPutAll: ', ' ].
		anArity last printAsLeibnizSyntaxOn: aStream.
		aStream nextPut: $) ]
]
