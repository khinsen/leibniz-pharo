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
LzContextCache >> contextForPageNamed: aString [
	| cacheValid |
	cacheValid := creationDates at: aString
		ifPresent: [ :cd | cd >= (LzBook latestEditTimeOfPageNamed: aString) time ]
		ifAbsent: [ false ].
	cacheValid ifFalse: [
		contexts
			at: aString
			put: (LzContextBuilder fromPage: aString) context.
		creationDates at: aString put: DateAndTime now ].
	^ contexts at: aString
]

{ #category : #initializing }
LzContextCache >> initialize [
	contexts := Dictionary new.
	creationDates := Dictionary new.
]
