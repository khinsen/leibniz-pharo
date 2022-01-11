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
			baseline: 'SingletonTrait' 
			with: [ spec repository: 'github://khinsen/SingletonTrait:master' ].

		spec
			package: 'Leibniz'
			with: [ spec requires:
						#('RecursiveWriteBarrier'
							'EqualityThroughVariablesTrait'
							'SingletonTrait') ].

		spec
			package: 'Leibniz2'
			with: [ spec requires:
						#('RecursiveWriteBarrier'
							'EqualityThroughVariablesTrait'
							'SingletonTrait') ].

]
]

{ #category : #baseline }
BaselineOfLeibnizForGToolkit >> postload: loader package: packageSpec [
	LbCodeFont chooseDefaultFamily.
	LzCodeFont chooseDefaultFamily.
]
