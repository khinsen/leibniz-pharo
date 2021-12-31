Class {
	#name : #LzSortTerm,
	#superclass : #LzOpTerm,
	#category : #'Leibniz2-Leibniz2'
}

{ #category : #accessing }
LzSortTerm >> kind [
	self flag: #todo.
	"This is a big lie of course..."
	^ self
]
