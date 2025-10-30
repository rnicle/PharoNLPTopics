Class {
	#name : 'TestBPELearner',
	#superclass : 'TestCase',
	#category : ' BPE4',
	#package : ' BPE4'
}

{ #category : 'private' }
TestBPELearner >> array [ 
	^ {'old' . 'old' . 'old' . 'old' . 'old' . 'old' . 'old' . 'older' . 'older' . 'older' . 'finest' . 'finest' . 'finest' . 'finest' . 'finest' . 'finest' . 'finest' . 'finest' . 'finest' . 'lowest' . 'lowest' . 'lowest' . 'lowest'}
]

{ #category : 'tests' }
TestBPELearner >> testBuildVocabularyProducesCorrectVocabulary [

	| enc |
	enc := BPELearner new. 
	enc fromText: self text.
	self 
		assertCollection: enc vocabulary asSet
		hasSameElements: { '</t>' . 'd' . 'e' . 'i' . 'l' . 'f' . 'n' . 'o' . 'r' . 's' . 't' . 'w'} asSet
]

{ #category : 'tests' }
TestBPELearner >> testBuildVocabularyProducesCorrectVocabularyFromArray [

	| enc |
	enc := BPELearner new. 
	enc fromText: self array .
	self 
		assertCollection: enc vocabulary asSet
		hasSameElements: { '</t>' . 'd' . 'e' . 'i' . 'l' . 'f' . 'n' . 'o' . 'r' . 's' . 't' . 'w'} asSet
]

{ #category : 'tests' }
TestBPELearner >> testBuildVocabularyProducesCorrectVocabularyText2 [

	| enc |
	enc := BPELearner new. 
	enc fromText: self text2.
	enc computeVocabulary.
	self assertCollection: enc vocabulary asSet hasSameElements: { '</t>' . 'd' . 'e' . 'i' . 'l' . 'n' . 'o' . 'r' . 's' . 't' . 'w'} asSet
]

{ #category : 'tests' }
TestBPELearner >> testComputePairs [

	| enc |
	enc := BPELearner new. 
	enc fromText: self text.
	
	self assert: (enc paires occurrencesOf: {'o' . 'l'}) equals: 10. 
	self assert: (enc paires occurrencesOf: {'l' . 'd'}) equals: 10. 
	self assert: (enc paires occurrencesOf: {'l' .'d'}) equals: 10. 
	self assert: (enc paires occurrencesOf: {'s' .'t'}) equals: 13. 
	self assert: (enc paires occurrencesOf: {'e' . 's'}) equals: 13. 
	self assert: (enc paires occurrencesOf: {'l' .'o'}) equals: 4. 
	self assert: (enc paires occurrencesOf: {'t' . '</t>'}) equals: 13. 
	
	self assert: enc paires keys size equals: 15
]

{ #category : 'tests' }
TestBPELearner >> testComputePairsArray [

	| enc |
	enc := BPELearner new. 
	enc fromText: self array .
	
	self assert: (enc paires occurrencesOf: {'o' . 'l'}) equals: 10. 
	self assert: (enc paires occurrencesOf: {'l' . 'd'}) equals: 10. 
	self assert: (enc paires occurrencesOf: {'l' .'d'}) equals: 10. 
	self assert: (enc paires occurrencesOf: {'s' .'t'}) equals: 13. 
	self assert: (enc paires occurrencesOf: {'e' . 's'}) equals: 13. 
	self assert: (enc paires occurrencesOf: {'l' .'o'}) equals: 4. 
	self assert: (enc paires occurrencesOf: {'t' . '</t>'}) equals: 13. 
	
	self assert: enc paires keys size equals: 15
]

{ #category : 'tests' }
TestBPELearner >> testComputePairsText2 [

	| enc |
	enc := BPELearner new. 
	enc fromText: self text2.
	
	self assert: (enc paires occurrencesOf: {'e' .'s'}) equals: 9. 
	self assert: (enc paires occurrencesOf: {'i'. 'd'}) equals: 3. 
	self assert: (enc paires occurrencesOf: {'o' .'w'}) equals: 7. 
	self assert: (enc paires occurrencesOf: {'s'. 't'}) equals: 9. 
	self assert: (enc paires occurrencesOf: {'w'. 'e'}) equals: 8. 
	self assert: (enc paires occurrencesOf: {'w'. 'i'}) equals: 3. 
	self assert: (enc paires occurrencesOf: {'t'.'</t>'}) equals: 9. 

	 "#('lo' 't_' 'er' 'r_' 'st' 'wi' 'es' 'ne' 'ow' 'we' 'w_' 'id' 'de' 'ew')"
	self assert: enc paires keys size equals: 14
]

{ #category : 'tests' }
TestBPELearner >> testMergeOneStepAddMergeToMergeList [

	| enc |
	enc := BPELearner new. 
	enc fromText: self text.
	enc computeVocabulary.
	
	self assert: enc merges isEmpty.
	enc mergesOneStep .
	self assert: enc merges first equals: #('t' '</t>')->'t</t>'
]

{ #category : 'tests' }
TestBPELearner >> testMergeOneStepIncreaseVocabularyAndMerges [

	| enc mergeOldSize |
	enc := BPELearner new. 
	enc fromText: self text.
	
	self assert: enc vocabulary size equals: 12.
	mergeOldSize := enc merges size.
	enc mergesOneStep .
	self assert: (enc vocabulary includes: 't</t>').
	self assert: enc merges size equals: mergeOldSize + 1.
	self assert: enc vocabulary size equals: 13
]

{ #category : 'tests' }
TestBPELearner >> testMergeOneStepRecomputePairs [

	| enc|
	enc := BPELearner new. 
	enc fromText: self text.
	
	enc mergesOneStep .
	
	self assert: (enc paires occurrencesOf: {'o' . 'l'}) equals: 10. 
	self assert: (enc paires occurrencesOf: {'l' . 'd'}) equals: 10. 
	self assert: (enc paires occurrencesOf: {'l' .'d'}) equals: 10. 
	self assert: (enc paires occurrencesOf: {'s' . 't</t>'}) equals: 13. 
	self assert: (enc paires occurrencesOf: {'l' .'o'}) equals: 4. 
	self assert: (enc paires occurrencesOf: {'e' . 's'}) equals: 13. 
	self assert: (enc paires occurrencesOf: {'w' . 'e'}) equals: 4. 
	self assert: (enc paires occurrencesOf: {'n' . 'e'}) equals: 9. 
]

{ #category : 'tests' }
TestBPELearner >> testTwoMerges [

	| enc |
	enc := BPELearner new. 
	enc fromText: self text.
	enc computeVocabulary.
	enc mergesOneStep .
	enc mergesOneStep .
	
	self assert: enc merges first equals: #('t' '</t>')->'t</t>'. 
	self assert: enc merges second equals: #('e' 's')->'es'. 
]

{ #category : 'accessing' }
TestBPELearner >> text [
	^ 'old old old old old old old 
older older older
finest finest finest finest finest finest finest finest finest 
lowest lowest lowest lowest 
'
]

{ #category : 'accessing structure variables' }
TestBPELearner >> text2 [
	^ '
low low low low low
lower lower
newest newest newest newest newest newest 
widest widest widest'
]
