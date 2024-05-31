import 'package:equatable/equatable.dart';

class Favorite extends Equatable {
  final String id;
  final String userId;
  final String poemId;

  Favorite({
    required this.id,
    required this.userId,
    required this.poemId,
  });

  @override
  List<Object> get props => [id, userId, poemId];

  factory Favorite.fromJson(Map<String, dynamic> json) {
    return Favorite(
      id: json['_id'],
      userId: json['userId'],
      poemId: json['poemId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'poemId': poemId,
    };
  }

  @override
  String toString() => 'Favorite { poemId: $poemId, userId: $userId }';
}
