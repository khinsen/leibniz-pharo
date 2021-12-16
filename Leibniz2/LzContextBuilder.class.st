Class {
	#name : #LzContextBuilder,
	#superclass : #Object,
	#instVars : [
		'sortGraphBuilder',
		'signatureBuilder'
	],
	#category : #'Leibniz2-Leibniz2'
}

{ #category : #defining }
LzContextBuilder >> op: aString [
	self signatureBuilder op: aString
]

{ #category : #defining }
LzContextBuilder >> signatureBuilder [
	^ signatureBuilder ifNil: [
		signatureBuilder := LzSignatureBuilder new ]
]

{ #category : #defining }
LzContextBuilder >> sort: aString [
	self sortGraphBuilder sort: aString
]

{ #category : #defining }
LzContextBuilder >> sortGraphBuilder [
	^ sortGraphBuilder ifNil: [
		sortGraphBuilder := LzSortGraphBuilder new ]
]
