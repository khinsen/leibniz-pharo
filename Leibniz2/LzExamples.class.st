Class {
	#name : #LzExamples,
	#superclass : #Object,
	#traits : 'TGtExampleAssertable',
	#classTraits : 'TGtExampleAssertable classTrait',
	#category : #'Leibniz2-Leibniz2'
}

{ #category : #example }
LzExamples >> simpleContext [
	^ self simpleContextBuilder build
]

{ #category : #example }
LzExamples >> simpleContextBuilder [
	^ LzContextBuilder new
		sort: 'Foo';
		op: 'aFoo : Foo'.
]
