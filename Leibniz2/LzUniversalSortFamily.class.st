Class {
	#name : #LzUniversalSortFamily,
	#superclass : #LzSortFamily,
	#category : #'Leibniz2-Sorts'
}

{ #category : #accessing }
LzUniversalSortFamily >> printAsLeibnizSyntaxOn: aStream [
	aStream nextPutAll: LzConstants opNameSort
]

{ #category : #accessing }
LzUniversalSortFamily >> valueSlots [
	^ #()
]
