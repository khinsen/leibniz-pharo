Class {
	#name : #LzSort,
	#superclass : #Object,
	#traits : 'TLzEquality',
	#classTraits : 'TLzEquality classTrait',
	#instVars : [
		'sortGraph',
		'term'
	],
	#category : #'Leibniz2-Leibniz2'
}

{ #category : #accessing }
LzSort >> kind [
	self flag: #todo.
	"A big lie..."
	^ self
]

{ #category : #accessing }
LzSort >> referenceSlots [
	^ #(sortGraph)
]

{ #category : #accessing }
LzSort >> sortGraph [
	^ sortGraph
]

{ #category : #accessing }
LzSort >> sortGraph: aSortGraph [
	sortGraph := aSortGraph
]

{ #category : #accessing }
LzSort >> term [
	^ term
]

{ #category : #accessing }
LzSort >> term: aTerm [
	term := aTerm
]

{ #category : #accessing }
LzSort >> valueSlots [
	^ #(term)
]
