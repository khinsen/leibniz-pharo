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
LzEGraphMatch >> graph [
	^ graph
]

{ #category : #accessing }
LzEGraphMatch >> graph: anEGraph [
	graph := anEGraph
]

{ #category : #accessing }
LzEGraphMatch >> substitution [
	^ substitution
]

{ #category : #accessing }
LzEGraphMatch >> substitution: bindings [
	substitution := bindings
]
