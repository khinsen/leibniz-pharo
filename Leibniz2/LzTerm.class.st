Class {
	#name : #LzTerm,
	#superclass : #Object,
	#traits : 'TLzEquality + TLzPrintable',
	#classTraits : 'TLzEquality classTrait + TLzPrintable classTrait',
	#instVars : [
		'signature'
	],
	#category : #Leibniz2
}

{ #category : #inspecting }
LzTerm >> gtSortFor: aView [
	<gtView>
	^ aView forward
		title: 'Sort';
		priority: 1;
		object: [ self sort ];
		view: #gtGraphFor:;
		yourself
]

{ #category : #accessing }
LzTerm >> gtTreeFor: aView [
	<gtView>
	^ aView columnedTree
		title: 'Tree' translated;
		priority: 0;
		items: [ { self } ];
		column: 'Term' lzCode: [ :each |
			each synopsis ];
		column: 'Sort' lzCode: [ :each |
			each sort asLeibnizSyntaxString ];
		children: #args;
		expandAll;
		yourself
]

{ #category : #printing }
LzTerm >> hasInfixOpOtherThan: aSymbol [
	^ false
]

{ #category : #testing }
LzTerm >> isInfix [
	^ false
]

{ #category : #printing }
LzTerm >> printAsFirstArgOfInfixTermWithOpName: anOpName on: aStream [
	self
		printAsLeibnizSyntaxOn: aStream
		parenthesized: (self hasInfixOpOtherThan: anOpName)
]

{ #category : #printing }
LzTerm >> printAsLeibnizSyntaxOn: aStream [
	self subclassResponsibility
]

{ #category : #printing }
LzTerm >> printAsLeibnizSyntaxOn: aStream parenthesized: aBoolean [
	aBoolean ifTrue: [ aStream nextPut: $( ].
	self printAsLeibnizSyntaxOn: aStream.
	aBoolean ifTrue: [ aStream nextPut: $) ]
]

{ #category : #printing }
LzTerm >> printOn: aStream [
	super printOn: aStream.
	aStream nextPut: $(.
	self printAsLeibnizSyntaxOn: aStream.
	aStream nextPut: $).
]

{ #category : #accessing }
LzTerm >> referenceSlots [
	^ #(signature)
]

{ #category : #accessing }
LzTerm >> signature [
	^ signature
]

{ #category : #accessing }
LzTerm >> signature: aSignature [
	signature := aSignature
]

{ #category : #accessing }
LzTerm >> sort [
	self subclassResponsibility
]

{ #category : #inspecting }
LzTerm >> synopsis [
	"The text shown in a tree view. This is the full term except for LbOpTerms"
	^ self asLeibnizSyntaxString
]
