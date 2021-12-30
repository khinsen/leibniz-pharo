Class {
	#name : #LzContextBuilder,
	#superclass : #Object,
	#instVars : [
		'sortGraphBuilder',
		'signatureBuilder'
	],
	#category : #'Leibniz2-Leibniz2'
}

{ #category : #building }
LzContextBuilder >> context [
	self notYetImplemented
]

{ #category : #initializing }
LzContextBuilder >> initialize [
	sortGraphBuilder := LzSortGraphBuilder new.
	signatureBuilder := LzSignatureBuilder new
							sortGraphBuilder: sortGraphBuilder.
]

{ #category : #defining }
LzContextBuilder >> op: aString [
	self signatureBuilder op: aString
]

{ #category : #defining }
LzContextBuilder >> signatureBuilder [
	^ signatureBuilder
]

{ #category : #defining }
LzContextBuilder >> sort: aString [
	self sortGraphBuilder sort: aString
]

{ #category : #defining }
LzContextBuilder >> sortContext: LzBuiltinContexts [ 
]

{ #category : #defining }
LzContextBuilder >> sortGraphBuilder [
	^ sortGraphBuilder
]

{ #category : #defining }
LzContextBuilder >> subsort: aString [
	self sortGraphBuilder subsort: aString
]
