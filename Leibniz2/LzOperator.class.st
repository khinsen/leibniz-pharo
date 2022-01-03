Class {
	#name : #LzOperator,
	#superclass : #Object,
	#traits : 'TLzEquality',
	#classTraits : 'TLzEquality classTrait',
	#instVars : [
		'kind',
		'kindArity',
		'opName',
		'sortGraph',
		'ranks'
	],
	#category : #'Leibniz2-Leibniz2'
}

{ #category : #defining }
LzOperator >> addArity: anArity sort: aSort [
	self flag: #todo
]

{ #category : #accessing }
LzOperator >> fieldNames [
	^ #(kind kindArity opName sortGraph ranks)
]

{ #category : #accessing }
LzOperator >> initialize [
	ranks := OrderedCollection new
]

{ #category : #accessing }
LzOperator >> kind [
	^ kind
]

{ #category : #accessing }
LzOperator >> kind: aSort [
	kind := aSort
]

{ #category : #accessing }
LzOperator >> kindArity [
	^ kindArity
]

{ #category : #accessing }
LzOperator >> kindArity: anArity [
	kindArity := anArity
]

{ #category : #accessing }
LzOperator >> opName [
	^ opName
]

{ #category : #accessing }
LzOperator >> opName: anOpName [
	opName := anOpName
]

{ #category : #lookup }
LzOperator >> sortForArity: anArity [
	self flag: #todo.
	"This is a big lie."
	^ kind
]

{ #category : #accessing }
LzOperator >> sortGraph [
	^ sortGraph
]

{ #category : #accessing }
LzOperator >> sortGraph: aSortGraph [
	sortGraph := aSortGraph
]
