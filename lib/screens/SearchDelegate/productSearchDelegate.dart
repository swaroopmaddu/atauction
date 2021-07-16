import 'package:atauction/models/Product.dart';
import 'package:atauction/screens/SearchDelegate/search_service.dart';
import 'package:atauction/screens/productDetails/details_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductSearchDelegate extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = "";
          },
          icon: Icon(Icons.clear))
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: AnimatedIcon(
          progress: transitionAnimation,
          icon: AnimatedIcons.menu_arrow,
        ));
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    Stream<QuerySnapshot> _usersStream =
        SearchService.searchByName(query.toLowerCase());
    return StreamBuilder<QuerySnapshot>(
      stream: _usersStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Something went wrong'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 10),
                Text("Loading please wait")
              ],
            ),
          );
        }
        return ListView(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data = document.data() as Map<String, dynamic>;
            return data['name']
                    .toString()
                    .toUpperCase()
                    .startsWith(query.toUpperCase())
                ? ListTile(
                    leading: Hero(
                      tag: "${data['image']}",
                      child: SizedBox(
                        height: 50,
                        width: 50,
                        child: CachedNetworkImage(
                          imageUrl: data['image'],
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            )),
                          ),
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) => Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: CircularProgressIndicator(
                                value: downloadProgress.progress),
                          ),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                      ),
                    ),
                    title: Text(data['name']),
                    subtitle: Text(data['type']),
                    onTap: () {
                      Product product = Product.fromMap(data);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  DetailsScreen(product: product)));
                    },
                  )
                : Container();
          }).toList(),
        );
      },
    );
  }
}
