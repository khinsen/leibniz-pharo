Class {
	#name : #LzBindings2,
	#superclass : #Object,
	#instVars : [
		'vars',
		'failure'
	],
	#category : #'Leibniz2-Terms'
}

{ #category : #accessing }
LzBindings2 >> bindVar: aVarName sort: aSort to: aTerm [
	failure ifNotNil: [ ^ self ].
	self assert: (vars at: aVarName) sort equals: aSort.
	(self findRootFor: aVarName)
		value: aTerm
]

{ #category : #accessing }
LzBindings2 >> bindingFor: aName [
	^ (self findRootFor: aName) value
]

{ #category : #combining }
LzBindings2 >> combineWith: otherBindings [
	otherBindings varsDo: [ :each |
		self defineVar: each name sort: each sort ].
	otherBindings varsDo: [ :each |
		| root |
		root := otherBindings findRootFor: each name.
		self makeVar: each name sort: each sort equalToVar: root name sort: root sort.
		(self findRootFor: each name) value: root value ]
]

{ #category : #binding }
LzBindings2 >> defineVar: aVarName sort: aSort [
	vars at: aVarName
		ifPresent: [ :node | self assert: node sort equals: aSort ]
		ifAbsentPut: [ LzBindingsVarNode new
							name: aVarName;
							sort: aSort ]	
]

{ #category : #failing }
LzBindings2 >> failUnless: aSort isSubsortOf: otherSort [
	failure ifNil: [
		aSort <= otherSort ifFalse: [
			failure := { #notSubsort. aSort. otherSort } ] ]
]

{ #category : #failing }
LzBindings2 >> failWith: aSort incommensurableWith: otherSort [
	failure ifNil: [
		failure := { #incommensurableSorts. aSort. otherSort } ]
]

{ #category : #failing }
LzBindings2 >> failWith: aTerm notUnifiableWith: otherTerm [
	failure ifNil: [
		failure := { #nonUnifiableTerms. aTerm. otherTerm } ]
]

{ #category : #accessing }
LzBindings2 >> findRootFor: aVarName [
	| node |
	node := vars at: aVarName.
	node parent ifNil: [ ^ node ].
	node parent: (self findRootFor: node parent).
	^ node parent
]

{ #category : #initializing }
LzBindings2 >> initialize [
	vars := Set new
]

{ #category : #accessing }
LzBindings2 >> makeVar: aVarName sort: aSort equalToVar: otherVarName sort: otherSort [
	| root1 root2 |
	failure ifNotNil: [ ^ self ].
	aVarName = otherVarName ifTrue: [ ^ self ].
	self assert: (vars at: aVarName) sort equals: aSort.
	self assert: (vars at: otherVarName) sort equals: otherSort.
	root1 := self findRootFor: aVarName.
	root2 := self findRootFor: otherVarName.
	root1 == root2 ifTrue: [ ^ self ].
	root1 rank < root2 rank
		ifTrue: [ | temp | temp := root1. root1 := root2. root2 := temp ].
	root2 parent: root1.
	root1 value ifNil: [ root1 value: root2 value ].
	self assert: root1 value equals: root2 value.
	root1 rank = root2 rank
		ifTrue: [ root1 incrementRank ].
]

{ #category : #accessing }
LzBindings2 >> valueSlots [
	^ #(vars)
]

{ #category : #enumerating }
LzBindings2 >> varsDo: aBlock [
	vars values do: aBlock
]
