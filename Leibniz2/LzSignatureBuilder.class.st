Class {
	#name : #LzSignatureBuilder,
	#superclass : #Object,
	#instVars : [
		'varDeclarations',
		'opDeclarations',
		'sortGraphBuilder'
	],
	#category : #'Leibniz2-Leibniz2'
}

{ #category : #accessing }
LzSignatureBuilder >> initialize [
	opDeclarations := OrderedCollection new.
	varDeclarations := OrderedCollection new.
]

{ #category : #accessing }
LzSignatureBuilder >> op: aString [
	opDeclarations add:
		(LzParser
			parse: aString
			startingAt: #opEnd
			yielding: LzASTOpDeclaration).
]

{ #category : #building }
LzSignatureBuilder >> signature [
	self notYetImplemented
]

{ #category : #accessing }
LzSignatureBuilder >> sortGraph [
	^ self sortGraphBuilder build
]

{ #category : #accessing }
LzSignatureBuilder >> sortGraphBuilder [
	^ sortGraphBuilder
]

{ #category : #initializing }
LzSignatureBuilder >> sortGraphBuilder: aSortGraphBuilder [
	sortGraphBuilder := aSortGraphBuilder
]

{ #category : #accessing }
LzSignatureBuilder >> var: aString [
	varDeclarations add:
		(LzParser
			parse: aString
			startingAt: #varEnd
			yielding: LzASTVarDeclaration).
]
