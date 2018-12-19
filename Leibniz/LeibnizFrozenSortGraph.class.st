Class {
	#name : #LeibnizFrozenSortGraph,
	#superclass : #LeibnizSortGraph,
	#category : #'Leibniz-Core'
}

{ #category : #adding }
LeibnizFrozenSortGraph >> add: aSymbol [
	self errorNoModificationAllowed

]

{ #category : #adding }
LeibnizFrozenSortGraph >> errorNoModificationAllowed [
	self error: 'no modification allowed'
]

{ #category : #adding }
LeibnizFrozenSortGraph >> make: aSymbol subsortOf: anotherSymbol [
	self errorNoModificationAllowed

]
