import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:thuta_learn/core/core.dart';
import 'package:thuta_learn/features/learn/learn.dart';

class VocabularyFlashCardPage extends StatelessWidget {
  const VocabularyFlashCardPage({super.key});

  static const List<VocabularyFlashCardItem> _cards = [
    VocabularyFlashCardItem(
      thaiWord: 'อร่อย',
      pronunciation: 'a-roy',
      partOfSpeech: 'adjective',
      definition: 'Delicious, tasty, and full of flavor.',
      thaiExample:
      'ความสุขคือการได้กินอาหารที่อร่อยในทุกๆ วัน',
      pronunciationExample:
      'Khwam-sook khue karn dai gin aa-harn '
          'thee a-roy nai thuk thuk wan',
      englishExample:
      'Happiness is being able to eat delicious food '
          'every single day.',
    ),
    VocabularyFlashCardItem(
      thaiWord: 'สวัสดี',
      pronunciation: 'sa-wat-dee',
      partOfSpeech: 'greeting',
      definition: 'A common and polite Thai greeting.',
      thaiExample: 'สวัสดีครับ ยินดีที่ได้รู้จัก',
      pronunciationExample:
      'Sa-wat-dee khrap, yin-dee tee dai roo-jak',
      englishExample: 'Hello, nice to meet you.',
    ),
    VocabularyFlashCardItem(
      thaiWord: 'ขอบคุณ',
      pronunciation: 'khop-khun',
      partOfSpeech: 'expression',
      definition: 'Used to express thanks or gratitude.',
      thaiExample: 'ขอบคุณสำหรับความช่วยเหลือ',
      pronunciationExample:
      'Khop-khun sam-rap khwam chuay-luea',
      englishExample: 'Thank you for your help.',
    ),
    VocabularyFlashCardItem(
      thaiWord: 'น้ำ',
      pronunciation: 'nam',
      partOfSpeech: 'noun',
      definition: 'Water or a drink.',
      thaiExample: 'ขอน้ำหนึ่งแก้วครับ',
      pronunciationExample:
      'Khor nam nueng kaeo khrap',
      englishExample: 'May I have one glass of water?',
    ),
    VocabularyFlashCardItem(
      thaiWord: 'อาหาร',
      pronunciation: 'aa-harn',
      partOfSpeech: 'noun',
      definition: 'Food or a prepared meal.',
      thaiExample: 'อาหารไทยอร่อยมาก',
      pronunciationExample:
      'Aa-harn Thai a-roy mak',
      englishExample: 'Thai food is very delicious.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => VocabularyFlashCardBloc(
        cards: _cards,
      ),
      child: const VocabularyFlashCardBody(),
    );
  }
}

class VocabularyFlashCardBody extends StatelessWidget {
  const VocabularyFlashCardBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorUtils.primaryColor,
      body: SafeArea(
        child: BlocBuilder<
            VocabularyFlashCardBloc,
            VocabularyFlashCardState>(
          builder: (context, state) {
            if (state.status ==
                VocabularyFlashCardStatus.completed) {
              return VocabularyFlashCardCompletedView(
                cardCount: state.cards.length,
              );
            }

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    8,
                    8,
                    16,
                    0,
                  ),
                  child: FlashCardProgressHeader(
                    currentCard: state.currentIndex + 1,
                    totalCards: state.cards.length,
                    progress: state.progress,
                    onClose: context.pop,
                  ),
                ),
                24.gh,
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                    ),
                    child: VocabularyFlashCardDeck(
                      item: state.currentCard,
                      isFavorite:
                      state.currentCardIsFavorite,
                      onFavorite: () {
                        context
                            .read<VocabularyFlashCardBloc>()
                            .add(
                          VocabularyFlashCardFavoritePressed(),
                        );
                      },
                      onAudio: () {
                        // Play pronunciation audio later.
                      },
                      onNext: () {
                        context
                            .read<VocabularyFlashCardBloc>()
                            .add(
                          VocabularyFlashCardNextPressed(),
                        );
                      },
                      onPrevious: () {
                        context
                            .read<VocabularyFlashCardBloc>()
                            .add(
                          VocabularyFlashCardPreviousPressed(),
                        );
                      },
                    ),
                  ),
                ),
                16.gh,
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    16,
                    0,
                    16,
                    20,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: state.currentIndex == 0
                            ? null
                            : () {
                          context
                              .read<
                              VocabularyFlashCardBloc
                          >()
                              .add(
                            VocabularyFlashCardPreviousPressed(),
                          );
                        },
                        icon: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: state.currentIndex == 0
                              ? Colors.white38
                              : Colors.white,
                        ),
                      ),
                      const Expanded(
                        child: TtText(
                          'Tap to flip the card. When finished '
                              'remembering, swipe the card to the right.',
                          fontSize: 14,
                          height: 1.35,
                          textAlign: TextAlign.center,
                          color: Colors.white70,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          context
                              .read<VocabularyFlashCardBloc>()
                              .add(
                            VocabularyFlashCardNextPressed(),
                          );
                        },
                        icon: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class VocabularyFlashCardCompletedView
    extends StatelessWidget {
  final int cardCount;

  const VocabularyFlashCardCompletedView({
    super.key,
    required this.cardCount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: const BoxDecoration(
              color: ColorUtils.secondaryBackgroundColor,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.style_rounded,
              size: 52,
              color: ColorUtils.secondaryColor,
            ),
          ),
          24.gh,
          const TtText(
            'Flash Cards Completed!',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          12.gh,
          TtText(
            'You reviewed $cardCount vocabulary cards.',
            fontSize: 14,
            color: Colors.white70,
            textAlign: TextAlign.center,
          ),
          32.gh,
          SizedBox(
            width: double.infinity,
            child: TtButton(
              backgroundColor: Colors.white,
              onTap: context.pop,
              child: const TtText(
                'Finish',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: ColorUtils.primaryColor,
              ),
            ),
          ),
          12.gh,
          TextButton(
            onPressed: () {
              context.read<VocabularyFlashCardBloc>().add(
                VocabularyFlashCardRestartPressed(),
              );
            },
            child: const TtText(
              'Review Again',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}