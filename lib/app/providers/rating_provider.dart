import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project/app/models/rating_model.dart';

class RatingProvider with ChangeNotifier {
  List<RatingModel> _ratingData = [];

  Future<void> setRatingData(userId) async {
    final data = await FirebaseFirestore.instance
        .collection("rating")
        .where("userId", isEqualTo: userId)
        .get();

    _ratingData = <RatingModel>[
      for (QueryDocumentSnapshot<Object?> item in data.docs)
        RatingModel.fromJson(item.data() as Map<String, dynamic>)
    ];
  }

  List<RatingModel> get getRatingData => _ratingData;

  Future<void> addRating({
    BuildContext? context,
    required String productId,
    required String userId,
    required double rating,
  }) async {
    QuerySnapshot<Object?> ratingSnap = await FirebaseFirestore.instance
        .collection("rating")
        .where("userId", isEqualTo: userId)
        .where("productId", isEqualTo: productId)
        .get();

    final newRating = FirebaseFirestore.instance.collection("rating").doc();
    if (ratingSnap.docs.isEmpty) {
      await newRating.set(
        RatingModel(
          id: newRating.id,
          productId: productId,
          userId: userId,
          rating: rating,
        ).toJson(),
      );

      ScaffoldMessenger.of(context!).showSnackBar(
        const SnackBar(content: Text('Rating added successfully')),
      );

      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pop(context);
    }
  }

  Future<void> updateRating(
    BuildContext context,
    String ratingId,
    double ratingValue,
  ) async {
    await FirebaseFirestore.instance.collection("rating").doc(ratingId).update(
      {'rating': ratingValue},
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Rating updated successfully')),
    );

    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.pop(context);
  }
}
