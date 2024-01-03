Class {
	#name : #LzDBRegistry,
	#superclass : #Object,
	#traits : 'TSingleton',
	#classTraits : 'TSingleton classTrait',
	#instVars : [
		'dbCaches'
	],
	#classInstVars : [
		'uniqueInstance'
	],
	#category : #'Leibniz2-Lepiter'
}

{ #category : #querying }
LzDBRegistry >> dbCacheFor: anLeDatabase [
	^ dbCaches at: anLeDatabase
		ifAbsentPut: [ LzDBCache forDatabase:  anLeDatabase ]
]

{ #category : #initialialize }
LzDBRegistry >> initialize [
	dbCaches := IdentityDictionary new.
]
