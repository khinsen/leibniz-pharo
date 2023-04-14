Class {
	#name : #LzRuleMatcher,
	#superclass : #LzPatternMatcher,
	#instVars : [
		'rule'
	],
	#category : #'Leibniz2-Rules'
}

{ #category : #accessing }
LzRuleMatcher >> rule [
	^ rule
]

{ #category : #accessing }
LzRuleMatcher >> rule: anLzRule [
	rule := anLzRule.
	self pattern: rule pattern
]
