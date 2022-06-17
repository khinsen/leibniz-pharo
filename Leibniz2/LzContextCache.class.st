Class {
	#name : #LzContextCache,
	#superclass : #Object,
	#traits : 'TSingleton',
	#classTraits : 'TSingleton classTrait',
	#instVars : [
		'contexts',
		'creationDates'
	],
	#category : #'Leibniz2-Lepiter'
}

{ #category : #retrieving }
LzContextCache >> contextForPageNamed: pageName [
	^ self contextForPageNamed: pageName subcontext: nil
]

{ #category : #retrieving }
LzContextCache >> contextForPageNamed: pageName subcontext: aString [
	| fullName cacheValid |
	fullName := pageName.
	aString ifNotNil: [ fullName := fullName, '/', aString ].
	cacheValid := creationDates at: fullName
		ifPresent: [ :cd | cd >= (LzBook latestEditTimeOfPageNamed: pageName) time ]
		ifAbsent: [ false ].
	cacheValid ifFalse: [
		contexts
			at: fullName
			put: (LzContextBuilder fromPage: pageName subcontext: aString) context.
		creationDates at: fullName put: DateAndTime now ].
	^ contexts at: fullName
]

{ #category : #inspecting }
LzContextCache >> gtContextsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Contexts';
		priority: 0;
		items: [ contexts associations ];
		send: #value;
		column: 'Name' text: #key;
		column: 'Date/time' text: [ :each |
			creationDates at: each key ];
		yourself
]

{ #category : #initializing }
LzContextCache >> initialize [
	contexts := Dictionary new.
	creationDates := Dictionary new.
]
