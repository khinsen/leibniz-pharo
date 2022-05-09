Class {
	#name : #LzArrayExamples,
	#superclass : #Object,
	#traits : 'TGtExampleAssertable',
	#classTraits : 'TGtExampleAssertable classTrait',
	#category : #'Leibniz2-Leibniz2'
}

{ #category : #example }
LzArrayExamples >> arrayFolds [
	<gtExample>
	| context |
	context := LzContextBuilder new
		include: LzBuiltinContexts arrayFoldContext;
		op: 'sum : fn(ℤ, ℤ, ℤ)';
		rule: '∀ x_:ℤ ∀ y_:ℤ sum[x_, y_] ⇒ x_ + y_';
		op: 'anInteger : ℤ';
		context.
	^ {
		{ 'fold(sum, 0, {[ 1, 2, 3 ]})'. '6' }.
		{ 'fold(sum, 0, {[ 1, 2, anInteger ]})'. '3 + anInteger' }.
	} collect: [ :each |
		| term reducedTerm |
		term := context term: each first.
		reducedTerm := context term: each second.
		self assert: (context reduce: term) equals: reducedTerm.
		{ term. reducedTerm } ]
]

{ #category : #example }
LzArrayExamples >> arrayMappings [
	<gtExample>
	| context |
	context := LzContextBuilder new
		include: LzBuiltinContexts arrayMapContext;
		op: 'abs : fn(ℤ, ℕ)';
		rule: '∀ x_:ℤ abs[x_] ⇒ abs(x_)';
		op: 'anInteger : ℤ';
		context.
	^ {
		{ 'abs[{[ 1, -2, 3 ]}]'. '{[ 1, 2, 3 ]}' }.
		{ 'abs[{[ [1], [-2], [3] ]}]'. '{[ [1], [2], [3] ]}' }.
		{ 'abs[{[ 1, -2, anInteger ]}]'. '{[ 1, 2, abs(anInteger) ]}' }.
	} collect: [ :each |
		| term reducedTerm |
		term := context term: each first.
		reducedTerm := context term: each second.
		self assert: (context reduce: term) equals: reducedTerm.
		{ term. reducedTerm } ]
]

{ #category : #example }
LzArrayExamples >> arrayMappings2 [
	<gtExample>
	| context |
	context := LzContextBuilder new
		include: LzBuiltinContexts arrayMap2Context;
		op: 'sum : fn(ℤ, ℤ, ℤ)';
		rule: '∀ x_:ℤ ∀ y_:ℤ sum[x_, y_] ⇒ x_ + y_';
		op: 'anInteger : ℤ';
		context.
	^ {
		{ 'sum[{[ 1, -2, 3 ]}, {[ 1, 2, 3 ]}]'. '{[ 2, 0, 6 ]}' }.
		{ 'sum[{[ [1], [-2], [3] ]}, {[ [1], [2], [3] ]}]'. '{[ [2], [0], [6] ]}' }.
		{ 'sum[{[ 1, -2, anInteger ]}, {[ 1, 2, 0 ]}]'. '{[ 2, 0, anInteger ]}' }.
	} collect: [ :each |
		| term reducedTerm |
		term := context term: each first.
		reducedTerm := context term: each second.
		self assert: (context reduce: term) equals: reducedTerm.
		{ term. reducedTerm } ]
]

{ #category : #example }
LzArrayExamples >> arrayOfIntegerPatterns [
	<gtExample>
	| context |
	context := LzBuiltinContexts arrayContext.
	^ {
		{ '∀ n_:ℕ {[ 1, n_, 3 ]}'. '{[ 1, 2, 3 ]}'. 1 }.
		{ '∀ i_:ℕ ∀ j_:ℕ ∀ k_:ℕ {[[i_], [j_], [k_]]}'. '{[[0], [1], [2]]}'. 3 }.
		{ '∀ n_:ℕ shape({[n_]})'. 'shape({[3]})'. 1 }.
	} collect: [ :each |
		| pattern term bindings |
		pattern := context pattern: each first.
		term := context term: each second.
		bindings := pattern match: term.
		self assert: bindings bindings size equals: each third.
		self assert: (pattern substitute: bindings) equals: term.
		bindings := pattern unify: term.
		self assert: bindings bindings size equals: each third.
		self assert: (pattern substitute: bindings) equals: term.
		pattern ]
]

{ #category : #example }
LzArrayExamples >> arrayOfIntegerTerms [
	<gtExample>
	| context |
	context := LzBuiltinContexts arrayContext.
	{
		'{[1, [2]]}'.
		'{[[1, 2], [3]]}'.
	} do: [ :each | self
		should: [ context term: each ]
		raise: Error ].
	^ {
		{ '{[]}'. '{[]}'. }.
		{ '{[ 1, 2, 3 ]}'. '{[ 1, 2, 3 ]}' }.
		{ '{[[0], [1], [2]]}'. '{[[0], [1], [2]]}' }.
		{ '{[1 + 2, 2 + 3]}'. '{[3, 5]}' }.
		{ 'shape({[1, 2, 3]})'. '{[3]}' }.
	} collect: [ :each |
		| term reducedTerm |
		term := context term: each first.
		reducedTerm := context term: each second.
		self assert: (context reduce: term) equals: reducedTerm.
		term ]
]
