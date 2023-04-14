Class {
	#name : #LzPatternMatcher,
	#superclass : #Object,
	#instVars : [
		'pattern',
		'term'
	],
	#category : #'Leibniz2-Terms'
}

{ #category : #inspecting }
LzPatternMatcher >> gtPatternFor: aView [
	<gtView>
	^ aView forward
		title: 'Pattern';
		priority: 2;
		object: [ self pattern ];
		view: #gtTreeFor:;
		yourself
]

{ #category : #inspecting }
LzPatternMatcher >> gtTermFor: aView [
	<gtView>
	^ aView forward
		title: 'Term';
		priority: 3;
		object: [ self term ];
		view: #gtTreeFor:;
		yourself
]

{ #category : #accessing }
LzPatternMatcher >> pattern [
	^ pattern
]

{ #category : #accessing }
LzPatternMatcher >> pattern: anObject [
	pattern := anObject
]

{ #category : #accessing }
LzPatternMatcher >> term [
	^ term
]

{ #category : #accessing }
LzPatternMatcher >> term: anLzTerm [
	 term := anLzTerm
]
