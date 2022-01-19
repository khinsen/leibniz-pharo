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

{ #category : #accessing }
LzTerm >> args [
	^ #()
]

{ #category : #accessing }
LzTerm >> arity [
	^ LzArity forArgs: self args
]

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
LzTerm >> hasVars [
	^ self
]

{ #category : #testing }
LzTerm >> isInfix [
	^ false
]

{ #category : #testing }
LzTerm >> isVarTerm [
	^ false
]

{ #category : #unifying }
LzTerm >> match: otherTerm [
	| bindings |
	bindings := LzBindings new.
	self match: otherTerm bindings: bindings.
	^ bindings
]

{ #category : #unifying }
LzTerm >> match: otherTerm bindings: bindings [
	self = otherTerm ifFalse: [
		bindings failWith: self notUnifiableWith: otherTerm ]
]

{ #category : #unifying }
LzTerm >> matchVar: aSymbol sort: aSort bindings: bindings [
	self
		assert: self hasVars not
		description: 'Term being matched to has variables'.
	bindings bindVar: aSymbol sort: aSort to: self
]

{ #category : #accessing }
LzTerm >> opName [
	^ nil
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

{ #category : #unifying }
LzTerm >> unify: otherTerm [
	| bindings |
	bindings := LzBindings new.
	self unify: otherTerm bindings: bindings.
	^ bindings
]

{ #category : #unifying }
LzTerm >> unify: otherTerm bindings: bindings [
	self
		unifyTagged: nil
		with: otherTerm
		tagged: nil
		bindings: bindings
]

{ #category : #unifying }
LzTerm >> unifyTagged: aSymbol with: otherTerm tagged: otherSymbol bindings: bindings [
	self subclassResponsibility
]

{ #category : #accessing }
LzTerm >> vars [
	^ Dictionary new
]
