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

{ #category : #inspecting }
LzOperator >> gtRanksFor: aView [
	<gtView>
	ranks ifEmpty: [ ^ aView empty ].
	^ aView columnedList
		title: 'Ranks';
		priority: 0;
		items: [ ranks ];
		column: 'Variables' lzCode: [ :each |
			(String streamContents: [ :s |
				each key printVariablesOn: s ] )
			asRopedText ];
		column: 'Arity' lzCode: [ :each |
			(String streamContents: [ :s |
				self opName printForArity: each key on: s ] )
			asRopedText ];
		column: 'Sort' lzCode: [ :each |
			each value asLeibnizSyntaxString asRopedText ];
		yourself
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

{ #category : #accessing }
LzOperator >> referenceNames [
	^ #(sortGraph)
]

{ #category : #accessing }
LzOperator >> referenceSlots [
	^ #(sortGraph)
]

{ #category : #accessing }
LzOperator >> size [
	^ ranks size
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

{ #category : #accessing }
LzOperator >> valueSlots [
	^ #(kind kindArity opName ranks)
]
