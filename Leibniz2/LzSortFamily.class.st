"
A sort family inside a sort graph consists of all sorts that are defined by the same operator (name plus kind arity) in the sort graph's sort context.

There is also a special sort family for ""any sort"". This is not the sort of any term, but it is the set of acceptable values for a variable of sort 𝕊.
"
Class {
	#name : #LzSortFamily,
	#superclass : #Object,
	#traits : 'TLzEquality + TLzPrintable',
	#classTraits : 'TLzEquality classTrait + TLzPrintable classTrait',
	#instVars : [
		'sortGraph'
	],
	#category : #'Leibniz2-Sorts'
}

{ #category : #accessing }
LzSortFamily >> contravarianceFlags [
	self flag: #contravariant.
	^ ''
]

{ #category : #accessing }
LzSortFamily >> directSubFamilies [
	^ self sortGraph directSubFamiliesOf: self
]

{ #category : #accessing }
LzSortFamily >> directSuperFamilies [
	^ self sortGraph directSuperFamiliesOf: self
]

{ #category : #accessing }
LzSortFamily >> family [
	^ self
]

{ #category : #inspecting }
LzSortFamily >> gtSubFamiliesFor: aView [
	<gtView>
	self directSubFamilies ifEmpty: [ ^ aView empty ].
	^ aView tree
		title: 'Subfamilies';
		priority: 6;
		items: [ self directSubFamilies asArray ];
		itemText: #asLeibnizSyntax;
		children: [ :each | self sortGraph axiomsConnecting: each to: self ];
		expandAll;
		yourself
]

{ #category : #inspecting }
LzSortFamily >> gtSuperFamiliesFor: aView [
	<gtView>
	self directSuperFamilies ifEmpty: [ ^ aView empty ].
	^ aView tree
		title: 'Superfamilies';
		priority: 5;
		items: [ self directSuperFamilies asArray ];
		itemText: #asLeibnizSyntax;
		children: [ :each | self sortGraph axiomsConnecting: self to: each ];
		expandAll;
		yourself
]

{ #category : #accessing }
LzSortFamily >> kind [
	^ self sortGraph kindOf: self
]

{ #category : #accessing }
LzSortFamily >> referenceSlots [
	^ #(sortGraph)
]

{ #category : #accessing }
LzSortFamily >> sortGraph [
	^ sortGraph
]

{ #category : #accessing }
LzSortFamily >> sortGraph: aSortGraph [
	sortGraph := aSortGraph
]
