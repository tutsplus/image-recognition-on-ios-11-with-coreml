//: Playground - noun: a place where people can play

import UIKit

let english = """
Natural language processing (NLP) is a field of computer science, artificial intelligence and computational linguistics concerned with the interactions between computers and human (natural) languages, and, in particular, concerned with programming computers to fruitfully process large natural language corpora. Challenges in natural language processing frequently involve natural language understanding, natural language generation (frequently from formal, machine-readable logical forms), connecting language and machine perception, dialog systems, or some combination thereof.
"""

let french = """
Le traitement automatique du langage naturel ou de la langue naturelle (abr. TALN) ou des langues (abr. TAL) est une discipline à la frontière de la linguistique, de l'informatique et de l'intelligence artificielle, qui concerne l'application de programmes et techniques informatiques à tous les aspects du langage humain.
"""

let japanese = """
自然言語処理（しぜんげんごしょり、英語: natural language processing、略称：NLP）は、人間が日常的に使っている自然言語をコンピュータに処理させる一連の技術であり、人工知能と言語学の一分野である。「計算言語学」（computational linguistics）との類似もあるが、自然言語処理は工学的な視点からの言語処理をさすのに対して、計算言語学は言語学的視点を重視する手法をさす事が多い[1]。データベース内の情報を自然言語に変換したり、自然言語の文章をより形式的な（コンピュータが理解しやすい）表現に変換するといった処理が含まれる。応用例としては予測変換、IMEなどの文字変換が挙げられる。
"""

let chinese = """
自然語言處理（英语：natural language processing，缩写作 NLP）是人工智慧和語言學領域的分支學科。此領域探討如何處理及運用自然語言；自然語言認知則是指讓電腦「懂」人類的語言。
自然語言生成系統把計算機數據轉化為自然語言。自然語言理解系統把自然語言轉化為計算機程序更易于處理的形式。
"""

let tagger = NSLinguisticTagger(tagSchemes: [.nameTypeOrLexicalClass, .lemma], options: 0)
tagger.string = [english, french].joined(separator: " ")

let range = NSRange(location: 0, length: tagger.string!.utf16.count)
let options : NSLinguisticTagger.Options = [.omitPunctuation, .omitWhitespace]
tagger.enumerateTags(in: range, unit: .word, scheme: .lemma, options: options) { (result, tokenRange, _) in
//    guard result == .noun else { return }
    let word = (tagger.string! as NSString).substring(with: tokenRange).lowercased()
    guard let lemma = result, lemma.rawValue != word else { return }
    print("\(word) -> \(lemma.rawValue)")
//    print("\(result?.rawValue ?? "Unknown"): \(word)")
}

tagger.dominantLanguage
NSLinguisticTagger.dominantLanguage(for: english)
NSLinguisticTagger.dominantLanguage(for: french)
NSLinguisticTagger.dominantLanguage(for: japanese)











