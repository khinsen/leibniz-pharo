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

{ #category : #private }
LzDeclarationBuilder >> parseOptions: aTopLevelAnnotation [
	^ (aTopLevelAnnotation options collect: [ :each |
		each key source
			-> (LzDeclarationBuilder new acceptNode: each value) value ])
		asDictionary
]

{ #category : #visiting }
LzDeclarationBuilder >> visitArrayTerm: anArrayTerm [
	| shape elements |
	elements := self arrayElementsFor: anArrayTerm arrayElements elements.
	^ LzArrayTermDeclaration new
		elements: elements
]

{ #category : #visiting }
LzDeclarationBuilder >> visitBracketOp: aBracketOp [
	^ LzOpDeclaration new
		name: LzBracketOpName new
]

{ #category : #visiting }
LzDeclarationBuilder >> visitBracketOpTerm: aBracketOpTerm [
	^ LzOpTermDeclaration new
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
	^ LzFPLiteralDeclaration new
		value: value
]

{ #category : #visiting }
LzDeclarationBuilder >> visitInfixOp: aInfixOp [
	^ LzOpDeclaration new
		name: (LzInfixOpName for: aInfixOp opName value asSymbol)
]

{ #category : #visiting }
LzDeclarationBuilder >> visitInfixOpTerm: anInfixOpTerm [
	| opNames opName args |
	opNames := anInfixOpTerm opNames collect: #value.
	self assert: opNames asSet size equals: 1.
	args := anInfixOpTerm args collect: [ :each | self acceptNode: each ].
	opName := LzInfixOpName for: opNames anyOne asSymbol.
	^ args allButFirst inject: args first into: [ :total :each |
		LzOpTermDeclaration new
			opName: opName;
			args: { total. each } ]
]

{ #category : #visiting }
LzDeclarationBuilder >> visitIntegerLiteralTerm: anIntegerLiteralTerm [
	^ LzIntegerLiteralDeclaration new
		value: anIntegerLiteralTerm text value asNumber
]

{ #category : #visiting }
LzDeclarationBuilder >> visitParenthesizedTerm: aParenthesizedTerm [
	^ LzParenthesesAnnotation new
		declaration: (self acceptNode: aParenthesizedTerm term)
]

{ #category : #visiting }
LzDeclarationBuilder >> visitPrefixOp: aPrefixOp [
	^ LzOpDeclaration new
		name: (LzPrefixOpName for: aPrefixOp opName value asSymbol)
]

{ #category : #visiting }
LzDeclarationBuilder >> visitPrefixOpTerm: aPrefixOpTerm [
	^ LzOpTermDeclaration new
		opName: (LzPrefixOpName for: aPrefixOpTerm opName value asSymbol);
		args: (aPrefixOpTerm args collect: [ :each | self acceptNode: each ]) asArray
]

{ #category : #visiting }
LzDeclarationBuilder >> visitRationalNumberLiteralTerm: aRationalNumberLiteralTerm [
	^ LzRationalLiteralDeclaration new
		value: (Fraction readFromString: aRationalNumberLiteralTerm text value)
]

{ #category : #visiting }
LzDeclarationBuilder >> visitStringLiteralTerm: aStringLiteralTerm [
	^ LzStringLiteralDeclaration new
		value: aStringLiteralTerm text value allButFirst allButLast
]

{ #category : #visiting }
LzDeclarationBuilder >> visitSubscriptOp: aSubscriptOp [
	^ LzOpDeclaration new
		name: LzSubscriptOpName new
]

{ #category : #visiting }
LzDeclarationBuilder >> visitSubscriptOpTerm: aSubscriptOpTerm [
	^ LzOpTermDeclaration new
		opName: LzSubscriptOpName new;
		args: (aSubscriptOpTerm args collect: [ :each | self acceptNode: each ])
]

{ #category : #visiting }
LzDeclarationBuilder >> visitSuperscriptOp: aSuperscriptOp [
	^ LzOpDeclaration new
		name: LzSuperscriptOpName new
]

{ #category : #visiting }
LzDeclarationBuilder >> visitSuperscriptOpTerm: aSuperscriptOpTerm [
	^ LzOpTermDeclaration new
		opName: LzSuperscriptOpName new;
		args: (aSuperscriptOpTerm args collect: [ :each | self acceptNode: each ])
]

{ #category : #visiting }
LzDeclarationBuilder >> visitTopLevelEqualityAxiom: aTopLevelEqualityAxiom [
	| varBuilder axiom |
	varBuilder := LzVarDeclarationBuilder new.
	aTopLevelEqualityAxiom vars
		ifNotNil: [ varBuilder acceptNodes: aTopLevelEqualityAxiom vars ].
	varBuilder acceptNode: aTopLevelEqualityAxiom left.
	varBuilder acceptNode: aTopLevelEqualityAxiom right.
	aTopLevelEqualityAxiom condition ifNotNil: [ :c |
		varBuilder acceptNode: c ].
	axiom := LzEqualityAxiomDeclaration new
		variables: varBuilder vars;
		left: (self acceptNode: aTopLevelEqualityAxiom left);
		right: (self acceptNode: aTopLevelEqualityAxiom right).
	aTopLevelEqualityAxiom condition ifNotNil: [ :c |
		axiom condition: (self acceptNode: c) ].
	^ axiom
]

{ #category : #visiting }
LzDeclarationBuilder >> visitTopLevelFunctionRule: aTopLevelFunctionRule [
	| varBuilder rule |
	varBuilder := LzVarDeclarationBuilder new.
	aTopLevelFunctionRule vars
		ifNotNil: [ varBuilder acceptNodes: aTopLevelFunctionRule vars ].
	varBuilder acceptNode: aTopLevelFunctionRule pattern.
	aTopLevelFunctionRule condition ifNotNil: [ :c |
		varBuilder acceptNode: c ].
	rule := LzFunctionRuleDeclaration new
		variables: varBuilder vars;
		pattern: (self acceptNode: aTopLevelFunctionRule pattern);
		code: aTopLevelFunctionRule code value allButFirst allButLast.
	aTopLevelFunctionRule condition ifNotNil: [ :c |
		rule condition: (self acceptNode: c) ].
	^ rule
]

{ #category : #visiting }
LzDeclarationBuilder >> visitTopLevelOp: aTopLevelOp [
	| varBuilder op |
	varBuilder := LzVarDeclarationBuilder new.
	aTopLevelOp vars
		ifNotNil: [ :vars | varBuilder acceptNodes: vars ].
	aTopLevelOp op args
		ifNotNil: [ :args | varBuilder acceptNodes: args ].
	op := self acceptNode: aTopLevelOp op.
	op args: (aTopLevelOp op args collect: [ :each | self acceptNode: each ]).
	op sort: (self acceptNode: aTopLevelOp sort).
	op variables: varBuilder vars.
	^ op
]

{ #category : #visiting }
LzDeclarationBuilder >> visitTopLevelRewriteRule: aTopLevelRewriteRule [
	| varBuilder rule |
	varBuilder := LzVarDeclarationBuilder new.
	aTopLevelRewriteRule vars
		ifNotNil: [ :vars | varBuilder acceptNodes: vars ].
	varBuilder acceptNode: aTopLevelRewriteRule pattern.
	varBuilder acceptNode: aTopLevelRewriteRule replacement.
	aTopLevelRewriteRule condition ifNotNil: [ :c |
		varBuilder acceptNode: c ].
	rule := LzRewriteRuleDeclaration new
		variables: varBuilder vars;
		pattern: (self acceptNode: aTopLevelRewriteRule pattern);
		replacement: (self acceptNode: aTopLevelRewriteRule replacement).
	aTopLevelRewriteRule condition ifNotNil: [ :c |
		rule condition: (self acceptNode: c) ].
	^ rule
]

{ #category : #visiting }
LzDeclarationBuilder >> visitTopLevelSort: aTopLevelSort [
	| varBuilder op |
	varBuilder := LzVarDeclarationBuilder new.
	aTopLevelSort vars
		ifNotNil: [ :vars | varBuilder acceptNodes: vars ].
	aTopLevelSort op args
		ifNotNil: [ :args | varBuilder acceptNodes: args ].
	op := self acceptNode: aTopLevelSort op.
	op args: (aTopLevelSort op args collect: [ :each | self acceptNode: each ]).
	op variables: varBuilder vars.
	^ LzSortDeclaration new
		op: op
]

{ #category : #visiting }
LzDeclarationBuilder >> visitTopLevelSpecialTerms: aTopLevelSpecialTerms [
	^ LzSpecialTermsDeclaration new
			termTypes: (aTopLevelSpecialTerms specialTerms
							collect: [ :each |
								each value asSymbol ])
]

{ #category : #visiting }
LzDeclarationBuilder >> visitTopLevelSubsort: aTopLevelSubsort [
	| varBuilder axiom |
	varBuilder := LzVarDeclarationBuilder new.
	aTopLevelSubsort vars
		ifNotNil: [ :vars | varBuilder acceptNodes: vars ].
	varBuilder acceptNode: aTopLevelSubsort subsort.
	varBuilder acceptNode: aTopLevelSubsort supersort.
	axiom := LzSubsortAxiomDeclaration new
		variables: varBuilder vars;
		subsort: (self acceptNode: aTopLevelSubsort subsort);
		supersort: (self acceptNode: aTopLevelSubsort supersort).
	^ axiom
]

{ #category : #visiting }
LzDeclarationBuilder >> visitTopLevelTerm: aTopLevelTerm [
	| varBuilder |
	varBuilder := LzVarDeclarationBuilder new.
	aTopLevelTerm vars
		ifNotNil: [ :vars | varBuilder acceptNodes: vars ].
	varBuilder acceptNode: aTopLevelTerm term.
	^ LzPatternDeclaration new
		variables: varBuilder vars;
		term: (self acceptNode: aTopLevelTerm term)
]

{ #category : #visiting }
LzDeclarationBuilder >> visitTopLevelUseContext: aTopLevelUseContext [
	| options |
	options := self parseOptions: aTopLevelUseContext.
	^ { aTopLevelUseContext pageName value allButFirst allButLast.
		(options at: #sortFlag ifAbsent: [ 'no' ]) = 'yes' }
]

{ #category : #visiting }
LzDeclarationBuilder >> visitVarTerm: aVarTerm [
	^ LzVarTermDeclaration new
		name: (LzVarName for: aVarTerm varName value)
]

{ #category : #visiting }
LzDeclarationBuilder >> visitVarTermWithSort: aVarTerm [
	^ LzVarTermDeclaration new
		name: (LzVarName for: aVarTerm varName value);
		sort:(LzDeclarationBuilder new acceptNode: aVarTerm sort)	
]
