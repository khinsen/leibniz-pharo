Class {
	#name : #LzSubsortRelation,
	#superclass : #LzSortPair,
	#traits : 'TLzPrintable',
	#classTraits : 'TLzPrintable classTrait',
	#category : #'Leibniz2-Sorts'
}

{ #category : #printing }
LzSubsortRelation >> printAsLeibnizSyntaxOn: aStream [
	self sort1 printAsLeibnizSyntaxOn: aStream.
	aStream nextPutAll: ' ⊆ '.
	self sort2 printAsLeibnizSyntaxOn: aStream.
]
