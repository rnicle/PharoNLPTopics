Class {
	#name : 'WordPieceTrainTest',
	#superclass : 'TestCase',
	#category : 'WordPiece',
	#package : 'WordPiece'
}

{ #category : 'tests' }
WordPieceTrainTest >> testComputeLettersFrequency [ 
	|wordpiece lettersFrequency|
	wordpiece := WordPieceTrain new.
	wordpiece prepareWordsFromText: self text2 .
	wordpiece computelettersFrequency .
	lettersFrequency := Bag new.
	lettersFrequency add: 'l' withOccurrences: 7.
	lettersFrequency add: '#o' withOccurrences: 7.
	lettersFrequency add: '#w' withOccurrences: 13.
	lettersFrequency add: '#e' withOccurrences: 17.
	lettersFrequency add: '#r' withOccurrences: 2.
	lettersFrequency add: 'n' withOccurrences: 6.
	lettersFrequency add: '#s' withOccurrences: 9.
	lettersFrequency add: '#t' withOccurrences: 9.
	lettersFrequency add: 'w' withOccurrences: 3. 
	lettersFrequency add: '#d' withOccurrences: 3.
	lettersFrequency add: '#i' withOccurrences: 3.
	self assert: wordpiece lettersFrequency equals: lettersFrequency .
	
]

{ #category : 'tests' }
WordPieceTrainTest >> testComputePairesFrequency [ 
	|wordpiece pairesFrequency|
	wordpiece := WordPieceTrain new.
	wordpiece prepareWordsFromText: self text2 .
	wordpiece computePairesFrequency.
	pairesFrequency := Bag new .
	pairesFrequency add: { 'l' . '#o' } withOccurrences: 7. 
	pairesFrequency add: { '#o' . '#w' } withOccurrences: 7. 
	pairesFrequency add: { '#w' . '#e' } withOccurrences: 8.
	pairesFrequency add: { '#e' . '#r' } withOccurrences: 2.
	pairesFrequency add: { 'n' . '#e' } withOccurrences: 6.
	pairesFrequency add: { '#e' . '#w' } withOccurrences: 6.
	pairesFrequency add: { '#e' . '#s' } withOccurrences: 9.
	pairesFrequency add: { '#s' . '#t' } withOccurrences: 9.
	pairesFrequency add: { 'w' . '#i' } withOccurrences: 3.
	pairesFrequency add: { '#i' . '#d' } withOccurrences: 3.
	pairesFrequency add: { '#d' . '#e' } withOccurrences: 3.
	self assert: wordpiece pairesFrequency equals: pairesFrequency .
]

{ #category : 'tests' }
WordPieceTrainTest >> testComputePairesScores [ 
	|wordpiece scores|
	wordpiece := WordPieceTrain  new.
	wordpiece prepareWordsFromText: self text2 .
	wordpiece computelettersFrequency .
	wordpiece computePairesFrequency .
	wordpiece computePairesScores .
	scores := Dictionary new .
	scores at: { 'l' . '#o' } put: 7/(7*7) asFloat .
	scores at: { '#o' . '#w' } put: 7/(7*13) asFloat.
	scores at: { '#w' . '#e' } put: 8/(13*17) asFloat.
	scores at: { '#e' . '#r' } put: 2/(17*2) asFloat .
	scores at: { 'n' . '#e' } put: 6/(6*17) asFloat .
	scores at: { '#e' . '#w' } put: 6/(17*13) asFloat .
	scores at: { '#e' . '#s' } put: 9/(17*9) asFloat .
	scores at: { '#s' . '#t' } put: 9/(9*9) asFloat .
	scores at: { 'w' . '#i' } put: 3/(3*3) asFloat .
	scores at: { '#i' . '#d' } put: 3/(3*3) asFloat .
	scores at: { '#d' . '#e' } put: 3/(3*17) asFloat .
	self assert: wordpiece pairesScores equals: scores. 
]

{ #category : 'tests' }
WordPieceTrainTest >> testMergesOneStep [
	|wordpiece token lettersFrequency pairesFrequency scores|
	wordpiece := WordPieceTrain new.
	wordpiece prepareWordsFromText: self text2.
	wordpiece computeVocabulary .
	wordpiece computelettersFrequency .
	wordpiece computePairesFrequency .
	wordpiece computePairesScores .
	wordpiece mergesOneStep .
	token := Bag new.
	token add: #('l' '#o' '#w') asOrderedCollection withOccurrences: 5.
	token add: #('l' '#o' '#w' '#e' '#r') asOrderedCollection withOccurrences: 2.
	token add: #('n' '#e' '#w' '#e' '#s' '#t') asOrderedCollection withOccurrences: 6.
	token add: #('w' '#id' '#e' '#s' '#t') asOrderedCollection withOccurrences: 3.
	self assert: wordpiece vocabulary equals: #('l' '#o' '#w' '#e' '#r' 'w' '#i' '#d' '#s' '#t' 'n' '#id') asSet .
	self assert: wordpiece tokens equals: token .
	lettersFrequency := Bag new.
	lettersFrequency add: 'l' withOccurrences: 7.
	lettersFrequency add: '#o' withOccurrences: 7.
	lettersFrequency add: '#w' withOccurrences: 13.
	lettersFrequency add: '#e' withOccurrences: 17.
	lettersFrequency add: '#r' withOccurrences: 2.
	lettersFrequency add: 'n' withOccurrences: 6.
	lettersFrequency add: '#s' withOccurrences: 9.
	lettersFrequency add: '#t' withOccurrences: 9.
	lettersFrequency add: 'w' withOccurrences: 3. 
	lettersFrequency add: '#id' withOccurrences: 3.
	self assert: wordpiece lettersFrequency equals: lettersFrequency .
	pairesFrequency := Bag new .
	pairesFrequency add: { 'l' . '#o' } withOccurrences: 7. 
	pairesFrequency add: { '#o' . '#w' } withOccurrences: 7. 
	pairesFrequency add: { '#w' . '#e' } withOccurrences: 8.
	pairesFrequency add: { '#e' . '#r' } withOccurrences: 2.
	pairesFrequency add: { 'n' . '#e' } withOccurrences: 6.
	pairesFrequency add: { '#e' . '#w' } withOccurrences: 6.
	pairesFrequency add: { '#e' . '#s' } withOccurrences: 9.
	pairesFrequency add: { '#s' . '#t' } withOccurrences: 9.
	pairesFrequency add: { 'w' . '#id' } withOccurrences: 3.
	pairesFrequency add: { '#id' . '#e' } withOccurrences: 3.
	self assert: wordpiece pairesFrequency equals: pairesFrequency .
	scores := Dictionary new .
	scores at: { 'l' . '#o' } put: 7/(7*7) asFloat .
	scores at: { '#o' . '#w' } put: 7/(7*13) asFloat.
	scores at: { '#w' . '#e' } put: 8/(13*17) asFloat.
	scores at: { '#e' . '#r' } put: 2/(17*2) asFloat .
	scores at: { 'n' . '#e' } put: 6/(6*17) asFloat .
	scores at: { '#e' . '#w' } put: 6/(17*13) asFloat .
	scores at: { '#e' . '#s' } put: 9/(17*9) asFloat .
	scores at: { '#s' . '#t' } put: 9/(9*9) asFloat .
	scores at: { 'w' . '#id' } put: 3/(3*3) asFloat .
	scores at: { '#id' . '#e' } put: 3/(3*17) asFloat .
	self assert: wordpiece pairesScores equals: scores. 
	
	
]

{ #category : 'tests' }
WordPieceTrainTest >> testPrepareWordsFromText [ 
	|wordpiece token|
	wordpiece := WordPieceTrain new.
	token := Bag new.
	wordpiece prepareWordsFromText: self text2 .
	token add: #('l' '#o' '#w') asOrderedCollection withOccurrences: 5.
	token add: #('l' '#o' '#w' '#e' '#r') asOrderedCollection withOccurrences: 2.
	token add: #('n' '#e' '#w' '#e' '#s' '#t') asOrderedCollection withOccurrences: 6.
	token add: #('w' '#i' '#d' '#e' '#s' '#t') asOrderedCollection withOccurrences: 3.
	self assert: wordpiece tokens equals: token .
]

{ #category : 'tests' }
WordPieceTrainTest >> testTwoMergesOneStep [
	|wordpiece token lettersFrequency pairesFrequency scores|
	wordpiece := WordPieceTrain new.
	wordpiece prepareWordsFromText: self text2.
	wordpiece computeVocabulary .
	wordpiece computelettersFrequency .
	wordpiece computePairesFrequency .
	wordpiece computePairesScores .
	wordpiece mergesOneStep .
	wordpiece mergesOneStep .
	token := Bag new.
	token add: #('l' '#o' '#w') asOrderedCollection withOccurrences: 5.
	token add: #('l' '#o' '#w' '#e' '#r') asOrderedCollection withOccurrences: 2.
	token add: #('n' '#e' '#w' '#e' '#s' '#t') asOrderedCollection withOccurrences: 6.
	token add: #('wid' '#e' '#s' '#t') asOrderedCollection withOccurrences: 3.
	self assert: wordpiece vocabulary equals: #('l' '#o' '#w' '#e' '#r' 'w' '#i' '#d' '#s' '#t' 'n' '#id' 'wid') asSet .
	self assert: wordpiece tokens equals: token .
	lettersFrequency := Bag new.
	lettersFrequency add: 'l' withOccurrences: 7.
	lettersFrequency add: '#o' withOccurrences: 7.
	lettersFrequency add: '#w' withOccurrences: 13.
	lettersFrequency add: '#e' withOccurrences: 17.
	lettersFrequency add: '#r' withOccurrences: 2.
	lettersFrequency add: 'n' withOccurrences: 6.
	lettersFrequency add: '#s' withOccurrences: 9.
	lettersFrequency add: '#t' withOccurrences: 9.
	lettersFrequency add: 'wid' withOccurrences: 3. 
	self assert: wordpiece lettersFrequency equals: lettersFrequency .
	pairesFrequency := Bag new .
	pairesFrequency add: { 'l' . '#o' } withOccurrences: 7. 
	pairesFrequency add: { '#o' . '#w' } withOccurrences: 7. 
	pairesFrequency add: { '#w' . '#e' } withOccurrences: 8.
	pairesFrequency add: { '#e' . '#r' } withOccurrences: 2.
	pairesFrequency add: { 'n' . '#e' } withOccurrences: 6.
	pairesFrequency add: { '#e' . '#w' } withOccurrences: 6.
	pairesFrequency add: { '#e' . '#s' } withOccurrences: 9.
	pairesFrequency add: { '#s' . '#t' } withOccurrences: 9.
	pairesFrequency add: { 'wid' . '#e' } withOccurrences: 3.
	self assert: wordpiece pairesFrequency equals: pairesFrequency .
	scores := Dictionary new .
	scores at: { 'l' . '#o' } put: 7/(7*7) asFloat .
	scores at: { '#o' . '#w' } put: 7/(7*13) asFloat.
	scores at: { '#w' . '#e' } put: 8/(13*17) asFloat.
	scores at: { '#e' . '#r' } put: 2/(17*2) asFloat .
	scores at: { 'n' . '#e' } put: 6/(6*17) asFloat .
	scores at: { '#e' . '#w' } put: 6/(17*13) asFloat .
	scores at: { '#e' . '#s' } put: 9/(17*9) asFloat .
	scores at: { '#s' . '#t' } put: 9/(9*9) asFloat .
	scores at: { 'wid' . '#e' } put: 3/(3*17) asFloat .
	self assert: wordpiece pairesScores equals: scores. 
]

{ #category : 'adding' }
WordPieceTrainTest >> testcomputeVocabulary [ 
	|wordpiece|
	wordpiece := WordPieceTrain new.
	wordpiece prepareWordsFromText: self text2 .
	wordpiece testcomputeVocabulary .
	self assert: wordpiece vocabulary equals: #('l' '#o' '#w' '#e' '#r' 'w' '#i' '#d' '#s' '#t' 'n') asSet .
]

{ #category : 'accessing structure variables' }
WordPieceTrainTest >> text2 [
	^ '
low low low low low
lower lower
newest newest newest newest newest newest 
widest widest widest'
]
