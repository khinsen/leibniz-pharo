"
I represent a context in a Leibniz document.
"
Class {
	#name : #LeibnizContext,
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
LeibnizContext class >> name: aString sortGraph: aSortGraph signature: aSignature rewriteSystem: aRewriteSystem [
	^ self basicNew
			 initializeWithName: aString sortGraph: aSortGraph signature: aSignature rewriteSystem: aRewriteSystem;
			 yourself.

]

{ #category : #initializing }
LeibnizContext >> initializeWithName: aString sortGraph: aSortGraph signature: aSignature rewriteSystem: aRewriteSystem [
	name := aString.
	sortGraph := aSortGraph.
	signature := aSignature.
	rewriteSystem := aRewriteSystem.
	self beRecursivelyReadOnlyObject.
]

{ #category : #converting }
LeibnizContext >> lbAtomicTermClass [
	^ LbContextTerm
]

{ #category : #rewriting }
LeibnizContext >> matchRulesFor: aTerm [
	^ rewriteSystem matchRulesFor: aTerm
]

{ #category : #accessing }
LeibnizContext >> name [
	^ name
]

{ #category : #operations }
LeibnizContext >> parseTerm: aString [
	^ (LbTermParser forSignature: signature) parse: aString
]

{ #category : #rewriting }
LeibnizContext >> parseTermAndReduce: aString [
	| term |
	term := (LbTermParser forSignature: signature) parse: aString.
	term isPetit2Failure ifTrue: [ self error: term message ].
	^ rewriteSystem reduce: term
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
LeibnizContext >> rewriteSystem [
	^ rewriteSystem
]

{ #category : #accessing }
LeibnizContext >> signature [
	^signature

]

{ #category : #accessing }
LeibnizContext >> sortGraph [
	^ sortGraph
]
