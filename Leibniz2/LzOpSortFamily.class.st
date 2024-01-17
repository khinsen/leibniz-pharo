Class {
	#name : #LzOpSortFamily,
	#superclass : #LzSortFamily,
	#instVars : [
		'op'
	],
	#category : #'Leibniz2-Sorts'
}

{ #category : #converting }
LzOpSortFamily >> addAsRopedTextTo: aRopedText [
	self op opName addForArity: op onlyRank key asRopedTextTo: aRopedText
]

{ #category : #accessing }
LzOpSortFamily >> contravarianceFlags [
	self flag: #contravariant.
	^ self op onlyRank value term args
		ifEmpty: [ String new: self op onlyRank key size withAll: $0 ] 
		ifNotEmpty: [ :args | args first value ]
]

{ #category : #inspecting }
LzOpSortFamily >> gtGraphFor: aView [
	<gtView>
	^ (self sortGraph
		graphFor: aView
		highlight: [ :x | x = self ])
		priority: 1
]

{ #category : #accessing }
LzOpSortFamily >> op [
	^ op
]

{ #category : #accessing }
LzOpSortFamily >> op: anOperator [
	self assert: anOperator size equals: 1.
	self flag: #todo. "Allow multiple ranks if there is a unique highest one."
	op := anOperator
]

{ #category : #printing }
LzOpSortFamily >> printAsLeibnizSyntaxOn: aStream [
	self op opName printForArity: op onlyRank key on: aStream
]

{ #category : #accessing }
LzOpSortFamily >> valueSlots [
	^ #(op)
]
