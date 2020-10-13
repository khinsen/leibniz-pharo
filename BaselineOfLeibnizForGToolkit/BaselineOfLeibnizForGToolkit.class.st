Class {
	#name : #BaselineOfLeibnizForGToolkit,
	#superclass : #BaselineOf,
	#category : #BaselineOfLeibnizForGToolkit
}

{ #category : #baseline }
BaselineOfLeibnizForGToolkit >> baseline: spec [
	<baseline>
	
	spec for: #common do: [

		spec postLoadDoIt: #'postload:package:'.

		spec
			baseline: 'RecursiveWriteBarrier' 
			with: [ spec repository: 'github://khinsen/RecursiveWriteBarrier:master/src' ].

		spec
			baseline: 'EqualityThroughVariablesTrait' 
			with: [ spec repository: 'github://khinsen/EqualityThroughVariablesTrait:master/src' ].

		spec
			package: 'Leibniz'
			with: [ spec requires: #('RecursiveWriteBarrier'
											'EqualityThroughVariablesTrait')];
			package: 'BaselineOfLeibnizForGToolkit'.

].

]

{ #category : #baseline }
BaselineOfLeibnizForGToolkit >> postload: loader package: packageSpec [
	LeibnizLibrary reset.
	LbCodeFont chooseDefaultFamily.
]

{ #category : #baseline }
BaselineOfLeibnizForGToolkit >> preload: loader package: packageSpec [
	(Smalltalk globals includesKey: #LeibnizLibrary)
		ifFalse: [ ^ self ].
	LeibnizLibrary reset.
	Smalltalk garbageCollect.

]

{ #category : #baseline }
BaselineOfLeibnizForGToolkit >> projectClass [
	Smalltalk at: #'MetacelloCypressBaselineProject' ifPresent: [ :cl | ^ cl ].
	^ super projectClass

]
