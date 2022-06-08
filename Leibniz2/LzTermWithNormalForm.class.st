Class {
	#name : #LzTermWithNormalForm,
	#superclass : #Object,
	#traits : 'TLzEquality + TLzPrintable',
	#classTraits : 'TLzEquality classTrait + TLzPrintable classTrait',
	#instVars : [
		'term',
		'normalForm',
		'context'
	],
	#category : #'Leibniz2-Terms'
}

{ #category : #'instance creation' }
LzTermWithNormalForm class >> term: aTerm context: aContext [
	^ self new
		context: aContext;
		term: aTerm;
		findNormalForm;
		yourself
]

{ #category : #accessing }
LzTermWithNormalForm >> context [
	^ context
]

{ #category : #accessing }
LzTermWithNormalForm >> context: aContext [
	context := aContext
]

{ #category : #rewriting }
LzTermWithNormalForm >> findNormalForm [
	normalForm := self context reduce: term
]

{ #category : #accessing }
LzTermWithNormalForm >> normalForm [
	^ normalForm
]

{ #category : #printing }
LzTermWithNormalForm >> printAsLeibnizSyntaxOn: aStream [
	term printAsLeibnizSyntaxOn: aStream.
	aStream nextPutAll: ' ⇒ '.
	normalForm printAsLeibnizSyntaxOn: aStream.
]

{ #category : #comparing }
LzTermWithNormalForm >> referenceSlots [
	^ #(context)
]

{ #category : #accessing }
LzTermWithNormalForm >> sort [
	^ self term sort
]

{ #category : #accessing }
LzTermWithNormalForm >> term [
	^ term
]

{ #category : #accessing }
LzTermWithNormalForm >> term: aTerm [
	term := aTerm
]

{ #category : #comparing }
LzTermWithNormalForm >> valueSlots [
	^ #(term)
]
