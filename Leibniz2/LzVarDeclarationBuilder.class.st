Class {
	#name : #LzVarDeclarationBuilder,
	#superclass : #LzParseTreeNodeVisitor,
	#instVars : [
		'vars'
	],
	#category : #'Leibniz2-SmaCCParser'
}

{ #category : #adding }
LzVarDeclarationBuilder >> addVar: aVar sort: aSortTerm derived: aBoolean [
	| newVar |
	newVar := LzVarDeclaration new
				name: (LzVarName for: aVar);
				sort: aSortTerm;
				position: vars size + 1.
	aBoolean ifTrue: [ newVar beDerived ].
	vars at: aVar
		ifPresent: [ :v | self assert: v sort equals: newVar sort ]
		ifAbsentPut: newVar
]

{ #category : #initializing }
LzVarDeclarationBuilder >> initialize [
	vars := Dictionary new
]

{ #category : #accessing }
LzVarDeclarationBuilder >> vars [
	| grouped |
	grouped := vars keys groupedBy: [ :each | each endsWith: '__' ].
	^ ((grouped at: true ifAbsent: #()), (grouped at: false ifAbsent: #()))
		collect: [ :each | vars at: each ]
]

{ #category : #visiting }
LzVarDeclarationBuilder >> visitVar: aVar [
	self acceptNode: aVar sort.
	self
		addVar: aVar varName value
		sort:(LzDeclarationBuilder new acceptNode: aVar sort)
		derived: false
]

{ #category : #visiting }
LzVarDeclarationBuilder >> visitVarTermWithSort: aVarTerm [
	self acceptNode: aVarTerm sort.
	self
		addVar: aVarTerm varName value
		sort:(LzDeclarationBuilder new acceptNode: aVarTerm sort)
		derived: true
]
