Class {
	#name : #LzOpSortFamily,
	#superclass : #LzSortFamily,
	#instVars : [
		'op'
	],
	#category : #'Leibniz2-Sorts'
}

{ #category : #inspecting }
LzOpSortFamily >> gtGraphFor: aView [
	<gtView>
	^ self sortGraph
		graphFor: aView
		highlight: [ :x | x = self ]
]

{ #category : #accessing }
LzOpSortFamily >> op [
	^ op
]

{ #category : #accessing }
LzOpSortFamily >> op: anOperator [
	op := anOperator
]

{ #category : #printing }
LzOpSortFamily >> printAsLeibnizSyntaxOn: aStream [
	self op opName printForArity: op kindArity on: aStream
]

{ #category : #accessing }
LzOpSortFamily >> valueSlots [
	^ #(op)
]
