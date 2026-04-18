import 'package:flutter/material.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  double rating = 0;
  final TextEditingController feedbackController = TextEditingController();

  Widget buildStar(int index) {
    return IconButton(
      icon: Icon(
        index < rating ? Icons.star : Icons.star_border,
        color: Colors.amber,
      ),
      onPressed: () {
        setState(() {
          rating = index + 1;
        });
      },
    );
  }

  void submitFeedback() {
    if (rating == 0 || feedbackController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Give rating & feedback")),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Feedback Submitted ✅")),
    );

    feedbackController.clear();
    setState(() {
      rating = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Feedback"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            const Text("Rate Us", style: TextStyle(fontSize: 18)),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) => buildStar(index)),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: feedbackController,
              maxLines: 4,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Enter your feedback",
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: submitFeedback,
              child: const Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }
}