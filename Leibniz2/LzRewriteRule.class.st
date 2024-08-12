Class {
	#name : #LzRewriteRule,
	#superclass : #LzRule,
	#instVars : [
		'replacement'
	],
	#category : #'Leibniz2-Rules'
}

{ #category : #converting }
LzRewriteRule >> addBodyAsRopedTextTo: aRopedText [
	pattern addAsRopedTextTo: aRopedText.
	aRopedText append:
		(' ⇒ ' asRopedText attribute: LzRewriteArrowAttribute new).
	replacement addAsRopedTextTo: aRopedText
]

{ #category : #rewriting }
LzRewriteRule >> apply: bindings reducer: aBlock [
	^ replacement substitute: bindings
]

{ #category : #initialization }
LzRewriteRule >> buildTermsFrom: anASTRuleNode [
	super buildTermsFrom: anASTRuleNode.
	self replacement:
		(anASTRuleNode replacement
			buildFor: self signature
			variables: variables).
]

{ #category : #'instance creation' }
LzRewriteRule >> checkSteps [
	| patternVars |
	super checkSteps.
	self assert: replacement signature == signature.
	self assert: replacement kind equals: pattern kind.
	patternVars := pattern vars.
	replacement vars associationsDo: [ :each |
		self
			assert: (patternVars includesAssociation: each)
			description: 'Variable ', each key asSymbol, ' in replacement but not in pattern'  ]
]

{ #category : #inspecting }
LzRewriteRule >> gtTreeFor: aView [
	<gtView>
	| fakeTerm |
	fakeTerm :=
		LzOpTerm new
			signature: self signature;
			opName: (LzInfixOpName for: #'⇒');
			args: { self pattern. self replacement };
			sort: nil.
	^ aView columnedTree
		title: 'Tree' translated;
		priority: 0;
		items: [ { fakeTerm } ];
		column: 'Term' text: [ :each |
			each synopsis asRopedText
				fontName: LzCodeFont defaultFamily ];
		column: 'Sort' text: [ :each |
			each sort
				ifNil: [ '' ]
				ifNotNil: [ :s | s asLeibnizSyntax ] ];
		children: #args;
		expandAll;
		yourself
]

{ #category : #rewriting }
LzRewriteRule >> normalFormIn: aContext [
	^ self class new
		signature: self signature;
		variables: self variables;
		pattern: (aContext reduce: self pattern);
		condition: (self condition ifNotNil: [ :c | aContext reduce: c ]);
		replacement: (aContext reduce: self replacement);
		label: self label;
		order: self order;
		checkSteps;
		beRecursivelyReadOnlyObject;
		yourself
]

{ #category : #printing }
LzRewriteRule >> printBodyAsLeibnizSyntaxOn: aStream [
	self pattern printAsLeibnizSyntaxOn: aStream.
	aStream nextPutAll: ' ⇒ '.
	self replacement printAsLeibnizSyntaxOn: aStream
]

{ #category : #accessing }
LzRewriteRule >> replacement [
	^ replacement
]

{ #category : #accessing }
LzRewriteRule >> replacement: aTerm [
	replacement := aTerm
]

{ #category : #accessing }
LzRewriteRule >> valueSlots [
	^ super valueSlots, #(replacement)
]
