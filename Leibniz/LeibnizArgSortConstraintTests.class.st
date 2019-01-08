Class {
	#name : #LeibnizArgSortConstraintTests,
	#superclass : #TestCase,
	#instVars : [
		'sortGraph',
		'a',
		'b',
		'v',
		'w',
		'ka',
		'kb',
		'kw'
	],
	#category : #'Leibniz-Tests'
}

{ #category : #printing }
LeibnizArgSortConstraintTests >> leibnizSyntaxFor: anObject [
	^ String streamContents: [ :s | anObject printAsLeibnizSyntaxOn: s ]

]

{ #category : #running }
LeibnizArgSortConstraintTests >> setUp [
	|  builder |
	super setUp.

   builder := LeibnizSortGraphBuilder new.
	builder add: #A;
        	  add: #B;
         	  add: #C;
  			  add: #D;
			  make: #A subsortOf: #B;
			  make: #B subsortOf: #C;
			  make: #A subsortOf: #D;
			  add: #V;
			  add: #W;
			  make: #V subsortOf: #W.
	sortGraph := builder sortGraph.

	a := LeibnizSortOrSubsortConstraint sortGraph: sortGraph sort: #A.
	b := LeibnizSortOrSubsortConstraint sortGraph: sortGraph sort: #B.
	v := LeibnizSortOrSubsortConstraint sortGraph: sortGraph sort: #V.
	w := LeibnizSortOrSubsortConstraint sortGraph: sortGraph sort: #W.
	ka := LeibnizKindConstraint sortGraph: sortGraph kind: (sortGraph kindOf: #A).
	kb := LeibnizKindConstraint sortGraph: sortGraph kind: (sortGraph kindOf: #B).
	kw := LeibnizKindConstraint sortGraph: sortGraph kind: (sortGraph kindOf: #W).

]

{ #category : #testing }
LeibnizArgSortConstraintTests >> testConformingSorts [
	self assert: b conformingSorts equals: #(#A #B) asSet.
	self assert: kb conformingSorts equals: #(#A #B #C #D) asSet.
	self assert: kw conformingSorts equals: #(#V #W) asSet.

]

{ #category : #testing }
LeibnizArgSortConstraintTests >> testConstraintConformity [
	self assert: (a isConformingSortConstraint: b).
	self deny:   (b isConformingSortConstraint: a).
	self assert: (w isConformingSortConstraint: w).
	self assert: (kb isConformingSortConstraint: a).
	self assert: (kb isConformingSortConstraint: b).
	self assert: (kw isConformingSortConstraint: v).
	self deny:   (ka isConformingSortConstraint: v).
	self deny:   (a isConformingSortConstraint: v).
	self assert: (kb isConformingSortConstraint: ka).
	self deny:   (kw isConformingSortConstraint: ka).

]

{ #category : #testing }
LeibnizArgSortConstraintTests >> testPrinting [
	self assert: (self leibnizSyntaxFor: a)
		  equals: 'A'.
	self assert: (self leibnizSyntaxFor: w)
		  equals: 'W'.
	self assert: (self leibnizSyntaxFor: ka)
		  equals: '[C, D]'.
	self assert: (self leibnizSyntaxFor: kw)
		  equals: '[W]'.

]
