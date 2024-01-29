import 'package:brain_box/feature/education/data/models/book_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

class BookItem extends StatelessWidget {
  final BookModel model;
  final Function(Essential book) onClick;
  const BookItem({super.key,required this.model,required this.onClick});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=> onClick(model.essential),
      child: Column(
        children: [
          Flexible(
            child: Container(
              width: 130,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
              child: CachedNetworkImage(
                  imageUrl: model.image,
                placeholder: (context, url) => Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: Colors.white, // You can set any color as a fallback background
                  ),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
          ),
          Text(model.name,style: GoogleFonts.roboto(fontSize: 20,fontWeight: FontWeight.w700),)
        ],
      ),
    );
  }
}
