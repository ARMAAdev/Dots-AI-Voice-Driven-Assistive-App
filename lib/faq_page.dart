import 'package:flutter/material.dart';
import 'package:dots/generated/l10n.dart';

class FAQPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.help_rounded),
            SizedBox(width: 10),
            Text(S.of(context).FAQ,
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                fontFamily: 'SF-Pro',
                letterSpacing: 0.4,
              ),
            ),
          ],
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(20.0),
        children: [
          _buildFAQItem(
            question: S.of(context).question1,
            answer: S.of(context).answer1,
          ),
          _buildFAQItem(
            question: S.of(context).question2,
            answer: S.of(context).answer2,
          ),
          _buildFAQItem(
            question: S.of(context).question3,
            answer: S.of(context).answer3,
          ),
          _buildFAQItem(
            question: S.of(context).question4,
            answer: S.of(context).answer4,
          ),
          _buildFAQItem(
            question: S.of(context).question5,
            answer: S.of(context).answer5,
          ),
          _buildFAQItem(
            question: S.of(context).question6,
            answer: S.of(context).answer6,
          ),
          _buildFAQItem(
            question: S.of(context).question7,
            answer: S.of(context).answer7,
          ),
          _buildFAQItem(
            question: S.of(context).question8,
            answer: S.of(context).answer8,
          ),
          _buildFAQItem(
            question: S.of(context).question9,
            answer: S.of(context).answer9,
          ),
          _buildFAQItem(
            question: S.of(context).question10,
            answer: S.of(context).answer10,
          ),
        ],
      ),
    );
  }

  Widget _buildFAQItem({required String question, required String answer}) {
    return ExpansionTile(
      title: Text(
        question,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          fontFamily: 'SF-Pro',
          letterSpacing: 0.4,
        ),
      ),
      children: [
        Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(answer,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
              fontFamily: 'SF-Pro',
              letterSpacing: 0.4,
            ),
          ),
        ),
      ],
    );
  }
}
