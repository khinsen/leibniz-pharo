Class {
	#name : #LeibnizBuiltinsTest,
	#superclass : #TestCase,
	#instVars : [
		'builtins'
	],
	#category : #Leibniz
}

{ #category : #running }
LeibnizBuiltinsTest >> setUp [
	builtins := LeibnizBuiltins uniqueInstance.

]

{ #category : #testing }
LeibnizBuiltinsTest >> testTruth [
	| context |
	context := builtins contextNamed: 'truth'.

]
