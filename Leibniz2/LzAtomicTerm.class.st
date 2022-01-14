Class {
	#name : #LzAtomicTerm,
	#superclass : #LzTerm,
	#instVars : [
		'value'
	],
	#category : #'Leibniz2-Leibniz2'
}

{ #category : #printing }
LzAtomicTerm >> printAsLeibnizSyntaxOn: aStream [
	value printOn: aStream
]

{ #category : #accessing }
LzAtomicTerm >> value [
	^ value
]

{ #category : #accessing }
LzAtomicTerm >> value: anObject [
	value := anObject
]

{ #category : #accessing }
LzAtomicTerm >> valueSlots [
	^ #(value)
]
