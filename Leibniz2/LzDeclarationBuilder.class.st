Class {
	#name : #LzDeclarationBuilder,
	#superclass : #LzParseTreeNodeVisitor,
	#category : #'Leibniz2-SmaCCParser'
}

{ #category : #private }
LzDeclarationBuilder >> annotate: aDeclaration from: aTopLevelNode booleanOptions: aCollection [
	^ LzTopLevelAnnotation new
		declaration: aDeclaration;
		options: (self parseOptions: aTopLevelNode boolean: aCollection)
]

{ #category : #private }
LzDeclarationBuilder >> arrayElementsFor: anArray [
	^ anArray collect: [ :each |
		(each isKindOf: LzArrayElementsNode)
			ifTrue: [ self arrayElementsFor: each elements ]
			ifFalse: [ self acceptNode: each ] ]
]

{ #category : #private }
LzDeclarationBuilder >> opDeclarationFor: aTopLevelOpOrSort [
	| varBuilder op |
	varBuilder := LzVarDeclarationBuilder new.
	aTopLevelOpOrSort vars
		ifNotNil: [ :vars | varBuilder acceptNodes: vars ].
	aTopLevelOpOrSort op args
		ifNotNil: [ :args | varBuilder acceptNodes: args ].
	op := self acceptNode: aTopLevelOpOrSort op.
	op args: (aTopLevelOpOrSort op args collect: [ :each |
		| sort |
		sort := self acceptNode: each sort.
		each name ifNotNil: [ :name |
			sort := LzArgNameAnnotation new
				name: name value asSymbol;
				declaration: sort ].
		sort ]).
"	op args: (aTopLevelOp op args collect: [ :each | self acceptNode: each sort ]).
	op argNames: (aTopLevelOp op args collect: [ :each |
		each name ifNotNil: [ :n | n value asSymbol ] ])."
	op variables: varBuilder vars.
	^ op
]

{ #category : #private }
LzDeclarationBuilder >> parseOptions: aTopLevelAnnotation [
	^ (aTopLevelAnnotation options collect: [ :each |
		| key value |
		key := each key source asSymbol.
		value := (LzDeclarationBuilder new acceptNode: each value) value.
		key -> value ])
		asDictionary
]

{ #category : #private }
LzDeclarationBuilder >> parseOptions: aTopLevelAnnotation boolean: aCollection [
	| options |
	options := self parseOptions: aTopLevelAnnotation.
	aCollection do: [ :each |
		| value |
		value := options at: each
			ifPresent: [ :v | v = 'yes' ]
			ifAbsent: [ false ].
		options at: each put: value ].
	^ options
]

{ #category : #visiting }
LzDeclarationBuilder >> visitArrayTerm: anArrayTerm [
	| elements |
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
LzDeclarationBuilder >> visitCompoundStepTerm: aCompoundStepTerm [
	^ LzCompoundStepTermDeclaration new steps:
		(aCompoundStepTerm steps collect: [ :each |
			| term pattern |
			term := self acceptNode: each term.
			pattern := nil.
			each pattern ifNotNil: [ :p |
				| varBuilder |
				varBuilder := LzVarDeclarationBuilder new.
				p vars ifNotNil: [ :v | varBuilder acceptNodes: v ].
				varBuilder acceptNode: p term.
				pattern := LzPatternDeclaration new
					variables: varBuilder vars;
					term: (self acceptNode: p term) ].
			{ term . pattern } ]).
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

{ #category : #'visiting - toplevel' }
LzDeclarationBuilder >> visitTopLevelAsset: aTopLevelAsset [
	| asset |
	asset := LzAssetDeclaration new
		label: aTopLevelAsset label value asSymbol.
	aTopLevelAsset order value ifNotNil: [ :o |
		asset order: o asInteger ].
	^ self
		annotate: asset
		from: aTopLevelAsset
		booleanOptions: #(example withValue withNormalForm)
]

{ #category : #'visiting - toplevel' }
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
	aTopLevelEqualityAxiom prefix ifNotNil: [ :p |
		axiom label: p label value asSymbol ].
	^ self annotate: axiom from: aTopLevelEqualityAxiom booleanOptions: #(example)
]

{ #category : #'visiting - toplevel' }
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
	aTopLevelFunctionRule prefix ifNotNil: [ :p |
		rule label: p label value asSymbol.
		p order ifNotNil: [ :o |
			rule order: o value asInteger ] ].
	^ self annotate: rule from: aTopLevelFunctionRule booleanOptions: #(example)
]

{ #category : #'visiting - toplevel' }
LzDeclarationBuilder >> visitTopLevelOp: aTopLevelOp [
	| op |
	op := self opDeclarationFor: aTopLevelOp.
	op sort: (self acceptNode: aTopLevelOp sort).
	^ self
		annotate: op
		from: aTopLevelOp
		booleanOptions: #(example)
]

{ #category : #'visiting - toplevel' }
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
	aTopLevelRewriteRule prefix ifNotNil: [ :p |
		rule label: p label value asSymbol.
		p order ifNotNil: [ :o |
			rule order: o value asInteger ] ].
	^ self annotate: rule from: aTopLevelRewriteRule booleanOptions: #(example)
]

{ #category : #'visiting - toplevel' }
LzDeclarationBuilder >> visitTopLevelSort: aTopLevelSort [
	| op |
	op := self opDeclarationFor: aTopLevelSort.
	^ self
		annotate: (LzSortDeclaration new op: op)
		from: aTopLevelSort
		booleanOptions: #(example)
]

{ #category : #'visiting - toplevel' }
LzDeclarationBuilder >> visitTopLevelSpecialTerms: aTopLevelSpecialTerms [
	| specialTerms |
	specialTerms := LzSpecialTermsDeclaration new
			termTypes: (aTopLevelSpecialTerms specialTerms
							collect: [ :each |
								each value asSymbol ]).
	^ self annotate: specialTerms from: aTopLevelSpecialTerms booleanOptions: #(example)
]

{ #category : #'visiting - toplevel' }
LzDeclarationBuilder >> visitTopLevelState: aTopLevelState [
	| var |
	var := LzVarDeclaration new
			name: (self acceptNode: aTopLevelState var varName);
			sort: (self acceptNode: aTopLevelState var sort).
	^ self
		annotate: var
		from: aTopLevelState
		booleanOptions: #(example)
]

{ #category : #'visiting - toplevel' }
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
	^ self annotate: axiom from: aTopLevelSubsort booleanOptions: #(example)
]

{ #category : #'visiting - toplevel' }
LzDeclarationBuilder >> visitTopLevelTerm: aTopLevelTerm [
	| varBuilder pattern |
	varBuilder := LzVarDeclarationBuilder new.
	aTopLevelTerm pattern vars
		ifNotNil: [ :vars | varBuilder acceptNodes: vars ].
	varBuilder acceptNode: aTopLevelTerm pattern term.
	pattern := LzPatternDeclaration new
		variables: varBuilder vars;
		term: (self acceptNode: aTopLevelTerm pattern term).
	^ self annotate: pattern from: aTopLevelTerm booleanOptions: #(example withSort withNormalForm)
]

{ #category : #'visiting - toplevel' }
LzDeclarationBuilder >> visitTopLevelUseContext: aTopLevelUseContext [
	| useContext pageName subcontext |
	pageName := $/ split: aTopLevelUseContext pageName value allButFirst allButLast.
	subcontext := nil.
	pageName size = 1
		ifFalse: [ subcontext := $/ join: pageName allButFirst. ].
	pageName := pageName first.
	useContext := LzUseContextDeclaration new
		contextName: pageName;
		subcontext: subcontext.
	^ self
		annotate: useContext
		from: aTopLevelUseContext
		booleanOptions: #(example forSorts)
]

{ #category : #visiting }
LzDeclarationBuilder >> visitTupleOp: aTupleOp [
	^ LzOpDeclaration new
		name: LzTupleOpName new
]

{ #category : #visiting }
LzDeclarationBuilder >> visitTupleTerm: aTupleTerm [
	^ LzOpTermDeclaration new
		opName: LzTupleOpName new;
		args: (aTupleTerm args collect: [ :each | self acceptNode: each ])
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
