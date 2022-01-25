Class {
	#name : #LzSubsortAxiom,
	#superclass : #LzAxiom,
	#instVars : [
		'supersort',
		'subsort'
	],
	#category : #'Leibniz2-Leibniz2'
}

{ #category : #printing }
LzSubsortAxiom >> printAsLeibnizSyntaxOn: aStream [
	self printVariablesAsLeibnizSyntaxOn: aStream.
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
	self assert: aPattern sort isSortSort.
	subsort := aPattern
]

{ #category : #accessing }
LzSubsortAxiom >> subsortOf: aTerm [
	^ self unify: aTerm with: supersort thenSubstituteIn: subsort
]

{ #category : #accessing }
LzSubsortAxiom >> supersort [
	^ supersort
]

{ #category : #accessing }
LzSubsortAxiom >> supersort: aPattern [
	self assert: aPattern sort isSortSort.
	supersort := aPattern
]

{ #category : #accessing }
LzSubsortAxiom >> supersortOf: aTerm [
	^ self unify: aTerm with: subsort thenSubstituteIn: supersort
]

{ #category : #unifying }
LzSubsortAxiom >> unify: aTerm with: pattern1 thenSubstituteIn: pattern2 [
	| rename preferredVarNames bindings |
	rename := pattern1
		addPrefix: #'temp.'
		toVarsConflictingWith: aTerm.
	preferredVarNames := aTerm vars keys.
	bindings := (pattern1 substitute: rename) unify: aTerm.
	bindings isFailure ifTrue: [ ^ nil ].
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
	^ #(subsort supersort)
]
