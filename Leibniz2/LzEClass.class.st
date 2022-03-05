"
An EClass is a set of equivalent ENodes. Since ENodes are mutable, because the classIds they store change whenever two classes are merged, the implementation of an EClass uses an {{gtClass:name=OrderedCollection}} rather than a {{gtClass:name=Set}} to store the nodes. Duplicates are removed explicitly during the EGraph rebuilding process.

An EClass stores references to its parents (ENodes whose arguments are the EClass' classId, plus the classIds of the EClasses to which these ENodes belong) in order to make the rebuilding step faster. The parents include all ENodes that are potentially affected by a change to an EClass during a merge operation.
"
Class {
	#name : #LzEClass,
	#superclass : #Object,
	#instVars : [
		'nodes',
		'parentClassIds',
		'parentNodes',
		'sort'
	],
	#category : #'Leibniz2-EGraphs'
}

{ #category : #adding }
LzEClass >> addNode: anENode [
	nodes add: anENode.
	sort
		ifNil: [ sort := anENode sort ]
		ifNotNil: [
			anENode sort <= sort
				ifFalse: [
					self assert: sort <= anENode sort.
					sort := anENode sort ] ]
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

{ #category : #enumerating }
LzEClass >> allTerms [
	^ Generator on: [ :generator |
		nodes do: [ :eachNode |
			eachNode allTerms do: [ :eachTerm | generator yield: eachTerm ] ] ]
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
	^ aView columnedList
		title: 'Nodes';
		priority: 0;
		items: [ self nodes ];
		column: 'Representative term' lzCode: #asLeibnizSyntaxString;
		column: 'Sort' lzCode: [ :node | node sort asLeibnizSyntaxString ];
		yourself
]

{ #category : #inspecting }
LzEClass >> gtTermsFor: aView [
	<gtView>
	^ aView forward
		title: 'Terms';
		priority: 2;
		object: [ LzTermStreamContents new streamOrSequence: self allTerms ];
		view: #gtTermsFor:;
		yourself
]

{ #category : #testing }
LzEClass >> hasCycle [
	^ self hasLinkToAncestorIn: IdentitySet new.
]

{ #category : #testing }
LzEClass >> hasLinkToAncestorIn: aSet [
	| ancestors |
	ancestors := aSet copyWith: self.
	^ self nodes
		detect: [ :each | each hasLinkToAncestorIn: ancestors ]
		ifFound: [ true ]
		ifNone: [ false ]
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
		<< ', sort='.
	self sort printAsLeibnizSyntaxOn: aStream.
	aStream << $)
]

{ #category : #rebuilding }
LzEClass >> removeDuplicateNodes [
	nodes := nodes asSet asOrderedCollection
]

{ #category : #accessing }
LzEClass >> size [
	^ nodes size
]

{ #category : #accessing }
LzEClass >> sort [
	^ sort
]
