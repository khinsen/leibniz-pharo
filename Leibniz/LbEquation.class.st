Class {
	#name : #LbEquation,
	#superclass : #LbStatement,
	#instVars : [
		'right',
		'left',
		'condition'
	],
	#category : #'Leibniz-5-Statements'
}

{ #category : #'instace creation' }
LbEquation class >> left: aLeftTerm right: aRightTerm [
	^ self
		left: aLeftTerm
		right: aRightTerm
		localVariables: Dictionary new
		condition: nil
]

{ #category : #'instace creation' }
LbEquation class >> left: aLeftTerm right: aRightTerm localVariables: aDictionary [
	^ self
		left: aLeftTerm
		right: aRightTerm
		localVariables: aDictionary
		condition: nil
]

{ #category : #'instance creation' }
LbEquation class >> left: aLeftTerm right: aRightTerm localVariables: aDictionary condition: aBooleanTerm [ 
	^ self basicNew
			 initializeWithLeft: aLeftTerm
			 right: aRightTerm
			 localVariables: aDictionary
			 condition: aBooleanTerm;
			 yourself
]

{ #category : #accessing }
LbEquation >> condition [
	^ condition
]

{ #category : #inspecting }
LbEquation >> gtEquationFor: aView [
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
LbEquation >> initializeWithLeft: aLeftTerm right: aRightTerm localVariables: aDictionary condition: aBooleanTerm [
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
LbEquation >> left [
	^ left
]

{ #category : #accessing }
LbEquation >> right [
	^ right
]
