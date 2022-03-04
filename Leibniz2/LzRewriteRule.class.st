Class {
	#name : #LzRewriteRule,
	#superclass : #LzRule,
	#instVars : [
		'replacement'
	],
	#category : #'Leibniz2-Rules'
}

{ #category : #rewriting }
LzRewriteRule >> apply: bindings [
	^ replacement substitute: bindings
]

{ #category : #'instance creation' }
LzRewriteRule >> checkConsistency [
	| patternVars |
	super checkConsistency.
	self assert: replacement signature == signature.
	self assert: replacement kind equals: pattern kind.
	patternVars := pattern vars.
	replacement vars associationsDo: [ :each |
		self
			assert: (patternVars includesAssociation: each)
			description: 'Variable ', each key asSymbol, ' in replacement but not in pattern'  ]
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
