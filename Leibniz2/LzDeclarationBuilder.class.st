Class {
	#name : #LzDeclarationBuilder,
	#superclass : #LzParseTreeNodeVisitor,
	#category : #'Leibniz2-SmaCCParser'
}

{ #category : #private }
LzDeclarationBuilder >> arrayElementsFor: anArray [
	^ anArray collect: [ :each |
		(each isKindOf: LzArrayElementsNode)
			ifTrue: [ self arrayElementsFor: each elements ]
			ifFalse: [ self acceptNode: each ] ]
]

{ #category : #visiting }
LzDeclarationBuilder >> visitArrayTerm: anArrayTerm [
	| shape elements |
	elements := self arrayElementsFor: anArrayTerm arrayElements elements.
	^ LzASTArrayTerm new
		elements: elements
]

{ #category : #visiting }
LzDeclarationBuilder >> visitBracketOpTerm: aBracketOpTerm [
	^ LzASTOpTerm new
		opName: LzBracketOpName new;
		args: (aBracketOpTerm args collect: [ :each | self acceptNode: each ])
]

{ #category : #visiting }
LzDeclarationBuilder >> visitFpNumberLiteralTerm: aFpNumberLiteralTerm [
	| value |
	"Pharo doesn't allow a dot followed by an exponent without any fractional part.
	Workaround: replace '.e' by '.0e'"
	value := (aFpNumberLiteralTerm text value
				copyReplaceAll: '.e' with: '.0e')
				asNumber asFloat.
	^ LzASTFPLiteral new
		value: value
]

{ #category : #visiting }
LzDeclarationBuilder >> visitInfixOp: aInfixOp [
	self flag: #todo. "Implement variables"
	^ LzASTOp new
		name: (LzInfixOpName for: aInfixOp opName value asSymbol);
		args: (self acceptNodes: aInfixOp args);
		variables: #()
]

{ #category : #visiting }
LzDeclarationBuilder >> visitInfixOpTerm: anInfixOpTerm [
	| opNames opName args |
	opNames := anInfixOpTerm opNames collect: #value.
	self assert: opNames asSet size equals: 1.
	args := anInfixOpTerm args collect: [ :each | self acceptNode: each ].
	opName := LzInfixOpName for: opNames anyOne asSymbol.
	^ args allButFirst inject: args first into: [ :total :each |
		LzASTOpTerm new
			opName: opName;
			args: { total. each } ]
]

{ #category : #visiting }
LzDeclarationBuilder >> visitIntegerLiteralTerm: anIntegerLiteralTerm [
	^ LzASTIntegerLiteral new
		value: anIntegerLiteralTerm text value asNumber
]

{ #category : #visiting }
LzDeclarationBuilder >> visitPrefixOp: aPrefixOp [
	self flag: #todo. "Implement variables"
	^ LzASTOp new
		name: (LzPrefixOpName for: aPrefixOp opName value asSymbol);
		args: (self acceptNodes: aPrefixOp args);
		variables: #()
]

{ #category : #visiting }
LzDeclarationBuilder >> visitPrefixOpTerm: aPrefixOpTerm [
	^ LzASTOpTerm new
		opName: (LzPrefixOpName for: aPrefixOpTerm opName value asSymbol);
		args: (aPrefixOpTerm args collect: [ :each | self acceptNode: each ])
]

{ #category : #visiting }
LzDeclarationBuilder >> visitRationalNumberLiteralTerm: aRationalNumberLiteralTerm [
	^ LzASTRationalLiteral new
		value: (Fraction readFromString: aRationalNumberLiteralTerm text value)
]

{ #category : #visiting }
LzDeclarationBuilder >> visitStringLiteralTerm: aStringLiteralTerm [
	^ LzASTStringLiteral new
		value: aStringLiteralTerm text value allButFirst allButLast
]

{ #category : #visiting }
LzDeclarationBuilder >> visitSubscriptOpTerm: aSubscriptOpTerm [
	^ LzASTOpTerm new
		opName: LzSubscriptOpName new;
		args: (aSubscriptOpTerm args collect: [ :each | self acceptNode: each ])
]

{ #category : #visiting }
LzDeclarationBuilder >> visitSuperscriptOpTerm: aSuperscriptOpTerm [
	^ LzASTOpTerm new
		opName: LzSuperscriptOpName new;
		args: (aSuperscriptOpTerm args collect: [ :each | self acceptNode: each ])
]

{ #category : #accessing }
LzDeclarationBuilder >> visitTopLevelOp: aTopLevelOp [
	| op |
	op := self acceptNode: aTopLevelOp op.
	op sort: (self acceptNode: aTopLevelOp sort).
	^ op
]

{ #category : #visiting }
LzDeclarationBuilder >> visitTopLevelSort: aTopLevelSort [
	| op |
	op := self acceptNode: aTopLevelSort op.
	op sort: (LzASTOpTerm new;
					opName: (LzPrefixOpName for: LzConstants opNameSort)
					args: #()).
	^ op
]

{ #category : #visiting }
LzDeclarationBuilder >> visitTopLevelTerm: aTopLevelTerm [
	^ self acceptNode: aTopLevelTerm term
]

{ #category : #visiting }
LzDeclarationBuilder >> visitVarTerm: aVarTerm [
	^ LzASTVarTerm new
		name: (LzVarName for: aVarTerm opName value)
]
