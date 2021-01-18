Class {
	#name : #LbEqualityAxiom,
	#superclass : #LbAxiom,
	#instVars : [
		'right',
		'left',
		'condition'
	],
	#category : #'Leibniz-5-Axioms'
}

{ #category : #'instace creation' }
LbEqualityAxiom class >> left: aLeftTerm right: aRightTerm [
	^ self
		left: aLeftTerm
		right: aRightTerm
		localVariables: Dictionary new
		condition: nil
]

{ #category : #'instace creation' }
LbEqualityAxiom class >> left: aLeftTerm right: aRightTerm localVariables: aDictionary [
	^ self
		left: aLeftTerm
		right: aRightTerm
		localVariables: aDictionary
		condition: nil
]

{ #category : #'instance creation' }
LbEqualityAxiom class >> left: aLeftTerm right: aRightTerm localVariables: aDictionary condition: aBooleanTerm [ 
	^ self basicNew
			 initializeWithLeft: aLeftTerm
			 right: aRightTerm
			 localVariables: aDictionary
			 condition: aBooleanTerm;
			 yourself
]

{ #category : #accessing }
LbEqualityAxiom >> condition [
	^ condition
]

{ #category : #inspecting }
LbEqualityAxiom >> gtEquationFor: aView [
	<gtView>
	| equationView |
	equationView := aView columnedList
		title: 'Equation' translated;
		priority: 0;
		items: [ { self } ];
		column: 'Variables' lbCode: [ :each |
			String streamContents: [ :s |
				each printVariablesAsLeibnizSyntaxOn: s ] ];
		column: 'Left' lbCode: [ :each |
			String streamContents: [ :s |
				each left printAsLeibnizSyntaxOn: s ] ];
		column: 'Right' lbCode: [ :each |
			String streamContents: [ :s |
				each right printAsLeibnizSyntaxOn: s ] ].
		condition ifNotNil: [
			equationView column: 'Condition' lbCode: [ :each |
			String streamContents: [ :s |
				each condition printAsLeibnizSyntaxOn: s ] ] ].
	^ equationView
]

{ #category : #initialization }
LbEqualityAxiom >> initializeWithLeft: aLeftTerm right: aRightTerm localVariables: aDictionary condition: aBooleanTerm [
	| termVariables |
	left  := aLeftTerm.
	right := aRightTerm.
	condition := aBooleanTerm.
	variables := aDictionary.
	signature := left signature.
	self assert: right signature equals: signature.
	condition ifNotNil:
		[ self assert: condition signature equals: signature ].

	termVariables := left variables copy.
	termVariables addAll: right variables.
	condition ifNotNil: [
		condition variables associationsDo: [ :each |
			self
				assert: (termVariables includesAssociation: each)
				description: 'Variable ', each key asSymbol, ' in condition but not in left or right term'  ] ].

	self beRecursivelyReadOnlyObject
]

{ #category : #accessing }
LbEqualityAxiom >> left [
	^ left
]

{ #category : #printing }
LbEqualityAxiom >> printAsLeibnizSyntaxOn: aStream [
	self printVariablesAsLeibnizSyntaxOn: aStream.
	aStream nextPut: Character space.
	left printAsLeibnizSyntaxOn: aStream.
	aStream nextPutAll: ' = '.
	right printAsLeibnizSyntaxOn: aStream.
	condition ifNotNil: [
		aStream nextPutAll: ' | '.
		condition printAsLeibnizSyntaxOn: aStream ]
]

{ #category : #accessing }
LbEqualityAxiom >> right [
	^ right
]
