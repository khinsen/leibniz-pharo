Class {
	#name : #LzPrefixOperatorName,
	#superclass : #LzOperatorName,
	#category : #'Leibniz2-Parser'
}

{ #category : #'instance creation' }
LzPrefixOperatorName class >> for: aStringOrSymbol [
	^ self new internalSymbol: aStringOrSymbol
]

{ #category : #modifying }
LzPrefixOperatorName >> addPrefix: aSymbol [
	^ LbPrefixOperatorName for: aSymbol, internalSymbol
]

{ #category : #printing }
LzPrefixOperatorName >> printForArity: anArity on: aStream [
	aStream nextPutAll: internalSymbol.
	anArity ifNotEmpty: [
		aStream nextPut: $(.
		anArity allButLastDo: [ :each |
			each printAsLeibnizSyntaxOn: aStream.
			aStream nextPutAll: ', ' ].
		anArity last printAsLeibnizSyntaxOn: aStream.
		aStream nextPut: $) ]
]
