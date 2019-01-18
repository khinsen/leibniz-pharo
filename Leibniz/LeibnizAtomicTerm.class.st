"
I represent atomic terms, such as numbers and strings.
"
Class {
	#name : #LeibnizAtomicTerm,
	#superclass : #LeibnizTerm,
	#instVars : [
		'value'
	],
	#category : #'Leibniz-3-Terms'
}

{ #category : #'instance creation' }
LeibnizAtomicTerm class >> value: aString inContext: aContext [
	^self basicNew
			initializeWithValue: aString inContext: aContext;
			yourself

]

{ #category : #initialization }
LeibnizAtomicTerm >> initializeWithValue: aString inContext: aContext [
	context := aContext.
	value := aString.

]

{ #category : #printing }
LeibnizAtomicTerm >> printAsLeibnizSyntaxOn: aStream [
	value printOn: aStream

]

{ #category : #printing }
LeibnizAtomicTerm >> printOn: aStream [
	super printOn: aStream.
	aStream nextPut: $(.
	self printAsLeibnizSyntaxOn: aStream.
	aStream nextPut: $).

]

{ #category : #accessing }
LeibnizAtomicTerm >> sort [
	^self subclassResponsibility
]
