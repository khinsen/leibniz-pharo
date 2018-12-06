"
My unique instance is a special document that contains the built-in contexts of Leibniz.
"
Class {
	#name : #LeibnizBuiltins,
	#superclass : #LeibnizDocument,
	#classInstVars : [
		'uniqueInstance'
	],
	#category : #Leibniz
}

{ #category : #accessing }
LeibnizBuiltins class >> uniqueInstance [
	^ uniqueInstance ifNil: [ uniqueInstance := self new ]
]

{ #category : #initializing }
LeibnizBuiltins >> createIntegerContext [
	| context |
	context  := LeibnizContext new.
	"Natural numbers"
	context addSort: #ℕ.
	context addSort: #zero.
	context addSort: #'ℕ.nz'.
	context make: #zero subsortOf: #ℕ.
	context make: #'ℕ.nz' subsortOf: #ℕ.
	"Integers"
	context addSort: #ℤ.
	context addSort: #'ℤ.nz'.
	context make: #ℕ subsortOf: #ℤ.
	context make: #'ℤ.nz' subsortOf: #ℤ.
	context make: #'ℕ.nz' subsortOf: #'ℤ.nz'.
	self addContext: context named: 'integers'.

]

{ #category : #initializing }
LeibnizBuiltins >> createTruthContext [
	| truth |
	truth := LeibnizContext new.
	truth addSort: #boolean.
	self addContext: truth named: 'truth'.
	
]

{ #category : #initializing }
LeibnizBuiltins >> initialize [
	super initialize.
	self createTruthContext.
	self createIntegerContext.
]
