Class {
	#name : #LzEGraphRewriteCycleError,
	#superclass : #Error,
	#instVars : [
		'rule'
	],
	#category : #'Leibniz2-EGraphs'
}

{ #category : #adding }
LzEGraphRewriteCycleError >> rule: aRule [
	rule := aRule
]
