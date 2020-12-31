Class {
	#name : #LbStatementExamples,
	#superclass : #Object,
	#traits : 'TGtExampleAssertable',
	#classTraits : 'TGtExampleAssertable classTrait',
	#category : #'Leibniz-5-Statements'
}

{ #category : #example }
LbStatementExamples >> equations [
	<gtExample>
	^ (LbStatementsBuilder signature: LbBuiltinSignatures integerSignature)
		parseAndAdd: '∀ X:zero abs(X) = 0';
		statements
]

{ #category : #accessing }
LbStatementExamples >> foo [
	<gtExample>
	^ self equations equations
]
