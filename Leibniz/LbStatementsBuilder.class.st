Class {
	#name : #LbStatementsBuilder,
	#superclass : #Object,
	#instVars : [
		'signature',
		'statements'
	],
	#category : #'Leibniz-5-Statements'
}

{ #category : #'instance creation' }
LbStatementsBuilder class >> signature: aSignature [
	^ self basicNew
		initializeWithSignature: aSignature;
		yourself
]

{ #category : #adding }
LbStatementsBuilder >> add: anLbStatement [
	(statements at: anLbStatement class name)
		add: anLbStatement
]

{ #category : #accessing }
LbStatementsBuilder >> addStatements: anLbStatements origin: aContext [
	anLbStatements declarations do: [ :eachList |
		eachList do: [ :eachDecl |
			self parseAndAdd: eachDecl ] ]
]

{ #category : #initialization }
LbStatementsBuilder >> initializeWithSignature: aSignature [
	signature := aSignature.
	statements := Dictionary new.
	LbStatement subclasses do: [ :each |
		statements at: each name put: Set new ]
]

{ #category : #adding }
LbStatementsBuilder >> parseAndAdd: aString [
	| statement |
	statement := (LbStatementParser signature: signature) parse: aString.
	statement isPetit2Failure ifTrue: [ self error: statement message ].
	self add: statement.
]

{ #category : #accessing }
LbStatementsBuilder >> statements [
	^ LbStatements
		signature: signature
		statements: statements deepCopy
]
