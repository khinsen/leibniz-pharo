Class {
	#name : #LzRewriteSystemBuilder,
	#superclass : #Object,
	#instVars : [
		'signature',
		'ruleDeclarations'
	],
	#category : #'Leibniz2-Rules'
}

{ #category : #inspecting }
LzRewriteSystemBuilder >> gtBuildRewriteSystemFor: anAction [
	<gtAction>
	^ anAction button
		tooltip: 'Inspect the rewrite system';
		priority: 2;
		icon: BrGlamorousIcons debug;
		action: [ :aButton |
			aButton phlow spawnObject:
				self rewriteSystem ]
]

{ #category : #inspecting }
LzRewriteSystemBuilder >> gtRuleDeclarationsFor: aView [
	<gtView>
	^ aView list
		title: 'Rule declarations';
		priority: 0;
		items: [ ruleDeclarations asArray ];
		itemText: #asLeibnizSyntax;
		yourself
]

{ #category : #defining }
LzRewriteSystemBuilder >> include: aRewriteSystem [
	aRewriteSystem ruleDeclarations do: [ :each |
		ruleDeclarations addIfNotPresent: each ] 
]

{ #category : #accessing }
LzRewriteSystemBuilder >> initialize [
	ruleDeclarations := OrderedCollection new
]

{ #category : #defining }
LzRewriteSystemBuilder >> parsedRule: anLzASTRule [
	ruleDeclarations add: anLzASTRule
]

{ #category : #accessing }
LzRewriteSystemBuilder >> rewriteSystem [
	^ LzRewriteSystem new
		signature: self signature;
		ruleDeclarations: self ruleDeclarations;
		rules: (self ruleDeclarations collect: [ :each |
					self signature parsedRule: each ])
		beRecursivelyReadOnlyObject;
		yourself.
]

{ #category : #defining }
LzRewriteSystemBuilder >> rule: aString [
	self parsedRule:
		(LzParser
			parse: aString
			startingAt: #ruleEnd
			yielding: LzRuleDeclaration).
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
