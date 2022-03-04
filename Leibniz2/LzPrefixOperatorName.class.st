Class {
	#name : #LzPrefixOperatorName,
	#superclass : #LzOperatorName,
	#category : #'Leibniz2-Parser'
}

{ #category : #'instance creation' }
LzPrefixOperatorName class >> for: aStringOrSymbol [
	^ self new internalSymbol: aStringOrSymbol
]

{ #category : #printing }
LzPrefixOperatorName >> printForArgs: anENodeArray on: aStream parents: aNodeSet [
	aStream nextPutAll: internalSymbol.
	anENodeArray ifNotEmpty: [
		aStream nextPut: $(.
		anENodeArray allButLastDo: [ :each |
			each printAsLeibnizSyntaxOn: aStream parents: aNodeSet.
			aStream nextPutAll: ', ' ].
		anENodeArray last
			printAsLeibnizSyntaxOn: aStream
			parents: aNodeSet.
		aStream nextPut: $) ]
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
