Class {
	#name : #LbSubsortAxiom,
	#superclass : #LbAxiom,
	#instVars : [
		'subsort',
		'supersort'
	],
	#category : #'Leibniz-5-Axioms'
}

{ #category : #'instance creation' }
LbSubsortAxiom class >> subsort: subsortTerm supersort: supersortTerm [
	^ self
		subsort: subsortTerm
		supersort: supersortTerm
		localVariables: Dictionary new
]

{ #category : #'instance creation' }
LbSubsortAxiom class >> subsort: subsortTerm supersort: supersortTerm localVariables: aDictionary [
	^ self basicNew
		initializeWithSubsort: subsortTerm
		supersort: supersortTerm
		localVariables: aDictionary;
		yourself
]

{ #category : #inspecting }
LbSubsortAxiom >> gtRelationFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Relation' translated;
		priority: 0;
		items: [ { self } ];
		column: 'Variables' lbCode: [ :each |
			String streamContents: [ :s |
				each printVariablesAsLeibnizSyntaxOn: s ] ];
		column: 'Subsort' lbCode: [ :each |
			String streamContents: [ :s |
				each subsort printAsLeibnizSyntaxOn: s ] ];
		column: 'Supersort' lbCode: [ :each |
			String streamContents: [ :s |
				each supersort printAsLeibnizSyntaxOn: s ] ];
		yourself
]

{ #category : #initialization }
LbSubsortAxiom >> initializeWithSubsort: subsortTerm supersort: supersortTerm localVariables: aDictionary [
	subsort := subsortTerm.
	supersort := supersortTerm.
	variables := aDictionary.
	signature := subsortTerm signature.

	self assert: subsort sort name equals: #sort.
	self assert: supersort sort name equals: #sort.
	self assert: supersortTerm signature equals: signature.

	supersort variables associationsDo: [ :each |
		self
			assert: (subsort variables includesAssociation: each)
			description: 'Variable ', each key asSymbol,
							' in supersort but not in subsort term' ].
				
	self beRecursivelyReadOnlyObject
]

{ #category : #testing }
LbSubsortAxiom >> isTotal [
	"Answer true if the subsort relation applied to the
	full family defined by its top-level operator."
	| argSorts op highestRank |
	"1. All arguments must be variables."
	subsort arguments
		detect: [ :each | each isVariable not ]
		ifFound: [ ^ false ].
	"2. All argument variables must be distinct."
	(subsort arguments collect: #name) asSet size = subsort arguments size
		ifFalse: [ ^ false ].
	"3. The highest rank of the operator matching the argument sorts
	must have an arity equal to the argument sorts."
	argSorts := subsort arguments collect: #sort.
	op := signature opNamed: subsort opName withArgs: argSorts.
	highestRank := (op ranksMatchingArgSorts: argSorts) last.
	^ argSorts hasEqualElements: highestRank key
]

{ #category : #printing }
LbSubsortAxiom >> printAsLeibnizSyntaxOn: aStream [
	self printVariablesAsLeibnizSyntaxOn: aStream.
	aStream nextPut: Character space.
	subsort printAsLeibnizSyntaxOn: aStream.
	aStream nextPutAll: ' ⊆ '.
	supersort printAsLeibnizSyntaxOn: aStream
]

{ #category : #accessing }
LbSubsortAxiom >> subsort [
	^ subsort
]

{ #category : #accessing }
LbSubsortAxiom >> supersort [
	^ supersort
]

{ #category : #matching }
LbSubsortAxiom >> supersortOf: aTerm [
	^ (subsort match: aTerm)
		ifNull: [ nil ]
		ifNotNull: [ :substitution |
			supersort substitute: substitution ]
]
