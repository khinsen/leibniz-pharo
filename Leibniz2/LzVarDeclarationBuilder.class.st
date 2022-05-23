Class {
	#name : #LzVarDeclarationBuilder,
	#superclass : #LzParseTreeNodeVisitor,
	#instVars : [
		'vars'
	],
	#category : #'Leibniz2-SmaCCParser'
}

{ #category : #initializing }
LzVarDeclarationBuilder >> initialize [
	vars := OrderedCollection new
]

{ #category : #accessing }
LzVarDeclarationBuilder >> vars [
	^ vars
]

{ #category : #accessing }
LzVarDeclarationBuilder >> visitVarTermWithSort: aVarTerm [
	vars add: (LzASTVar new
				name: (LzVarName for: aVarTerm varName value) ;
				sort: (LzDeclarationBuilder new acceptNode: aVarTerm sort))
]
