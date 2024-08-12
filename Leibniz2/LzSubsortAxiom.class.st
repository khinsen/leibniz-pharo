Class {
	#name : #LzSubsortAxiom,
	#superclass : #LzAxiom,
	#instVars : [
		'supersort',
		'subsort'
	],
	#category : #'Leibniz2-Axioms'
}

{ #category : #converting }
LzSubsortAxiom >> addBodyAsRopedTextTo: aRopedText [
	subsort addAsRopedTextTo: aRopedText.
	aRopedText append:
		(' ⊆ ' asRopedText attribute: LzSubsortAttribute new).
	supersort addAsRopedTextTo: aRopedText
]

{ #category : #converting }
LzSubsortAxiom >> addConditionAsRopedTextTo: aRopedText [
]

{ #category : #initialization }
LzSubsortAxiom >> buildTermsFrom: aDictionary [
	self subsort: ((aDictionary at: #subsort)
						buildFor: self signature
						variables: self variables).
	self supersort: ((aDictionary at: #supersort)
						buildFor: self signature
						variables: self variables)
]

{ #category : #'instance creation' }
LzSubsortAxiom >> checkSteps [
	self assert: subsort sort isSortSort.
	self assert: supersort sort isSortSort.
]

{ #category : #printing }
LzSubsortAxiom >> printBodyAsLeibnizSyntaxOn: aStream [
	aStream nextPut: Character space.
	subsort printAsLeibnizSyntaxOn: aStream.
	aStream nextPutAll: ' ⊆ '.
	supersort printAsLeibnizSyntaxOn: aStream
]

{ #category : #accessing }
LzSubsortAxiom >> subsort [
	^ subsort
]

{ #category : #accessing }
LzSubsortAxiom >> subsort: aPattern [
	subsort := aPattern
]

{ #category : #accessing }
LzSubsortAxiom >> subsortOf: aTerm inSortGraph: aSortGraph [
	^ self unify: aTerm with: supersort thenSubstituteIn: subsort sortGraph: aSortGraph
]

{ #category : #accessing }
LzSubsortAxiom >> supersort [
	^ supersort
]

{ #category : #accessing }
LzSubsortAxiom >> supersort: aPattern [
	supersort := aPattern
]

{ #category : #accessing }
LzSubsortAxiom >> supersortOf: aTerm inSortGraph: aSortGraph [
	^ self unify: aTerm with: subsort thenSubstituteIn: supersort sortGraph: aSortGraph
]

{ #category : #unifying }
LzSubsortAxiom >> unify: aTerm with: pattern1 thenSubstituteIn: pattern2 sortGraph: aSortGraph [
	| rename preferredVarNames bindings |
	rename := pattern1
		addPrefix: #'temp.'
		toVarsConflictingWith: aTerm.
	preferredVarNames := aTerm vars keys.
	bindings := LzBindings new
					sortGraph:  aSortGraph.
	(pattern1 substitute: rename) unify: aTerm bindings: bindings.
	bindings ifFailure: [ ^ nil ].
	bindings bindToUniqueVar: [ :varSet :sort |
		| name |
		name := (varSet intersection: preferredVarNames) asArray sorted
					ifEmpty: [ varSet anyOne ]
					ifNotEmpty: [ :anArray | anArray first ].
		LzVarTerm new
			signature: signature;
			name: name;
			sort: sort;
			beRecursivelyReadOnlyObject;
			yourself ].
	^ (pattern2 substitute: rename) substitute: bindings
]

{ #category : #accessing }
LzSubsortAxiom >> valueSlots [
	^ super valueSlots, #(subsort supersort)
]
