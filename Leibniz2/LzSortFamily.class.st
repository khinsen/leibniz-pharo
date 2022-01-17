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
	#category : #'Leibniz2-Leibniz2'
}

{ #category : #accessing }
LzSortFamily >> family [
	^ self
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
