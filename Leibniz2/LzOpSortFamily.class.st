Class {
	#name : #LzOpSortFamily,
	#superclass : #LzSortFamily,
	#instVars : [
		'op',
		'contravariant'
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
		ifEmpty: [ '' ] 
		ifNotEmpty: [ :args | args first value ]
]

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
	self assert: anOperator size equals: 1.
	self flag: #todo. "Allow multiple ranks if there is a unique highest one."
	op := anOperator.
	self flag: #contravariant.
	contravariant := self contravarianceFlags
]

{ #category : #printing }
LzOpSortFamily >> printAsLeibnizSyntaxOn: aStream [
	self op opName printForArity: op onlyRank key on: aStream
]

{ #category : #accessing }
LzOpSortFamily >> valueSlots [
	^ #(op)
]
