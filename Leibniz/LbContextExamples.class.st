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
LbContextExamples >> derivativeContext [
	<gtExample>
	^ (LbContextBuilder name: 'derivatives-ℝ→ℝ')
		include: (LbContextExamples new realFunctionContext) inMode: #extend;
		parseAndAddOp: '𝒟(ℝ→ℝ) : ℝ→ℝ';
		parseAndAddRule: '𝒟(f + g) ⇒ 𝒟(f) + 𝒟(g)';
		parseAndAddRule: '𝒟(f - g) ⇒ 𝒟(f) - 𝒟(g)';
		parseAndAddRule: '𝒟(s × f) ⇒ s × 𝒟(f)';
		parseAndAddRule: '𝒟(f × g) ⇒ (𝒟(f) × g) + (f × 𝒟(g))';
		parseAndAddRule: '𝒟(f ○ g) ⇒ (𝒟(f) ○ g) × 𝒟(g)';
		context
]

{ #category : #example }
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

{ #category : #example }
LbContextExamples >> realFunctionContext [
	<gtExample>
	^ (LbContextBuilder name: 'ℝ→ℝ')
		include: (LbBuiltinContexts realNumberContext) inMode: #use;
		parseAndAddSort: 'ℝ→ℝ';
		parseAndAddOp: 'ℝ→ℝ[ℝ] : ℝ';
		parseAndAddOp: 'f:ℝ→ℝ ○ g:ℝ→ℝ : ℝ→ℝ';
		parseAndAddOp: 's:ℝ × g:ℝ→ℝ : ℝ→ℝ';
		parseAndAddOp: 'f:ℝ→ℝ + g:ℝ→ℝ : ℝ→ℝ';
		parseAndAddOp: 'f:ℝ→ℝ - g:ℝ→ℝ : ℝ→ℝ';
		parseAndAddOp: 'f:ℝ→ℝ × g:ℝ→ℝ : ℝ→ℝ';
		parseAndAddRule: '∀ x:ℝ (f + g)[x] ⇒ f[x] + g[x]';
		parseAndAddRule: '∀ x:ℝ (f - g)[x] ⇒ f[x] - g[x]';
		parseAndAddRule: '∀ x:ℝ (f × g)[x] ⇒ f[x] × g[x]';
		parseAndAddRule: '∀ x:ℝ (s × g)[x] ⇒ s × g[x]';
		parseAndAddRule: '∀ x:ℝ (f ○ g)[x] ⇒ f[g[x]]';
		context
]
