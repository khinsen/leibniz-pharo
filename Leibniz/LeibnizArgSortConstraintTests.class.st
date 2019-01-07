Class {
	#name : #LeibnizArgSortConstraintTests,
	#superclass : #TestCase,
	#instVars : [
		'sortGraph'
	],
	#category : #'Leibniz-Tests'
}

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

]

{ #category : #testing }
LeibnizArgSortConstraintTests >> testConstraintConformity [
	| a b v w ka kb kw |
	a := LeibnizSortOrSubsortConstraint sortGraph: sortGraph sort: #A.
	b := LeibnizSortOrSubsortConstraint sortGraph: sortGraph sort: #B.
	v := LeibnizSortOrSubsortConstraint sortGraph: sortGraph sort: #V.
	w := LeibnizSortOrSubsortConstraint sortGraph: sortGraph sort: #W.
	ka := LeibnizKindConstraint sortGraph: sortGraph kind: (sortGraph kindOf: #A).
	kb := LeibnizKindConstraint sortGraph: sortGraph kind: (sortGraph kindOf: #B).
	kw := LeibnizKindConstraint sortGraph: sortGraph kind: (sortGraph kindOf: #W).
	self assert: (b isConformingSortConstraint: a).
	self assert: (w isConformingSortConstraint: w).
	self assert: (kb isConformingSortConstraint: a).
	self assert: (kw isConformingSortConstraint: v).
	self deny:   (ka isConformingSortConstraint: v).
	self deny:   (a isConformingSortConstraint: v).
	self assert: (kb isConformingSortConstraint: ka).
	self deny:   (kw isConformingSortConstraint: ka).

]
