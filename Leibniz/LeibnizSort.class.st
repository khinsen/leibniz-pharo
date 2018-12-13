"
I represent a sort in a Leibniz sort graph.

"
Class {
	#name : #LeibnizSort,
	#superclass : #Object,
	#instVars : [
		'symbol'
	],
	#category : #'Leibniz-Core'
}

{ #category : #printing }
LeibnizSort >> printOn: aStream [
   aStream nextPutAll: self className.
   aStream nextPut: Character space.
	aStream nextPutAll: symbol asString
	
]

{ #category : #accessing }
LeibnizSort >> withSymbol: aSymbol [
   symbol := aSymbol

]
