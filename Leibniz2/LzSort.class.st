Class {
	#name : #LzSort,
	#superclass : #Object,
	#instVars : [
		'sortGraph',
		'term'
	],
	#category : #'Leibniz2-Leibniz2'
}

{ #category : #comparing }
LzSort >> = anObject [
	self class == anObject class ifFalse: [ ^ false ].
	self sortGraph == anObject sortGraph ifFalse: [ ^ false ].
	self term = anObject term ifFalse: [ ^ false ].
	^ true
]

{ #category : #comparing }
LzSort >> hash [
	^ self term hash
]

{ #category : #accessing }
LzSort >> kind [
	self flag: #todo.
	"A big lie..."
	^ self
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
