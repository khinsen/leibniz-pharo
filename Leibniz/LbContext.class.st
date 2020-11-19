"
I represent a context in a Leibniz document.
"
Class {
	#name : #LbContext,
	#superclass : #Object,
	#instVars : [
		'name',
		'sortGraph',
		'signature',
		'rewriteSystem'
	],
	#category : #'Leibniz-6-Contexts'
}

{ #category : #'instance creation' }
LbContext class >> name: aString signature: aSignature rewriteSystem: aRewriteSystem [
	^ self basicNew
			 initializeWithName: aString signature: aSignature rewriteSystem: aRewriteSystem;
			 yourself
]

{ #category : #initializing }
LbContext >> initializeWithName: aString signature: aSignature rewriteSystem: aRewriteSystem [
	name := aString.
	sortGraph := aSignature sortGraph.
	signature := aSignature.
	rewriteSystem := aRewriteSystem.
	self beRecursivelyReadOnlyObject.
]

{ #category : #converting }
LbContext >> lbAtomicTermClass [
	^ LbContextTerm
]

{ #category : #rewriting }
LbContext >> matchRulesFor: aTerm [
	^ rewriteSystem matchRulesFor: aTerm
]

{ #category : #accessing }
LbContext >> name [
	^ name
]

{ #category : #operations }
LbContext >> parseTerm: aString [
	^ (LbTermParser signature: signature) parse: aString
]

{ #category : #rewriting }
LbContext >> parseTermAndReduce: aString [
	| term |
	term := (LbTermParser signature: signature) parse: aString.
	term isPetit2Failure ifTrue: [ self error: term message ].
	^ rewriteSystem reduce: term
]

{ #category : #printing }
LbContext >> printOn: aStream [
	super printOn: aStream.
	aStream nextPut: $(.
	aStream nextPut: $'.
	aStream nextPutAll: name.
	aStream nextPut: $'.
	aStream nextPut: $).

]

{ #category : #accessing }
LbContext >> rewriteSystem [
	^ rewriteSystem
]

{ #category : #accessing }
LbContext >> signature [
	^signature

]

{ #category : #accessing }
LbContext >> sortGraph [
	^ sortGraph
]
