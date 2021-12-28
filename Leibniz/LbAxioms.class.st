Class {
	#name : #LbAxioms,
	#superclass : #Object,
	#traits : 'EqualityThroughVariables',
	#classTraits : 'EqualityThroughVariables classTrait',
	#instVars : [
		'equations',
		'subsorts',
		'signature',
		'axioms'
	],
	#category : 'Leibniz-5-Axioms'
}

{ #category : #'instance creation' }
LbAxioms class >> signature: aSignature axioms: aDictionary [
	^ self basicNew
		initializeWithSignature: aSignature
		axioms: aDictionary;
		yourself
]

{ #category : #accessing }
LbAxioms >> allDeclarations [
	^ self signature declarations union: self declarations
]

{ #category : #copying }
LbAxioms >> copy [
	^ self
]

{ #category : #accessing }
LbAxioms >> declarations [
	| declarations equationDecls |
	declarations := Dictionary new.
	#(#equalityAxioms #subsortAxioms) do: [ :each |
		declarations
			at: each
			put: ((self perform: each)
					collect: #asLeibnizSyntaxString)
						asOrderedCollection sort ].
	^ declarations
]

{ #category : #copying }
LbAxioms >> deepCopy [
	^ self
]

{ #category : #accessing }
LbAxioms >> equalityAxioms [
	^ axioms at: #LbEqualityAxiom
]

{ #category : #accessing }
LbAxioms >> gtAxiomsFor: aView [
	<gtView>
	^ aView tree
		title: 'Axioms' translated;
		priority: 1;
		items: [ axioms keys sorted
					reject: [ :each |
						(axioms at: each) isEmpty ]];
		children: [ :each |
			(each isKindOf: Symbol)
				ifTrue: [ axioms at: each ]
				ifFalse: [ #() ] ];
		itemLbCode: [ :each |
			(each isKindOf: Symbol)
				ifTrue: [ each ]
				ifFalse: [ each asLeibnizSyntaxString ] ];
		expandAll;
		yourself
]

{ #category : #inspecting }
LbAxioms >> gtDeclarationsFor: aView [
	<gtView>
	^ aView lbTree
		title: 'Declarations' translated;
		priority: 4;
		items: [ | d categories |
			d := self allDeclarations.
			categories := OrderedCollection new.
			#(sorts #subsorts variables operators
			  equalityAxioms subsortAxioms) do: [ :each |
				(d at: each) ifNotEmpty: [
					categories add: {
						each asString capitalized.
						(d at: each) collect: [ :aString |
							{ aString. #() } ] } ] ].
			categories ];
		itemLbCode: #first;
		children: #second;
		send: #first;
		collapseAll;
		expandItems: #('EqualityAxoms' 'SubsortAxioms');
		yourself
]

{ #category : #initialization }
LbAxioms >> initializeWithSignature: aSignature axioms: aDictionary [
	signature := aSignature.
	axioms := aDictionary.
	self beRecursivelyReadOnlyObject
]

{ #category : #testing }
LbAxioms >> isEmpty [
	axioms values do: [ :each |
		each ifNotEmpty: [ ^ false ] ].
	^ true
]

{ #category : #accessing }
LbAxioms >> signature [
	^ signature
]

{ #category : #accessing }
LbAxioms >> subsortAxioms [
	^ axioms at: #LbSubsortAxiom
]
