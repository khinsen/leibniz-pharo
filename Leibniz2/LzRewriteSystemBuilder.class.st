Class {
	#name : #LzRewriteSystemBuilder,
	#superclass : #Object,
	#instVars : [
		'signature',
		'ruleDeclarations'
	],
	#category : #'Leibniz2-Rules'
}

{ #category : #accessing }
LzRewriteSystemBuilder >> initialize [
	ruleDeclarations := OrderedCollection new
]

{ #category : #accessing }
LzRewriteSystemBuilder >> rewriteSystem [
	^ LzRewriteSystem new
		signature: self signature;
		rules: (self ruleDeclarations collect: [ :each |
					self signature parsedRule: each ])
		beRecursivelyReadOnlyObject;
		yourself.
]

{ #category : #accessing }
LzRewriteSystemBuilder >> rule: aString [
	ruleDeclarations add:
		(LzParser
			parse: aString
			startingAt: #ruleEnd
			yielding: LzASTRule).
]

{ #category : #accessing }
LzRewriteSystemBuilder >> ruleDeclarations [
	^ ruleDeclarations
]

{ #category : #accessing }
LzRewriteSystemBuilder >> signature [
	^ signature
]

{ #category : #accessing }
LzRewriteSystemBuilder >> signature: aSignature [
	signature := aSignature
]
