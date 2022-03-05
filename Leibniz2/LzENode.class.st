Class {
	#name : #LzENode,
	#superclass : #Array,
	#type : #variable,
	#traits : 'TLzPrintable',
	#classTraits : 'TLzPrintable classTrait',
	#instVars : [
		'graph'
	],
	#category : #'Leibniz2-EGraphs'
}

{ #category : #enumerating }
LzENode >> allTerms [
	self subclassResponsibility
]

{ #category : #updating }
LzENode >> canonicalizeIn: anEGraph [
	self subclassResponsibility
]

{ #category : #accessing }
LzENode >> graph [
	^ graph
]

{ #category : #accessing }
LzENode >> graph: anEGraph [
	graph := anEGraph
]

{ #category : #inspecting }
LzENode >> gtDisplayOn: stream [
	"Replace the implementation on Collections by the basic one for other objects."
	self printOn: stream
]

{ #category : #inspecting }
LzENode >> gtTermsFor: aView [
	<gtView>
	^ aView forward
		title: 'Terms';
		priority: 1;
		object: [ LzTermStreamContents new streamOrSequence: self allTerms ];
		view: #gtTermsFor:;
		yourself
]

{ #category : #testing }
LzENode >> hasCycle [
	^ self hasLinkToAncestorIn: IdentitySet new
]

{ #category : #printing }
LzENode >> hasInfixOpOtherThan: anOpName [
	^ false
]

{ #category : #testing }
LzENode >> hasLinkToAncestorIn: aSet [
	^ false
]

{ #category : #testing }
LzENode >> isInfix [
	^ false
]

{ #category : #matching }
LzENode >> matchesFor: aPattern bindings: bindings [
	self subclassResponsibility
]

{ #category : #printing }
LzENode >> printAsFirstArgOfInfixTermWithOpName: anOpName on: aStream [
	self
		printAsLeibnizSyntaxOn: aStream
		parenthesized: (self hasInfixOpOtherThan: anOpName)
]

{ #category : #printing }
LzENode >> printAsFirstArgOfInfixTermWithOpName: anOpName on: aStream parents: aNodeSet [
	self
		printAsLeibnizSyntaxOn: aStream
		parenthesized: (self hasInfixOpOtherThan: anOpName)
		parents: aNodeSet
]

{ #category : #printing }
LzENode >> printOn: aStream [
	aStream
		<< 'a ';
		<< self class name;
		<< $(.
	self printAsLeibnizSyntaxOn: aStream.
	aStream << $).
]

{ #category : #accessing }
LzENode >> sort [
	self subclassResponsibility
]
