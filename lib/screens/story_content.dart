import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Story {
  final String title;
  final String content;
  final List<Question> quiz;

  Story({required this.title, required this.content, required this.quiz});
}

class Question {
  final String question;
  final List<String> options;
  final int correctIndex;

  Question({required this.question, required this.options, required this.correctIndex});
}

// List of historical stories
final List<Story> stories = [
  Story(
    title: 'The Lost Kingdom of Namayan',
    content:
    'Before Rajah Sulayman and before even the Spanish ships sailed into Manila Bay,\n\n'
        'there was Namayan — a powerful and flourishing pre-Hispanic kingdom that ruled over what we now know as Manila, Mandaluyong, Pasay, Makati, and even parts of Laguna.\n\n'
        'Sometime between the 11th and 14th centuries, Namayan (also called Sapa or Maysapan) thrived along the Pasig River. It was one of the earliest known Filipino polities to exhibit organized governance, trade diplomacy, and religious complexity.\n\n'
        'Namayan was ruled by noble figures like Lakan Tagkan and his wife Queen Buan. Their kingdom\'s economy relied heavily on trade with neighboring Asian powers, including China, Champa (Vietnam), and Borneo. These interactions brought luxury goods, spiritual beliefs, and cultural exchanges, which helped shape Namayan\'s uniquely Filipino identity blended with Hindu-Buddhist influences.\n\n'
        'When the Spaniards arrived in the 16th century, Namayan had already merged politically with other nearby kingdoms like Tondo and Maynila, forming a larger confederacy to resist foreign influence. But Spanish chroniclers, more focused on conquest and Christianization, left Namayan\'s stories in the shadows.\n\n'
        'Today, archaeological digs in Sta. Ana, Manila (where Namayan\'s capital is believed to have stood), have unearthed gold ornaments, ceramics, and burial jars, proving that it was a highly advanced community long before colonization.\n\n'
        'Namayan proves that pre-colonial Filipino civilizations were not primitive. They had kings and queens, diplomacy, religion, and global trade networks. This story challenges the outdated narrative that Philippine history started only with Magellan in 1521.\n\n'
        'Namayan\'s legacy reminds us that our heritage goes deeper than colonization — it is ancient, proud, and worth reclaiming.',
    quiz: [
      Question(
        question: 'Where was Namayan located?',
        options: ['Manila', 'Cebu', 'Davao', 'Baguio'],
        correctIndex: 0,
      ),
    ],
  ),
  
  Story(
    title: 'Bud Dajo Massacre (1906) – Also known as the Moro Crater Massacre',
    content:
    'Background:\n\n\n'
        'At the turn of the 20th century, the Philippines came under American control following the Spanish-American War and the Treaty of Paris in 1898. While much of the country was gradually pacified under U.S. colonial rule, the southern region of Mindanao—particularly the Muslim population known as the Moro—resisted colonization\n\n.'
        'The Moro people had a long history of autonomy and viewed American authority as a foreign imposition on their way of life, culture, and religion.\n\n'
        'The Conflict at Bud Dajo:\n\n\n'
        'Mount Bud Dajo is an extinct volcanic crater on the island of Jolo, in the Sulu Archipelago. In 1906, over 1,000 Moro villagers, including men, women, and children, fled to the top of Bud Dajo to escape what they saw as unjust colonial policies—such as disarmament, forced taxation, and restrictions on traditional practices.\n\n'
        'American officials, led by Major General Leonard Wood, saw the encampment as an act of rebellion and decided to forcibly disband it. Despite claims that those on Bud Dajo were not hostile and were mostly civilians seeking refuge, the U.S. military launched a full-scale assault.\n\n'
        'The Assault:\n\n\n'
        'From March 5 to March 8, 1906, around 750 American troops, including Philippine Scouts and Constabulary units, ascended the steep slopes of Bud Dajo. The defenders, estimated at 800–1,000 individuals, possessed only rudimentary weapons—mostly kris swords, spears, and a few firearms.\n\n'
        'The battle was intense and bloody. U.S. forces used modern artillery and machine guns against the outgunned Moros. After three days of combat, almost all the Moros were killed. According to U.S. reports, only 6 survivors were found, while approximately 600 to 1,000 Moros were killed—including over 200 women and children.\n\n'
        'Aftermath and Global Reaction:'
        'The massacre shocked many both in the United States and abroad. Graphic photos showed piles of Moro bodies, many of them women and children. Critics, including Mark Twain, condemned the act as brutal and imperialistic. Twain sarcastically referred to it as a "brilliant feat of arms."\n\n'
        'President Theodore Roosevelt, though initially defensive of General Wood, eventually faced pressure to investigate the incident. Despite this, no one was held accountable, and the event was officially justified as necessary to maintain order.\n\n'
        'Legacy:\n\n\n'
        'The Bud Dajo Massacre remains a dark chapter in U.S.-Philippine history. It symbolizes the violence of colonial conquest and the struggles of the Moro people to retain their autonomy. In the Philippines, especially among the Bangsamoro people, it is remembered as an act of massive injustice and martyrdom.\n\n'
        'In modern years, the massacre has been revisited by scholars, human rights advocates, and descendants of the victims as part of the broader movement to acknowledge the effects of colonial violence in the country\'s history.\n\n',
    quiz: [
      Question(
        question: 'Where is Mount Bud Dajo located?',
        options: ['Mindoro', 'Jolo Island', 'Tawi-Tawi', 'Luzon'],
        correctIndex: 1,
      ),
      Question(
        question: 'Who led the U.S. forces during the Bud Dajo assault?',
        options: ['Leonard Wood', 'Douglas MacArthur', 'John Pershing', 'Theodore Roosevelt'],
        correctIndex: 0,
      ),
      Question(
        question: 'How many American troops participated in the assault?',
        options: ['100', '250', '750', '1,000'],
        correctIndex: 2,
      ),
      Question(
        question: 'What were the Moros primarily armed with?',
        options: ['Tanks', 'Artillery', 'Kris swords and spears', 'Modern rifles'],
        correctIndex: 2,
      ),
      Question(
        question: 'Who was a famous critic of the massacre?',
        options: ['Jose Rizal', 'Mark Twain', 'Andres Bonifacio', 'William Howard Taft'],
        correctIndex: 1,
      ),
    ],
  ),
];
