Class {
	#name : #LzDebuggingUtilities,
	#superclass : #Object,
	#category : #'Leibniz2-Infrastructure'
}

{ #category : #debugging }
LzDebuggingUtilities class >> checkForInfiniteRecursion [
	thisContext stack size > 500 ifTrue: [ self halt ]
]
