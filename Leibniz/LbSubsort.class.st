Class {
	#name : #LbSubsort,
	#superclass : #LbStatement,
	#instVars : [
		'subsort',
		'supersort'
	],
	#category : #'Leibniz-5-Statements'
}

{ #category : #'instance creation' }
LbSubsort class >> subsort: subsortTerm supersort: supersortTerm [
	^ self
		subsort: subsortTerm
		supersort: supersortTerm
		localVariables: Dictionary new
]

{ #category : #'instance creation' }
LbSubsort class >> subsort: subsortTerm supersort: supersortTerm localVariables: aDictionary [
	^ self basicNew
		initializeWithSubsort: subsortTerm
		supersort: supersortTerm
		localVariables: aDictionary;
		yourself
]

{ #category : #inspecting }
LbSubsort >> gtRelationFor: aView [
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
LbSubsort >> initializeWithSubsort: subsortTerm supersort: supersortTerm localVariables: aDictionary [
	subsort := subsortTerm.
	supersort := supersortTerm.
	self assert: subsort sort name equals: #sort.
	self assert: supersort sort name equals: #sort.
	variables := aDictionary.
	signature := subsortTerm signature.
	self assert: supersortTerm signature equals: signature.
	self beRecursivelyReadOnlyObject
]

{ #category : #accessing }
LbSubsort >> subsort [
	^ subsort
]

{ #category : #accessing }
LbSubsort >> supersort [
	^ supersort
]
