Class {
	#name : #LzUniversalSortFamily,
	#superclass : #LzSortFamily,
	#category : #'Leibniz2-Sorts'
}

{ #category : #accessing }
LzUniversalSortFamily >> printAsLeibnizSyntaxOn: aStream [
	aStream nextPut: $*
]

{ #category : #accessing }
LzUniversalSortFamily >> valueSlots [
	^ #()
]
