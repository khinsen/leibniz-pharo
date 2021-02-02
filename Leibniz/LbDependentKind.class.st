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

{ #category : #initialization }
LbDependentKind >> initializeWithsortGraph: aSortGraph kindFamily: aKindFamily [
	sortGraph := aSortGraph.
	kindFamily := aKindFamily
]
