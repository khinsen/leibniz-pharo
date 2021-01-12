Class {
	#name : #LbDependentSignature,
	#superclass : #Object,
	#traits : 'EqualityThroughVariables',
	#classTraits : 'EqualityThroughVariables classTrait',
	#instVars : [
		'sortGraph',
		'variables',
		'operators'
	],
	#category : #'Leibniz-7-DependentSorts'
}

{ #category : #'instace creation' }
LbDependentSignature class >> sortGraph: aSortGraph operators: operatorDictionary variables: variableDictionary [
	^ self basicNew
		initializeWithSortGraph: aSortGraph
		operators: operatorDictionary
		variables: variableDictionary;
		yourself
]

{ #category : #copying }
LbDependentSignature >> copy [
	^ self
]

{ #category : #copying }
LbDependentSignature >> deepCopy [
	^ self
]

{ #category : #inspecting }
LbDependentSignature >> gtOperatorsFor: aView [
	<gtView>
	operators isEmpty ifTrue: [ ^ aView empty ].
	^ aView lbColumnedTree
		title: 'Operators' translated;
		priority: 0;
		items: [ operators keys sorted ];
		column: 'Kind arity' lbCode: [ :eachItem |
			(eachItem isKindOf: LbOperatorName)
				ifTrue: [ eachItem synopsis ]
				ifFalse: [ eachItem name printStringForArity: eachItem kindArity ]];
		column: 'Kind' lbCode: [ :eachItem |
			(eachItem isKindOf: LbOperatorName)
				ifTrue: [ '' ]
				ifFalse: [ eachItem kind asLeibnizSyntaxString ]];
		column: 'Ranks' text: [ :each |
			(each isKindOf: LbOperatorName)
				ifTrue: [ '' ]
				ifFalse: [ each size asString ] ];
		children: [ :each |
			(each isKindOf: LbOperatorName)
				ifTrue: [ (operators at: each) values sorted: [:a :b | a kindArity size < b kindArity size] ]
				ifFalse: [ #() ] ];
		expandItems:
			"Should be only the ops defined in the current context, but origin
			management isn't implemented yet."
			(operators associationsSelect: [ :each | true ])
			keys;
		yourself
]

{ #category : #initialization }
LbDependentSignature >> initializeWithSortGraph: aSortGraph operators: operatorDictionary variables: variableDictionary [
	sortGraph := aSortGraph.
	operators := operatorDictionary.
	variables := variableDictionary.
	self beRecursivelyReadOnlyObject
]

{ #category : #'term construction' }
LbDependentSignature >> parseTerm: aString [
]
