Class {
	#name : #LzASTOpTerm,
	#superclass : #LzASTTerm,
	#instVars : [
		'opName',
		'args'
	],
	#category : #'Leibniz2-Parser'
}

{ #category : #accessing }
LzASTOpTerm >> args [

	^ args
]

{ #category : #accessing }
LzASTOpTerm >> args: anObject [

	args := anObject
]

{ #category : #accessing }
LzASTOpTerm >> fieldNames [
	^ #(opName args)
]

{ #category : #accessing }
LzASTOpTerm >> opName [

	^ opName
]

{ #category : #acccessing }
LzASTOpTerm >> opName: anOpName [
	opName := anOpName 
]
