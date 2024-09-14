import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dorm_app/screen/detail.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // To get the current user

class DormScreen extends StatefulWidget {
  const DormScreen({super.key});

  @override
  State<DormScreen> createState() => _DormScreenState();
}

class _DormScreenState extends State<DormScreen> {
  bool isPriceAscending = true;
  bool isRatingAscending = true;
  String sortBy = 'price'; // Default sort by price
  String searchQuery = '';
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search bar
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: searchController,
                  decoration: const InputDecoration(
                    hintText: 'ค้นหาหอพัก',
                    border: InputBorder.none,
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.purple,
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value; // Update search query
                    });
                  },
                ),
              ),
              const SizedBox(height: 16),
              // Filter buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  FilterButton(
                    text: 'ราคา/เดือน',
                    onPressed: () {
                      setState(() {
                        sortBy = 'price';
                        isPriceAscending = !isPriceAscending;
                      });
                    },
                    isSelected: sortBy == 'price',
                  ),
                  FilterButton(
                    text: 'ให้คะแนน',
                    onPressed: () {
                      setState(() {
                        sortBy = 'rating';
                        isRatingAscending = !isRatingAscending;
                      });
                    },
                    isSelected: sortBy == 'rating',
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // StreamBuilder to fetch dormitory data
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('dormitories')
                    .orderBy(sortBy,
                        descending: sortBy == 'price'
                            ? !isPriceAscending
                            : !isRatingAscending)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final dorms = snapshot.data!.docs;

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: dorms.length,
                    itemBuilder: (context, index) {
                      var dorm = dorms[index];
                      String dormId =
                          dorm.id; // Retrieve dormId from document ID

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 241, 229, 255),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Dorm image
                              Container(
                                height: 180,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(10)),
                                  image: DecorationImage(
                                    image: NetworkImage(dorm['imageUrl']),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      dorm['name'],
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'ราคา ${dorm['price']} บาท',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'คะแนน ${dorm['rating']}/5',
                                      style: const TextStyle(color: Colors.red),
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        // View details button
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    DormallDetailScreen(
                                                        dormId: dormId),
                                              ),
                                            );
                                          },
                                          child: const Text('ดูรายละเอียด'),
                                        ),
                                        // Favorite heart icon
                                        IconButton(
                                          icon:
                                              const Icon(Icons.favorite_border),
                                          color: Colors.pink,
                                          onPressed: () {
                                            _toggleFavorite(dormId);
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to add/remove favorite dormitories
  Future<void> _toggleFavorite(String dormId) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return; // If user is not signed in, do nothing

    final userFavoritesRef =
        FirebaseFirestore.instance.collection('users').doc(user.uid);

    // Retrieve the user's document
    DocumentSnapshot userDoc = await userFavoritesRef.get();

    // Check if the document exists
    if (userDoc.exists) {
      // Explicitly cast the data to Map<String, dynamic>
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

      // Retrieve favorites list or initialize it as an empty list
      List<dynamic> favorites = userData['favorites'] ?? [];

      if (favorites.contains(dormId)) {
        // If dormId is already in favorites, remove it
        favorites.remove(dormId);
      } else {
        // Otherwise, add the dormId to favorites
        favorites.add(dormId);
      }

      // Update the user's favorite list in Firestore
      await userFavoritesRef.update({'favorites': favorites});
    } else {
      // Document does not exist, create a new one with the dormId in favorites
      await userFavoritesRef.set({
        'favorites': [dormId],
      });
    }
  }
}

class FilterButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isSelected;

  const FilterButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: isSelected ? Colors.white : Colors.purple,
        backgroundColor: isSelected ? Colors.purple : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        side: BorderSide(color: isSelected ? Colors.purple : Colors.pink),
      ),
      child: Text(text),
    );
  }
}
