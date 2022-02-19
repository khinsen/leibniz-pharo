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
	super checkConsistency.
	self assert: replacement signature == signature.
	self assert: replacement kind equals: pattern kind.
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
