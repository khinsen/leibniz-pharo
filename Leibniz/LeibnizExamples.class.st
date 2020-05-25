"
This is a ${class:name=LeibnizDocument}$ holding a few example contexts.
"
Class {
	#name : #LeibnizExamples,
	#superclass : #LeibnizDocument,
	#classInstVars : [
		'uniqueInstance'
	],
	#category : #'Leibniz-Examples'
}

{ #category : #initialization }
LeibnizExamples >> createBooleanContext [
	| contextElement |
	contextElement := XMLDOMParser parse: '<context id="boolean"><includes><include document="e513fb1f0504a951919688029321eaa02b4e2ad014c0979c4b602b946f9cafc8" mode="use" context="truth"/></includes><context-refs/><sorts><sort id="boolean"/></sorts><subsorts/><vars><var id="X" sort="boolean"/><var id="Y" sort="boolean"/></vars><ops><op id="_∨"><arity><sort id="boolean"/><sort id="boolean"/></arity><sort id="boolean"/></op><op id="_⊻"><arity><sort id="boolean"/><sort id="boolean"/></arity><sort id="boolean"/></op><op id="_∧"><arity><sort id="boolean"/><sort id="boolean"/></arity><sort id="boolean"/></op><op id="¬"><arity><sort id="boolean"/></arity><sort id="boolean"/></op></ops><rules><rule><vars><var id="X" sort="boolean"/></vars><pattern><term op="¬"><term-or-var name="X"/></term></pattern><condition/><replacement><term op="_⊻"><term-or-var name="true"/><term-or-var name="X"/></term></replacement></rule><rule><vars><var id="X" sort="boolean"/><var id="Y" sort="boolean"/></vars><pattern><term op="_∨"><term-or-var name="X"/><term-or-var name="Y"/></term></pattern><condition/><replacement><term op="_⊻"><term op="_⊻"><term-or-var name="X"/><term-or-var name="Y"/></term><term op="_∧"><term-or-var name="X"/><term-or-var name="Y"/></term></term></replacement></rule><rule><vars><var id="X" sort="boolean"/></vars><pattern><term op="_∧"><term-or-var name="X"/><term-or-var name="false"/></term></pattern><condition/><replacement><term-or-var name="false"/></replacement></rule><rule><vars><var id="X" sort="boolean"/></vars><pattern><term op="_∧"><term-or-var name="false"/><term-or-var name="X"/></term></pattern><condition/><replacement><term-or-var name="false"/></replacement></rule><rule><vars><var id="X" sort="boolean"/></vars><pattern><term op="_∧"><term-or-var name="X"/><term-or-var name="true"/></term></pattern><condition/><replacement><term-or-var name="X"/></replacement></rule><rule><vars><var id="X" sort="boolean"/></vars><pattern><term op="_∧"><term-or-var name="true"/><term-or-var name="X"/></term></pattern><condition/><replacement><term-or-var name="X"/></replacement></rule><rule><vars><var id="X" sort="boolean"/></vars><pattern><term op="_∧"><term-or-var name="X"/><term-or-var name="X"/></term></pattern><condition/><replacement><term-or-var name="X"/></replacement></rule><rule><vars><var id="X" sort="boolean"/></vars><pattern><term op="_⊻"><term-or-var name="X"/><term-or-var name="false"/></term></pattern><condition/><replacement><term-or-var name="X"/></replacement></rule><rule><vars><var id="X" sort="boolean"/></vars><pattern><term op="_⊻"><term-or-var name="false"/><term-or-var name="X"/></term></pattern><condition/><replacement><term-or-var name="X"/></replacement></rule><rule><vars><var id="X" sort="boolean"/></vars><pattern><term op="_⊻"><term-or-var name="X"/><term-or-var name="X"/></term></pattern><condition/><replacement><term-or-var name="false"/></replacement></rule><rule><vars><var id="Z" sort="boolean"/><var id="X" sort="boolean"/><var id="Y" sort="boolean"/></vars><pattern><term op="_∧"><term-or-var name="X"/><term op="_⊻"><term-or-var name="Y"/><term-or-var name="Z"/></term></term></pattern><condition/><replacement><term op="_⊻"><term op="_∧"><term-or-var name="X"/><term-or-var name="Y"/></term><term op="_∧"><term-or-var name="X"/><term-or-var name="Z"/></term></term></replacement></rule></rules><assets/></context>'.
	self fromXML: contextElement.

]

{ #category : #initialization }
LeibnizExamples >> createDerivativeContext [
	| contextElement |
	contextElement := XMLDOMParser parse: '<context id="derivatives-ℝ→ℝ"><includes><include mode="extend" context="ℝ→ℝ"/></includes><context-refs/><sorts/><subsorts/><vars/><ops><op id="𝒟"><arity><sort id="ℝ→ℝ"/></arity><sort id="ℝ→ℝ"/></op></ops><rules><rule><vars/><pattern><term op="𝒟"><term op="_+"><term-or-var name="f"/><term-or-var name="g"/></term></term></pattern><condition/><replacement><term op="_+"><term op="𝒟"><term-or-var name="f"/></term><term op="𝒟"><term-or-var name="g"/></term></term></replacement></rule><rule><vars/><pattern><term op="𝒟"><term op="_-"><term-or-var name="f"/><term-or-var name="g"/></term></term></pattern><condition/><replacement><term op="_-"><term op="𝒟"><term-or-var name="f"/></term><term op="𝒟"><term-or-var name="g"/></term></term></replacement></rule><rule><vars/><pattern><term op="𝒟"><term op="_×"><term-or-var name="s"/><term-or-var name="f"/></term></term></pattern><condition/><replacement><term op="_×"><term-or-var name="s"/><term op="𝒟"><term-or-var name="f"/></term></term></replacement></rule><rule><vars/><pattern><term op="𝒟"><term op="_×"><term-or-var name="f"/><term-or-var name="g"/></term></term></pattern><condition/><replacement><term op="_+"><term op="_×"><term op="𝒟"><term-or-var name="f"/></term><term-or-var name="g"/></term><term op="_×"><term-or-var name="f"/><term op="𝒟"><term-or-var name="g"/></term></term></term></replacement></rule><rule><vars/><pattern><term op="𝒟"><term op="_○"><term-or-var name="f"/><term-or-var name="g"/></term></term></pattern><condition/><replacement><term op="_×"><term op="_○"><term op="𝒟"><term-or-var name="f"/></term><term-or-var name="g"/></term><term op="𝒟"><term-or-var name="g"/></term></term></replacement></rule></rules><assets/></context>'.
	self fromXML: contextElement.

]

{ #category : #initialization }
LeibnizExamples >> createFunctionContext [
	| contextElement |
	contextElement := XMLDOMParser parse: '<context id="ℝ→ℝ"><includes><include document="e513fb1f0504a951919688029321eaa02b4e2ad014c0979c4b602b946f9cafc8" mode="use" context="real-numbers"/></includes><context-refs/><sorts><sort id="ℝ→ℝ"/></sorts><subsorts/><vars><var id="s" sort="ℝ"/><var id="X" sort="ℝ"/><var id="Y" sort="ℝ"/><var id="g" sort="ℝ→ℝ"/><var id="f" sort="ℝ→ℝ"/></vars><ops><op id="_○"><arity><var id="f" sort="ℝ→ℝ"/><var id="g" sort="ℝ→ℝ"/></arity><sort id="ℝ→ℝ"/></op><op id="_×"><arity><var id="s" sort="ℝ"/><var id="g" sort="ℝ→ℝ"/></arity><sort id="ℝ→ℝ"/></op><op id="[]"><arity><sort id="ℝ→ℝ"/><sort id="ℝ"/></arity><sort id="ℝ"/></op><op id="_-"><arity><var id="f" sort="ℝ→ℝ"/><var id="g" sort="ℝ→ℝ"/></arity><sort id="ℝ→ℝ"/></op><op id="_×"><arity><var id="f" sort="ℝ→ℝ"/><var id="g" sort="ℝ→ℝ"/></arity><sort id="ℝ→ℝ"/></op><op id="_+"><arity><var id="f" sort="ℝ→ℝ"/><var id="g" sort="ℝ→ℝ"/></arity><sort id="ℝ→ℝ"/></op></ops><rules><rule><vars><var id="x" sort="ℝ"/></vars><pattern><term op="[]"><term op="_+"><term-or-var name="f"/><term-or-var name="g"/></term><term-or-var name="x"/></term></pattern><condition/><replacement><term op="_+"><term op="[]"><term-or-var name="f"/><term-or-var name="x"/></term><term op="[]"><term-or-var name="g"/><term-or-var name="x"/></term></term></replacement></rule><rule><vars><var id="x" sort="ℝ"/></vars><pattern><term op="[]"><term op="_-"><term-or-var name="f"/><term-or-var name="g"/></term><term-or-var name="x"/></term></pattern><condition/><replacement><term op="_-"><term op="[]"><term-or-var name="f"/><term-or-var name="x"/></term><term op="[]"><term-or-var name="g"/><term-or-var name="x"/></term></term></replacement></rule><rule><vars><var id="x" sort="ℝ"/></vars><pattern><term op="[]"><term op="_×"><term-or-var name="f"/><term-or-var name="g"/></term><term-or-var name="x"/></term></pattern><condition/><replacement><term op="_×"><term op="[]"><term-or-var name="f"/><term-or-var name="x"/></term><term op="[]"><term-or-var name="g"/><term-or-var name="x"/></term></term></replacement></rule><rule><vars><var id="x" sort="ℝ"/></vars><pattern><term op="[]"><term op="_×"><term-or-var name="s"/><term-or-var name="g"/></term><term-or-var name="x"/></term></pattern><condition/><replacement><term op="_×"><term-or-var name="s"/><term op="[]"><term-or-var name="g"/><term-or-var name="x"/></term></term></replacement></rule><rule><vars><var id="x" sort="ℝ"/></vars><pattern><term op="[]"><term op="_○"><term-or-var name="f"/><term-or-var name="g"/></term><term-or-var name="x"/></term></pattern><condition/><replacement><term op="[]"><term-or-var name="f"/><term op="[]"><term-or-var name="g"/><term-or-var name="x"/></term></term></replacement></rule></rules><assets/></context>'.
	self fromXML: contextElement.

]

{ #category : #initialization }
LeibnizExamples >> createMassContext [
	| b |
	b := self newContextBuilderNamed: 'mass'.
	b include: 'real-numbers'
	  fromDocumentWithHash: 'e513fb1f0504a951919688029321eaa02b4e2ad014c0979c4b602b946f9cafc8'
	  inMode: #use.
	b parseAndAddSort: 'mass'.
	b parseAndAddOp: 'mass + mass : mass'.
	b parseAndAddOp: 'ℝ.p × mass : mass'.
	b parseAndAddOp: 'mass ÷ ℝ.p : mass'.
	b parseAndAddOp: 'mass ÷ mass : ℝ.p'.
	b parseAndAddVar: 'M:mass'.
	b parseAndAddVar: 'M1:mass'.
	b parseAndAddVar: 'M2:mass'.
	b parseAndAddVar: 'F:ℝ.p'.
	b parseAndAddVar: 'F1:ℝ.p'.
	b parseAndAddVar: 'F2:ℝ.p'.
	b parseAndAddRule: '(F1 × M) + (F2 × M) ⇒ (F1 + F2) × M'.
	b parseAndAddRule: 'F1 × (F2 × M) ⇒ (F1 × F2) × M'.
	b parseAndAddRule: 'M ÷ F ⇒ (1 ÷ F) × M'.
	b parseAndAddRule: 'M1 ÷ (F × M2) ⇒ (M1 ÷ F) ÷ M2'.
	b parseAndAddRule: '(F × M1) ÷ M2 ⇒ F × (M1 ÷ M2)'.
	b parseAndAddRule: 'M ÷ M ⇒ 1'.
	b build.
]

{ #category : #initialization }
LeibnizExamples >> createMassUnitContext [
	| b |
	b := self newContextBuilderNamed: 'mass-units'.
	b include: 'mass'
	  inMode: #extend.
	b include: 'boolean'
	  inMode: #use.
	b parseAndAddSort: 'mass-unit ⊆ mass'.
	b parseAndAddOp: 'kg : mass-unit'.
	b parseAndAddOp: 'g : mass-unit'.
	b parseAndAddOp: 'mg : mass-unit'.
	b parseAndAddOp: 'mass in mass-unit : mass'.
	b parseAndAddVar: 'MU:mass-unit'.
	b parseAndAddVar: 'MU1:mass-unit'.
	b parseAndAddVar: 'MU2:mass-unit'.
	b parseAndAddRule: 'g ÷ kg ⇒ 1/1000'.
	b parseAndAddRule: 'mg ÷ kg ⇒ 1/1000000'.
	b parseAndAddRule: 'M in MU ⇒ (M ÷ MU) × MU'.
	b parseAndAddRule: 'MU1 ÷ MU2 ⇒ (MU1 ÷ kg) ÷ (MU2 ÷ kg) | ¬(MU2 == kg)'.
	b build.
]

{ #category : #initialization }
LeibnizExamples >> initialize [
	super initialize.
	self docHash: (SHA256 hashMessage: 'examples') hex.
	self createBooleanContext.
	self createFunctionContext.
	self createDerivativeContext.
	self createMassContext.
	self createMassUnitContext.

]
