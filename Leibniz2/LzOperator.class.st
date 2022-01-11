Class {
	#name : #LzOperator,
	#superclass : #Object,
	#traits : 'TLzEquality + TLzPrintable',
	#classTraits : 'TLzEquality classTrait + TLzPrintable classTrait',
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
LzOperator >> addArity: newArity sort: newSort [
	self flag: #todo.
	"self assertMonotonicity: [ kind includes: newSortPattern ]
		  forArity: newArity andSortPattern: newSortPattern."

	ranks ifEmpty: [
		ranks add: newArity -> newSort.
		^ self  ].

	1 to: ranks size do: [ :index |
		| r a s |
		r := ranks at: index.
		a := r key.
		s := r value.

		a = newArity ifTrue: [
			self
				assert: s = newSort
				description: 'conflicting earlier operator definition with sort ', s asString.
			^ self ].

		(newArity <= a) ifTrue: [
			"First case: all sorts conforming to newArity also conform to a.
			 newArity must then be inserted before a."
			self flag: #todo.
			"self
	 			assertMonotonicity: [ newSort <= s ]
				 forArity: newArity andSortPattern: newSort."
			ranks add: newArity -> newSort beforeIndex: index.
			^ self ].

		(a <= newArity) ifTrue: [
			"Second case: all sorts conforming to a also conform to newArity.
			newArity must be inserted after a, but perhaps not immediately.
			Continue the search."
			self flag: #todo.
			"self
				assertMonotonicity: [ s <= newSort ]
				forArity: newArity andSortPattern: newSort" ] ].

	ranks add: newArity -> newSort
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

{ #category : #printing }
LzOperator >> printAsLeibnizSyntaxOn: aStream [
	opName printForArity:  kindArity on: aStream
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
