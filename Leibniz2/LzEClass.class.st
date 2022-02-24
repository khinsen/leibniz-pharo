Class {
	#name : #LzEClass,
	#superclass : #Object,
	#instVars : [
		'nodes',
		'parentClassIds',
		'parentNodes'
	],
	#category : #'Leibniz2-EGraphs'
}

{ #category : #adding }
LzEClass >> addNode: anENode [
	nodes add: anENode
]

{ #category : #adding }
LzEClass >> addNodes: anENodeList [
	nodes addAll: anENodeList
]

{ #category : #adding }
LzEClass >> addParentNode: anENode classId: anInteger [
	parentClassIds add: anInteger.
	parentNodes add: anENode.
]

{ #category : #accessing }
LzEClass >> anyNode [
	^ nodes first
]

{ #category : #initializing }
LzEClass >> clearParents [
	parentClassIds := OrderedCollection new.
	parentNodes := OrderedCollection new
]

{ #category : #inspecting }
LzEClass >> gtNodesFor: aView [
	<gtView>
	self nodes ifEmpty: [ ^ aView empty ].
	^ aView list
		title: 'Nodes';
		priority: 0;
		items: [ self nodes ];
		itemLzCode: #asLeibnizSyntaxString;
		yourself
]

{ #category : #initializing }
LzEClass >> initialize [
	nodes := OrderedCollection new.
	self clearParents
]

{ #category : #accessing }
LzEClass >> nodes [
	^ nodes
]

{ #category : #enumerating }
LzEClass >> nodesDo: aBlock [
	^ nodes do: aBlock
]

{ #category : #enumerating }
LzEClass >> parentsDo: aBlock [
	parentNodes with: parentClassIds do: aBlock
]

{ #category : #printing }
LzEClass >> printOn: aStream [
	| n |
	n := self nodes size.
	super printOn: aStream.
	aStream
		<< $(;
		<< n asString;
		<< ' node';
		<< (n == 1 ifTrue: [ '' ] ifFalse: [ 's' ]);
		<< $).
]
