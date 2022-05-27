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

{ #category : #visiting }
LzVarDeclarationBuilder >> visitVar: aVar [
	vars add: (LzASTVar new
				name: (LzVarName for: aVar varName value) ;
				sort: (LzDeclarationBuilder new acceptNode: aVar sort))
]

{ #category : #visiting }
LzVarDeclarationBuilder >> visitVarTermWithSort: aVarTerm [
	vars add: (LzASTVar new
				name: (LzVarName for: aVarTerm varName value) ;
				sort: (LzDeclarationBuilder new acceptNode: aVarTerm sort))
]
