Class {
	#name : #LzASTVarDeclaration,
	#superclass : #LzASTNode,
	#instVars : [
		'sort',
		'name'
	],
	#category : #'Leibniz2-Parser'
}

{ #category : #accessing }
LzASTVarDeclaration >> fieldNames [
	^ #(name sort)
]

{ #category : #accessing }
LzASTVarDeclaration >> name [

	^ name
]

{ #category : #accessing }
LzASTVarDeclaration >> name: anObject [

	name := anObject
]

{ #category : #accessing }
LzASTVarDeclaration >> sort [

	^ sort
]

{ #category : #accessing }
LzASTVarDeclaration >> sort: anObject [

	sort := anObject
]
