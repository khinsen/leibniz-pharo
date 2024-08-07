Class {
	#name : #LzLepiterExamples,
	#superclass : #Object,
	#traits : 'TGtExampleAssertable',
	#classTraits : 'TGtExampleAssertable classTrait',
	#category : #'Leibniz2-Lepiter'
}

{ #category : #example }
LzLepiterExamples >> allContexts [
	<gtExample>
	| pages |
	pages := LzBook database pages.
	^ pages
		reject: [ :each |
			(each lzDBCache declarationCacheFor:  each) isEmpty ]
		thenCollect: [ :each |
			each title -> (each lzDBCache contextFor: each) ]
]

{ #category : #accessing }
LzLepiterExamples >> allSubcontexts [
	<gtExample>
	| pages |
	pages := LzBook database pages collect: [ :each |
		each ->
			((each lzDBCache declarationCacheFor:  each)
				subcontexts) ].
	^ (pages reject: [ :each | each value isEmpty ]
		thenCollect: [ :eachPage |
			eachPage value collect: [ :eachSubcontext |
				(eachPage key title, '/', eachSubcontext) ->
					(eachPage key lzDBCache
						subcontext: eachSubcontext for: eachPage key title) ]])
			flatten
]

{ #category : #example }
LzLepiterExamples >> arrayIndexing [
	<gtExample>
	| context |
	context := LzBook contextNamed: 'One-dimensional array slicing'.
	^ {
		{ '{[ 1, 2, 3 ]}[2]'. '2' }.
		{ '{[ 1, 2, 3 ]}[2 ⋯ 3]'. '{[ 2, 3 ]}' }.
		{ '{[ 1, 2, 3 ]}[2 ⋯ ∎]'. '{[ 2, 3 ]}' }.
		{ '{[ 1, 2, 3 ]}[2 ⋯ 2]'. '{[ 2 ]}' }.
		{ '{[ 1, 2, 3 ]}[2 ⋯ 1]'. '{[ ]}' }.
	} collect: [ :each |
		| term reducedTerm |
		term := context term: each first.
		reducedTerm := context term: each second.
		self assert: (context reduce: term) equals: reducedTerm.
		{ term. reducedTerm } ]
]

{ #category : #example }
LzLepiterExamples >> booleanUnifications [
	<gtExample>
	| c |
	c := LzBook contextNamed: 'Boolean algebra'.
	^ {
		{'⊤'. 'X_:𝔹, X_'. '(X_=⊤)'}.
		{'X_:𝔹, ¬(X_)'. '¬(⊤)'. '(X_=⊤)'}.
		{'X_:𝔹, X_'. '¬(⊤)'. '(X_=¬(⊤))'}.
		{'⊤ ⊻ ⊥ ⊻ ⊤ ⊻ ¬(⊤)'. 'X_:𝔹, Y_:𝔹, (⊤ ⊻ ⊥ ⊻ X_ ⊻ Y_)'. '(X_=⊤, Y_=¬(⊤))'}.
		{'X_:𝔹, (⊥ ⊻ X_ ⊻ ⊤ ⊻ ¬(⊤))'. 'X_:𝔹, Y_:𝔹, (⊥ ⊻ ⊤ ⊻ X_ ⊻ Y_)'. '(X_=⊤, Y_=¬(⊤))'}.
		{'X_:𝔹, (X_ ⊻ ¬(X_))'. 'X_:𝔹, (⊥ ⊻ ¬(X_))'. '(X_=⊥)'}.
		{'X_:𝔹, Y_:𝔹, (X_ ⊻ ¬(Y_))'. 'Y_:𝔹, (⊥ ⊻ ¬(Y_))'. '(Y_, X_=⊥)'}.
		{'X_:𝔹, (⊥ ⊻ ¬(X_))'. 'Y_:𝔹, (⊥ ⊻ ¬(Y_))'. '(X_=Y_)'}.
		{'⊤'. '⊥'.  '(failure #nonUnifiableTerms: ⊥, ⊤)' }.
		{'foo_:𝔹, ¬(foo_)'. 'bar_:𝔹, ¬(bar_)'. '(bar_=foo_)'}
	} collect: [ :each |
		| unification string |
		unification := (c pattern: each first) unify: (c pattern: each  second).
		string := unification printString.
		self assert: (string allButFirst: (string findString: '(') - 1) equals: each third.
		unification ]
]

{ #category : #example }
LzLepiterExamples >> contravariantSortArguments [
	<gtExample>
	| context |
	context := LzBook contextNamed: 'Functions/contravariance'.
	self
		assert: (context term: 'applyToOneThird(f1)') sort
					asLeibnizSyntaxString
		equals: '[ℝ]'.
	self
		assert: (context term: 'applyToOneThird(f2)') sort
					asLeibnizSyntaxString
		equals: 'ℚ'.
]

{ #category : #example }
LzLepiterExamples >> equalityTerms [
	<gtExample>
	| context |
	context := LzContextBuilder new
				database: LzBook database;
				include: (LzBook contextNamed: 'Term equality');
				include: (LzBook contextNamed: 'One-dimensional arrays');
				include: (LzBook contextNamed: 'Integers');
				context.
	self assert: (context term: '1 == ⊤') hasSort not.
	^ {
		{ '1 == 1'. '⊤'}.
		{ '1 == 2'. '⊥'}.
		{ '{[1]} == {[1]}'. '⊤'}.
		{ '{[1]} == {[2]}'. '⊥'}.
		{ '1 == ⊤'. '1 == ⊤' }.
	} collect: [ :each |
		| term rewrittenTerm expected |
		term := context term: each first.
		expected := context term: each second.
		rewrittenTerm := context reduce: term.
		self assert: rewrittenTerm equals: expected.
		{ term. rewrittenTerm } ]
]

{ #category : #example }
LzLepiterExamples >> fibonacciSeries [
	<gtExample>
	| context cache |
	context := LzBook contextNamed: 'Solving recurrence equations/fibonacci'.
	cache := LzGlobalCache uniqueInstance
				rewriteCacheFor: context.
	^ {
		{ 'F[1]' . '1' }.
		{ 'F[2]' . '1'}.
		{ 'F[3]' . '2'}.
		{ 'F[4]' . '3'}.
		{ 'F[5]' . '5'}.
	}
	collect: [ :each |
		| term result |
		term := context term: each first.
		result := context reduce: term.
		self assert: result equals: (context term: each second).
		self assert: (cache reduce: term) equals: result.
		{ term . result } ]
]

{ #category : #example }
LzLepiterExamples >> integerArithmetic [
	<gtExample>
	| context cache |
	context := LzBook contextNamed: 'Integers'.
	cache := LzGlobalCache uniqueInstance
				rewriteCacheFor: context.
	^ {
		{ '-(2)'. '-2' }.
		{ '2 + 2'. '4'}.
		{ '2 - 2'. '0'}.
		{ '3 × 2'. '6'}.
		{ '3 div 2'. '1'}.		
		{ '3 rem 2'. '1'}.
		{ '3^(2)'. '9'}.
		{ '3^(0)'. '1'}.
		{ '0^(2)'. '0'}.
		{ '2 < 3'. '⊤'}.
		{ '2 > 3'. '⊥'}.
	}
	collect: [ :each |
		| term result |
		term := context term: each first.
		result := context reduce: term.
		self assert: result equals: (context term: each second).
		self assert: (cache reduce: term) equals: result.
		{ term. result } ]
]

{ #category : #example }
LzLepiterExamples >> integerTerms [
	<gtExample>
	| context |
	context := LzBook contextNamed: 'Integers'.
	^ {
		{ '0'. 'zero'. }.
		{ '1'. 'one' }.
		{ '-1'. 'ℤ.nz' }.
		{ '-1 + 1'. 'ℤ' }.
		{ '1 + 1'. 'ℕ.nz' }.
	}
	collect: [ :each |
		| term |
		term := context term: each first.
		self assert: term sort asLeibnizSyntaxString equals: each second.
		term  ]
]

{ #category : #example }
LzLepiterExamples >> rationalArithmetic [
	<gtExample>
	| context cache |
	context := LzBook contextNamed: 'Rational numbers'.
	cache := LzGlobalCache uniqueInstance
				rewriteCacheFor: context.
	^ {
		{ '-(2/3)'. '-2/3' }.
		{ '1/3 + 2/3'. '1'}.
		{ '2/3 - 2/3'. '0'}.
		{ '1/3 × 2/5'. '2/15'}.
		{ '3 ÷ 2'. '3/2'}.
		{ '3/2^(2)'. '9/4'}.
		{ '3/2^(0)'. '1'}.
		{ '2/5 < 3/5'. '⊤'}.
		{ '2/5 > 3/5'. '⊥'}.
	}
	collect: [ :each |
		| term result |
		term := context term: each first.
		result := context reduce: term.
		self assert: result equals: (context term: each second).
		self assert: (cache reduce: term) equals: result.
		{ term. result } ]
]

{ #category : #example }
LzLepiterExamples >> rationalNumberTerms [
	<gtExample>
	| context |
	context := LzBook contextNamed: 'Rational numbers'.
	^ {
		{ '0'. 'zero'. }.
		{ '1'. 'one' }.
		{ '-1'. 'ℤ.nz' }.
		{ '-1 + 1'. 'ℤ' }.
		{ '1 + 1'. 'ℕ.nz' }.
		{ '1/3'. 'ℚ.p' }.
		{ '-1/3'. 'ℚ.nz' }.
		{ '-1/3 + 1/3'. 'ℚ' }.
		{ '1/3 + 1/3'. 'ℚ.p' }.
	}
	collect: [ :each |
		| term |
		term := context term: each first.
		self assert: term sort asLeibnizSyntaxString equals: each second.
		term  ]
]

{ #category : #accessing }
LzLepiterExamples >> stringOperations [
	<gtExample>
	| context |
	context := LzBook dbCache
				contextFor: 'Character strings'.
	^ {
		{ '"" + ""'. '""' }.
		{ '"abc" + "xyz"'. '"abcxyz"'}.
		{ '"abc" + ""'. '"abc"'}.
	}
	collect: [ :each |
		| term result |
		term := context term: each first.
		result := context reduce: term.
		self assert: result equals: (context term: each second).
		{ term. result } ]
]

{ #category : #accessing }
LzLepiterExamples >> stringTerms [
	<gtExample>
	| context |
	context := LzBook dbCache
				contextFor: 'Character strings'.
	^ {
		{ '""'. 'String'. }.
		{ '"abc"'. 'String' }.
	}
	collect: [ :each |
		| term |
		term := context term: each first.
		self assert: term sort asLeibnizSyntaxString equals: each second.
		term  ]
]
