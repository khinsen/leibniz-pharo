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
	| signature sortGraph |
	sortGraph := self sortGraphBuilder
		sortGraph.
	signature := self signatureBuilder 
		sortGraph: sortGraph;
		signature.
	^ LzContext new
		signature: signature;
		beRecursivelyReadOnlyObject;
		yourself
]

{ #category : #initializing }
LzContextBuilder >> initialize [
	sortGraphBuilder := LzSortGraphBuilder new.
	signatureBuilder := LzSignatureBuilder new.
]

{ #category : #defining }
LzContextBuilder >> op: aString [
	self signatureBuilder op: aString
]

{ #category : #defining }
LzContextBuilder >> parsedOps: aCollection [
	self signatureBuilder parsedOps: aCollection
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
LzContextBuilder >> sortContext: aContext [ 
]

{ #category : #defining }
LzContextBuilder >> sortGraphBuilder [
	^ sortGraphBuilder
]

{ #category : #defining }
LzContextBuilder >> subsort: aString [
	self sortGraphBuilder subsort: aString
]
