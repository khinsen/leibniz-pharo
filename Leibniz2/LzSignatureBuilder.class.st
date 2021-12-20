Class {
	#name : #LzSignatureBuilder,
	#superclass : #Object,
	#instVars : [
		'sortGraph',
		'varDeclarations',
		'opDeclarations'
	],
	#category : #'Leibniz2-Leibniz2'
}

{ #category : #building }
LzSignatureBuilder >> build [
	self notYetImplemented
]

{ #category : #accessing }
LzSignatureBuilder >> op: aString [
	self notYetImplemented
]

{ #category : #accessing }
LzSignatureBuilder >> sortGraph [
	^ sortGraph
]

{ #category : #accessing }
LzSignatureBuilder >> sortGraph: aSortGraph [
	sortGraph := aSortGraph
]
