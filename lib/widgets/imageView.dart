import 'package:btsverse/utils/color.dart';
import 'package:btsverse/widgets/view_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ImageView extends StatefulWidget {
  final String uid;
  const ImageView({Key? key, required this.uid}) : super(key: key);

  @override
  State<ImageView> createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('posts')
          .where('userId', isEqualTo: widget.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(
            color: purple,
          );
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (!snapshot.hasData || snapshot.data?.docs.isEmpty == true) {
          return const Padding(
            padding: EdgeInsets.all(80),
            child: Text(
              "",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Sen',
                  fontWeight: FontWeight.bold),
            ),
          );
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2.0),
          child: MasonryGridView.builder(
            itemCount: snapshot.data!.docs.length,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.all(2.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ViewImage(
                          snap: snapshot.data!.docs[index],
                        ),
                      ),
                    );
                  },
                  child: Image.network(
                    snapshot.data!.docs[index]['imageUrl'],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
