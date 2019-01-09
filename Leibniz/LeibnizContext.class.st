"
I represent a context in a Leibniz document.
"
Class {
	#name : #LeibnizContext,
	#superclass : #Object,
	#instVars : [
		'name',
		'sortGraph',
		'signature'
	],
	#category : #'Leibniz-Core'
}

{ #category : #'instance creation' }
LeibnizContext class >> name: aString sortGraph: aSortGraph signature: aSignature [
	^ self basicNew
			 initializeWithName: aString sortGraph: aSortGraph signature: aSignature;
			 yourself.

]

{ #category : #initializing }
LeibnizContext >> initializeWithName: aString sortGraph: aSortGraph signature: aSignature [
	name := aString.
	sortGraph := aSortGraph.
	signature := aSignature.
	self beRecursivelyReadOnlyObject.
]

{ #category : #accessing }
LeibnizContext >> name [
	^ name
]

{ #category : #printing }
LeibnizContext >> printOn: aStream [
	super printOn: aStream.
	aStream nextPut: $(.
	aStream nextPut: $'.
	aStream nextPutAll: name.
	aStream nextPut: $'.
	aStream nextPut: $).

]

{ #category : #accessing }
LeibnizContext >> signature [
	^signature

]

{ #category : #accessing }
LeibnizContext >> sortGraph [
	^ sortGraph
]
