Class {
	#name : #LzBindingsSortVarNode,
	#superclass : #LzBindingsVarNode,
	#category : #'Leibniz2-Terms'
}

{ #category : #accessing }
LzBindingsSortVarNode >> unifyWithValue: aTerm bindings: anLzBindings [
	value
		ifNil: [
			anLzBindings failUnless: aTerm sort isSubsortOf: sort.
			self value: aTerm ]
		ifNotNil: [
			| sortGraph sortPair |
			sortGraph := anLzBindings sortGraph.
			sortPair := LzSortPair new
							sortGraph: sortGraph;
							sort1: (sortGraph sortWithTerm: aTerm) ;
							sort2: (sortGraph sortWithTerm: value).
			sortPair leastUniqueCommonSupersort
				ifNil: [ anLzBindings failWith: aTerm notUnifiableWith: value ]
				ifNotNil: [ :s | self value: s term ] ]
]
