"
I represent a string in context 'strings'.
"
Class {
	#name : #LeibnizStringTerm,
	#superclass : #LeibnizAtomicTerm,
	#instVars : [
		'value'
	],
	#category : #'Leibniz-3-Terms'
}

{ #category : #printing }
LeibnizStringTerm >> printAsLeibnizSyntaxOn: aStream [
	aStream nextPut: $".
	aStream nextPutAll: value.
	aStream nextPut: $".

]

{ #category : #accessing }
LeibnizStringTerm >> sort [
	^#string
]
