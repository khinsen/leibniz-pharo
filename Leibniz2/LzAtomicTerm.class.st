Class {
	#name : #LzAtomicTerm,
	#superclass : #LzTerm,
	#instVars : [
		'value'
	],
	#category : #'Leibniz2-Terms'
}

{ #category : #'instance creation' }
LzAtomicTerm class >> signature: aSignature value: anObject [
	^ self new
		signature: aSignature;
		value: anObject;
		beRecursivelyReadOnlyObject;
		yourself
]

{ #category : #egraphs }
LzAtomicTerm >> asENodeIn: anEGraph [
	^ anEGraph add:
		(LzLeafENode new
			graph: anEGraph;
			leafTerm: self)
]

{ #category : #organizing }
LzAtomicTerm >> fingerprint [
	^ #atomic
]

{ #category : #accessing }
LzAtomicTerm >> lzAtomicTermValue [
	^ self value
]

{ #category : #egraphs }
LzAtomicTerm >> matchArrayENode: anOpENode  bindings: bindings [
	^ #()
]

{ #category : #unifying }
LzAtomicTerm >> matchArrayTerm: otherTerm elements: aTermList shape: anArray bindings: bindings [
	bindings failWith: self notUnifiableWith: otherTerm
]

{ #category : #egraphs }
LzAtomicTerm >> matchOpENode: anOpENode  bindings: bindings [
	^ #()
]

{ #category : #unifying }
LzAtomicTerm >> matchOpTerm: otherTerm op: anOpName args: anArgList bindings: bindings [
	bindings failWith: self notUnifiableWith: otherTerm
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
		bindings: bindings.
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
