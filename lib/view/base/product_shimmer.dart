import 'package:Apka_kitchen/helper/responsive_helper.dart';
import 'package:Apka_kitchen/util/dimensions.dart';
import 'package:Apka_kitchen/view/base/rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductShimmer extends StatelessWidget {
  final bool isEnabled;
  final bool isRestaurant;
  final bool hasDivider;
  ProductShimmer({@required this.isEnabled, @required this.hasDivider, this.isRestaurant = false});

  @override
  Widget build(BuildContext context) {
    bool _desktop = ResponsiveHelper.isDesktop(context);

    return Container(
      padding: ResponsiveHelper.isDesktop(context) ? EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL) : null,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
        color: ResponsiveHelper.isDesktop(context) ? Theme.of(context).cardColor : null,
        boxShadow: ResponsiveHelper.isDesktop(context) ? [BoxShadow(
          color: Colors.grey[Get.isDarkMode ? 700 : 300], spreadRadius: 1, blurRadius: 5,
        )] : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 4,vertical: 2),
            padding: EdgeInsets.symmetric(horizontal: 16),
            // height: 202,
            // width: 163,
            decoration:
            BoxDecoration(
              color: Colors.white,
              borderRadius:
              BorderRadius
                  .circular(
                  10),
              boxShadow: [
                BoxShadow(
                  color: Colors
                      .black
                      .withOpacity(
                      0.24),
                  spreadRadius: 0,
                  blurRadius: 23,
                  offset: Offset(
                      0, 1),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment
                  .start,
              children: [
                SizedBox(
                  height: 8,
                ),
                Stack(
                  clipBehavior: Clip.none,
                  children: [

                    Container(
                      height: 120,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // Icon(Icons.favorite_border,color: wishList.,)
                        Icon( Icons.favorite, color: Colors.grey[300],)

                      ],
                    ),

                    // Expanded(
                    //   child: Container(
                    //     // height: 100,
                    //     // width: 100,
                    //     decoration: BoxDecoration(
                    //         color: Colors.red
                    //     ),
                    //   ),
                    // )
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  'Name',
                  style: TextStyle(
                    fontSize: 14,
                    overflow:
                    TextOverflow
                        .ellipsis,
                    fontWeight:
                    FontWeight
                        .w500,
                    color: Colors.grey[300],
                  ),
                  maxLines: 2,
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  "RS:00}",
                  style:
                  TextStyle(
                    fontSize: 13,
                    fontWeight:
                    FontWeight
                        .w600,
                    // color: Color(0xff373491),
                    color: Colors.grey[300],
                    overflow:
                    TextOverflow
                        .ellipsis,
                  ),
                ),
                // SizedBox(height: 10,)
                // Row(
                //   mainAxisAlignment:
                //   MainAxisAlignment
                //       .end,
                //   children: [
                //     Container(
                //       height: 30,
                //       width: 30,
                //       decoration:
                //       BoxDecoration(
                //         shape: BoxShape.circle,
                //         color: Colors.grey[300],
                //         // color: Color(0xff189084),
                //       ),
                //       child: Icon(
                //         Icons.add,
                //         color: Colors.grey[300],size: 18,
                //       ),
                //     ),
                //   ],
                // ),
              ],
            ),
          )
          // Expanded(
          //   child: Padding(
          //     padding: EdgeInsets.symmetric(vertical: _desktop ? 0 : Dimensions.PADDING_SIZE_EXTRA_SMALL),
          //     child: Row(children: [
          //
          //       Container(
          //         height: _desktop ? 120 : 65, width: _desktop ? 120 : 80,
          //         decoration: BoxDecoration(
          //           borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
          //           color: Colors.grey[300],
          //         ),
          //       ),
          //       SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
          //
          //       Expanded(
          //         child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
          //
          //           Container(height: _desktop ? 20 : 10, width: double.maxFinite, color: Colors.grey[300]),
          //           SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
          //
          //           // Container(
          //           //   height: _desktop ? 15 : 10, width: double.maxFinite, color: Colors.grey[300],
          //           //   margin: EdgeInsets.only(right: Dimensions.PADDING_SIZE_LARGE),
          //           // ),
          //           SizedBox(height: isRestaurant ? Dimensions.PADDING_SIZE_SMALL : 0),
          //
          //           !isRestaurant ? RatingBar(rating: 0, size: _desktop ? 15 : 12, ratingCount: 0) : SizedBox(),
          //           isRestaurant ? RatingBar(
          //             rating: 0, size: _desktop ? 15 : 12,
          //             ratingCount: 0,
          //           ) : Row(children: [
          //             Container(height: _desktop ? 20 : 15, width: 30, color: Colors.grey[300]),
          //             SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
          //             Container(height: _desktop ? 15 : 10, width: 20, color: Colors.grey[300]),
          //           ]),
          //
          //         ]),
          //       ),
          //
          //       Column(mainAxisAlignment: isRestaurant ? MainAxisAlignment.center : MainAxisAlignment.spaceBetween, children: [
          //         !isRestaurant ? Padding(
          //           padding: EdgeInsets.symmetric(vertical: _desktop ? Dimensions.PADDING_SIZE_SMALL : 0),
          //           child: Icon(Icons.add, size: _desktop ? 30 : 25),
          //         ) : SizedBox(),
          //         Padding(
          //           padding: EdgeInsets.symmetric(vertical: _desktop ? Dimensions.PADDING_SIZE_SMALL : 0),
          //           child: Icon(
          //             Icons.favorite_border,  size: _desktop ? 30 : 25,
          //             color: Theme.of(context).disabledColor,
          //           ),
          //         ),
          //       ]),
          //
          //     ]),
          //   ),
          // ),
          // _desktop ? SizedBox() : Padding(
          //   padding: EdgeInsets.only(left: _desktop ? 130 : 90),
          //   child: Divider(color: hasDivider ? Theme.of(context).disabledColor : Colors.transparent),
          // ),
        ],
      ),
    );
  }
}
