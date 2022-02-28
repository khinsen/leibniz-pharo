Class {
	#name : #LzEGraphMatch,
	#superclass : #Object,
	#instVars : [
		'graph',
		'classId',
		'substitution'
	],
	#category : #'Leibniz2-EGraphs'
}

{ #category : #accessing }
LzEGraphMatch >> classId [
	^ classId
]

{ #category : #accessing }
LzEGraphMatch >> classId: anEClassId [
	classId := anEClassId
]

{ #category : #accessing }
LzEGraphMatch >> eClass [
	^ graph classForId: classId
]

{ #category : #accessing }
LzEGraphMatch >> graph [
	^ graph
]

{ #category : #accessing }
LzEGraphMatch >> graph: anEGraph [
	graph := anEGraph
]

{ #category : #inspecting }
LzEGraphMatch >> gtBindingsFor: aView [
	<gtView>
	substitution ifFailure: [ ^ aView empty ].
	^ aView forward
		title: 'Bindings';
		priority: 1;
		object: [ substitution ];
		view: #gtBindingsFor:;
		yourself
]

{ #category : #inspecting }
LzEGraphMatch >> gtEClassNodesFor: aView [
	<gtView>
	^ aView forward
		title: 'Parent eClass nodes';
		priority: 5;
		object: [ self eClass ];
		view: #gtNodesFor:;
		yourself
]

{ #category : #inspecting }
LzEGraphMatch >> gtFailureFor: aView [
	<gtView>
	substitution ifSuccess: [ ^ aView empty ].
	^ aView forward
		title: 'Failure';
		priority: 1;
		object: [ substitution ];
		view: #gtFailureFor:;
		yourself
]

{ #category : #accessing }
LzEGraphMatch >> substitution [
	^ substitution
]

{ #category : #accessing }
LzEGraphMatch >> substitution: bindings [
	substitution := bindings
]
