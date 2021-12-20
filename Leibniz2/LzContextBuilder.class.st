Class {
	#name : #LzContextBuilder,
	#superclass : #Object,
	#instVars : [
		'sortGraphBuilder',
		'signatureBuilder'
	],
	#category : #'Leibniz2-Leibniz2'
}

{ #category : #initializing }
LzContextBuilder >> initialize [
	sortGraphBuilder := LzSortGraphBuilder new
]

{ #category : #defining }
LzContextBuilder >> op: aString [
	self signatureBuilder op: aString
]

{ #category : #defining }
LzContextBuilder >> signatureBuilder [
	^ signatureBuilder ifNil: [
		signatureBuilder :=
			LzSignatureBuilder new
				sortGraph: self sortGraphBuilder build ]
]

{ #category : #defining }
LzContextBuilder >> sort: aString [
	self assert: signatureBuilder isNil.
	self sortGraphBuilder sort: aString
]

{ #category : #defining }
LzContextBuilder >> sortGraphBuilder [
	^ sortGraphBuilder ifNil: [
		sortGraphBuilder := LzSortGraphBuilder new ]
]
