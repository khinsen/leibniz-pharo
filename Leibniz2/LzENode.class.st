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

{ #category : #accessing }
LzENode >> canonicalizeIn: anEGraph [
	1 to: self size do: [ :index|
		self at: index put:
			(anEGraph findRootFor: (self at: index)) ].
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

{ #category : #printing }
LzENode >> hasInfixOpOtherThan: anOpName [
	^ false
]

{ #category : #testing }
LzENode >> isInfix [
	^ false
]

{ #category : #printing }
LzENode >> printAsFirstArgOfInfixTermWithOpName: anOpName on: aStream [
	self
		printAsLeibnizSyntaxOn: aStream
		parenthesized: (self hasInfixOpOtherThan: anOpName)
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
