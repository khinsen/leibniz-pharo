Class {
	#name : #LbDependentKind,
	#superclass : #Object,
	#traits : 'EqualityThroughVariables',
	#classTraits : 'EqualityThroughVariables classTrait',
	#instVars : [
		'sortGraph',
		'kindFamily'
	],
	#category : #'Leibniz-7-DependentSorts'
}

{ #category : #'instance creation' }
LbDependentKind class >> sortGraph: aSortGraph kindFamily: aKindFamily [
	^ self basicNew
		initializeWithsortGraph: aSortGraph kindFamily: aKindFamily;
		yourself
]

{ #category : #converting }
LbDependentKind >> asLeibnizSyntaxString [
	^ String streamContents: [ :s | kindFamily printAsLeibnizSyntaxOn: s ]
]

{ #category : #inspecting }
LbDependentKind >> gtGraphFor: aView [
	<gtView>
	^ sortGraph graphFor: aView restrictedTo: kindFamily asSet highlight: nil
]

{ #category : #initialization }
LbDependentKind >> initializeWithsortGraph: aSortGraph kindFamily: aKindFamily [
	sortGraph := aSortGraph.
	kindFamily := aKindFamily
]
