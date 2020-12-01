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
	LbCodeFont chooseDefaultFamily
]

{ #category : #baseline }
BaselineOfLeibnizForGToolkit >> projectClass [
	Smalltalk at: #'MetacelloCypressBaselineProject' ifPresent: [ :cl | ^ cl ].
	^ super projectClass

]
