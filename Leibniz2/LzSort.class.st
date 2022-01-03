Class {
	#name : #LzSort,
	#superclass : #Object,
	#traits : 'TLzEquality + TLzPrintable',
	#classTraits : 'TLzEquality classTrait + TLzPrintable classTrait',
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

{ #category : #printing }
LzSort >> printAsLeibnizSyntaxOn: aStream [
	self term printAsLeibnizSyntaxOn: aStream
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
