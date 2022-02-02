Class {
	#name : #LzAtomicTerm,
	#superclass : #LzTerm,
	#instVars : [
		'value'
	],
	#category : #'Leibniz2-Terms'
}

{ #category : #accessing }
LzAtomicTerm >> lzAtomicTermValue [
	^ self value
]

{ #category : #printing }
LzAtomicTerm >> printAsLeibnizSyntaxOn: aStream [
	value printOn: aStream
]

{ #category : #unifying }
LzAtomicTerm >> unifyTagged: aSymbol with: otherTerm tagged: otherSymbol bindings: bindings [
	otherTerm
		unifyTagged: otherSymbol
		withAtomicTerm: self
		tagged: aSymbol
		variables: bindings.
]

{ #category : #unifying }
LzAtomicTerm >> unifyTagged: aSymbol withAtomicTerm: otherTerm tagged: otherSymbol bindings: bindings [
	self = otherTerm
		ifFalse: [ bindings failWith: self notUnifiableWith: otherTerm ]
]

{ #category : #accessing }
LzAtomicTerm >> value [
	^ value
]

{ #category : #accessing }
LzAtomicTerm >> value: anObject [
	value := anObject
]

{ #category : #accessing }
LzAtomicTerm >> valueSlots [
	^ #(value)
]
