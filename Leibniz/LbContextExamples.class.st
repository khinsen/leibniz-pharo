Class {
	#name : #LbContextExamples,
	#superclass : #Object,
	#category : #'Leibniz-6-Contexts'
}

{ #category : #example }
LbContextExamples >> booleanContext [
	<gtExample>
	^ LbContext
		name: 'boolean'
		signature: (LbSignatureExamples new booleanSignature)
		rewriteSystem: (LbRewriteSystemExamples new booleanRewriteSystem)
]

{ #category : #example }
LbContextExamples >> createMassUnitContext [
	<gtExample>
	^ (LbContextBuilder name: 'mass-units')
		include: 'mass' inMode: #extend;
		include: 'boolean' inMode: #use;
		parseAndAddSort: 'mass-unit ⊆ mass';
		parseAndAddOp: 'kg : mass-unit';
		parseAndAddOp: 'g : mass-unit';
		parseAndAddOp: 'mg : mass-unit';
		parseAndAddOp: 'mass in mass-unit : mass';
		parseAndAddVar: 'MU:mass-unit';
		parseAndAddVar: 'MU1:mass-unit';
		parseAndAddVar: 'MU2:mass-unit';
		parseAndAddRule: 'g ÷ kg ⇒ 1/1000';
		parseAndAddRule: 'mg ÷ kg ⇒ 1/1000000';
		parseAndAddRule: 'M in MU ⇒ (M ÷ MU) × MU';
		parseAndAddRule: 'MU1 ÷ MU2 ⇒ (MU1 ÷ kg) ÷ (MU2 ÷ kg) | ¬(MU2 == kg)';
		context
]

{ #category : #accessing }
LbContextExamples >> massContext [
	<gtExample>
	^ (LbContextBuilder name: 'mass')
		include: (LbBuiltinContexts realNumberContext) inMode: #use;
		parseAndAddSort: 'mass';
		parseAndAddOp: 'mass + mass : mass';
		parseAndAddOp: 'ℝ.p × mass : mass';
		parseAndAddOp: 'mass ÷ ℝ.p : mass';
		parseAndAddOp: 'mass ÷ mass : ℝ.p';
		parseAndAddVar: 'M:mass';
		parseAndAddVar: 'M1:mass';
		parseAndAddVar: 'M2:mass';
		parseAndAddVar: 'F:ℝ.p';
		parseAndAddVar: 'F1:ℝ.p';
		parseAndAddVar: 'F2:ℝ.p';
		parseAndAddRule: '(F1 × M) + (F2 × M) ⇒ (F1 + F2) × M';
		parseAndAddRule: 'F1 × (F2 × M) ⇒ (F1 × F2) × M';
		parseAndAddRule: 'M ÷ F ⇒ (1 ÷ F) × M';
		parseAndAddRule: 'M1 ÷ (F × M2) ⇒ (M1 ÷ F) ÷ M2';
		parseAndAddRule: '(F × M1) ÷ M2 ⇒ F × (M1 ÷ M2)';
		parseAndAddRule: 'M ÷ M ⇒ 1';
		context
]

{ #category : #example }
LbContextExamples >> massUnitContext [
	<gtExample>
	^ (LbContextBuilder name: 'mass-units')
		include: (LbContextExamples new massContext) inMode: #extend;
		include: (LbContextExamples new booleanContext) inMode: #use;
		parseAndAddSort: 'mass-unit ⊆ mass';
		parseAndAddOp: 'kg : mass-unit';
		parseAndAddOp: 'g : mass-unit';
		parseAndAddOp: 'mg : mass-unit';
		parseAndAddOp: 'mass in mass-unit : mass';
		parseAndAddVar: 'MU:mass-unit';
		parseAndAddVar: 'MU1:mass-unit';
		parseAndAddVar: 'MU2:mass-unit';
		parseAndAddRule: 'g ÷ kg ⇒ 1/1000';
		parseAndAddRule: 'mg ÷ kg ⇒ 1/1000000';
		parseAndAddRule: 'M in MU ⇒ (M ÷ MU) × MU';
		parseAndAddRule: 'MU1 ÷ MU2 ⇒ (MU1 ÷ kg) ÷ (MU2 ÷ kg) | ¬(MU2 == kg)';
		context
]
