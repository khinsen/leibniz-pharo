Class {
	#name : #LzGlobalCache,
	#superclass : #Object,
	#traits : 'TSingleton',
	#classTraits : 'TSingleton classTrait',
	#instVars : [
		'rewriteCaches'
	],
	#category : #'Leibniz2-Lepiter'
}

{ #category : #initializing }
LzGlobalCache >> initialize [
	rewriteCaches := WeakIdentityKeyDictionary new.
]

{ #category : #accessing }
LzGlobalCache >> rewriteCacheFor: aContext [
	^ rewriteCaches at: aContext ifAbsent: [
		rewriteCaches
			at: aContext
			put: (LzRewriteCache new
					rewriteSystem: aContext rewriteSystem) ]
]
