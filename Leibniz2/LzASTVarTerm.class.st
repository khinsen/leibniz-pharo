Class {
	#name : #LzASTVarTerm,
	#superclass : #LzASTTerm,
	#instVars : [
		'name'
	],
	#category : #'Leibniz2-Parser'
}

{ #category : #accessing }
LzASTVarTerm >> name [
	^ name
]

{ #category : #accessing }
LzASTVarTerm >> name: aVarName [
	name := aVarName
]
