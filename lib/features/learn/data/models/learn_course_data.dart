import 'package:thuta_learn/features/learn/learn.dart';

class LearnCourseData {
  LearnCourseData._();

  static final List<LearnCourseItem> courses = [
    LearnCourseItem(
      id: 'everyday-communication',
      title: 'Thai for Everyday Communication',
      description:
      'Learn practical Thai for everyday conversations and situations.',
      level: 'Beginner',
      icon: 'conversation',
      progress: 0.32,
      modules: everydayCommunicationModules,
    ),
    LearnCourseItem(
      id: 'thai-for-travel',
      title: 'Thai for Travel',
      description:
      'Learn useful Thai expressions for travelling around Thailand.',
      level: 'Beginner',
      icon: 'travel',
      progress: 0.12,
      modules: thaiForTravelModules,
    ),
    LearnCourseItem(
      id: 'work-and-business',
      title: 'Thai for Work and Business',
      description:
      'Build professional Thai communication skills for the workplace.',
      level: 'Intermediate',
      icon: 'work',
      progress: 0,
      modules: workAndBusinessModules,
    ),
    LearnCourseItem(
      id: 'grammar-essentials',
      title: 'Thai Grammar Essentials',
      description:
      'Understand essential Thai sentence patterns and grammar.',
      level: 'Intermediate',
      icon: 'grammar',
      progress: 0,
      modules: grammarModules,
    ),
  ];

  static const List<LearnModuleItem>
  everydayCommunicationModules = [
    LearnModuleItem(
      moduleNumber: 1,
      title: 'Thai Pronunciation Essentials',
      description:
      'Build a strong foundation in Thai pronunciation by learning basic sounds, vowels, tones, and polite sentence endings.',
      status: LearnModuleStatus.completed,
      progress: 1,
      quizPassed: true,
    ),
    LearnModuleItem(
      moduleNumber: 2,
      title: 'Greetings and Self-Introduction',
      description:
      'Learn how to greet people, introduce yourself, and participate in basic social conversations.',
      status: LearnModuleStatus.inProgress,
      progress: 0.60,
    ),
    LearnModuleItem(
      moduleNumber: 3,
      title: 'Numbers, Prices and Shopping',
      description:
      'Learn to understand numbers, ask about prices, purchase items, and communicate during everyday shopping situations.',
      status: LearnModuleStatus.locked,
    ),
    LearnModuleItem(
      moduleNumber: 4,
      title: 'Food and Drinks',
      description:
      'Learn useful Thai expressions for ordering food, drinks, and communicating in restaurants and cafés.',
      status: LearnModuleStatus.locked,
    ),
    LearnModuleItem(
      moduleNumber: 5,
      title: 'Time, Dates and Daily Schedule',
      description:
      'Learn how to tell the time, discuss dates, arrange appointments, and describe your daily routine.',
      status: LearnModuleStatus.locked,
    ),
    LearnModuleItem(
      moduleNumber: 6,
      title: 'Places, Transport and Directions',
      description:
      'Learn to ask for locations, understand basic directions, and communicate while using transport in Thailand.',
      status: LearnModuleStatus.locked,
    ),
    LearnModuleItem(
      moduleNumber: 7,
      title: 'Everyday Conversation and Grammar',
      description:
      'Develop natural conversations using common verbs, question words, connectors, and essential grammar.',
      status: LearnModuleStatus.locked,
    ),
    LearnModuleItem(
      moduleNumber: 8,
      title: 'Weather, Health and Practical Situations',
      description:
      'Learn practical expressions for weather, health concerns, and emergency situations.',
      status: LearnModuleStatus.locked,
    ),
  ];

  static const List<LearnModuleItem> thaiForTravelModules = [
    LearnModuleItem(
      moduleNumber: 1,
      title: 'Arriving in Thailand',
      description:
      'Learn essential expressions for immigration, airports, and arriving in Thailand.',
      status: LearnModuleStatus.inProgress,
      progress: 0.30,
    ),
    LearnModuleItem(
      moduleNumber: 2,
      title: 'Hotels and Accommodation',
      description:
      'Learn how to book a room, check in, and ask for hotel services.',
      status: LearnModuleStatus.locked,
    ),
    LearnModuleItem(
      moduleNumber: 3,
      title: 'Transport and Directions',
      description:
      'Learn how to use taxis, public transport, and ask for directions.',
      status: LearnModuleStatus.locked,
    ),
    LearnModuleItem(
      moduleNumber: 4,
      title: 'Restaurants and Street Food',
      description:
      'Learn useful phrases for ordering food and communicating at restaurants.',
      status: LearnModuleStatus.locked,
    ),
  ];

  static const List<LearnModuleItem>
  workAndBusinessModules = [
    LearnModuleItem(
      moduleNumber: 1,
      title: 'Workplace Introductions',
      description:
      'Learn how to introduce yourself and your role professionally.',
      status: LearnModuleStatus.inProgress,
      progress: 0,
    ),
    LearnModuleItem(
      moduleNumber: 2,
      title: 'Meetings and Appointments',
      description:
      'Learn useful expressions for arranging and participating in meetings.',
      status: LearnModuleStatus.locked,
    ),
    LearnModuleItem(
      moduleNumber: 3,
      title: 'Professional Communication',
      description:
      'Develop clear and polite workplace communication skills.',
      status: LearnModuleStatus.locked,
    ),
    LearnModuleItem(
      moduleNumber: 4,
      title: 'Business Vocabulary',
      description:
      'Learn important vocabulary used in Thai workplaces.',
      status: LearnModuleStatus.locked,
    ),
  ];

  static const List<LearnModuleItem> grammarModules = [
    LearnModuleItem(
      moduleNumber: 1,
      title: 'Basic Sentence Structure',
      description:
      'Understand the basic structure of common Thai sentences.',
      status: LearnModuleStatus.inProgress,
      progress: 0,
    ),
    LearnModuleItem(
      moduleNumber: 2,
      title: 'Questions and Answers',
      description:
      'Learn how to form questions and give natural answers.',
      status: LearnModuleStatus.locked,
    ),
    LearnModuleItem(
      moduleNumber: 3,
      title: 'Verbs and Time Expressions',
      description:
      'Use verbs with past, present, and future time expressions.',
      status: LearnModuleStatus.locked,
    ),
    LearnModuleItem(
      moduleNumber: 4,
      title: 'Connectors and Complex Sentences',
      description:
      'Connect ideas and build more advanced Thai sentences.',
      status: LearnModuleStatus.locked,
    ),
  ];
}