import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:house_rent/pages/new_post_form.dart';
import 'package:house_rent/pages/post_view_details.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OwnFeedPage extends StatefulWidget {
 
 const OwnFeedPage({super.key});

  @override
  State<OwnFeedPage> createState() => _OwnFeedPageState();
  
}

  late Stream<QuerySnapshot> messagesStream;

 
List<dynamic> ownrentalTypes = [] ;
 String docname='';
Future<void> getAllPosts() async {
 int? postno;
    final getpostnumber;
    DocumentSnapshot? documentSnapshot = await FirebaseFirestore.instance
      .collection('postserial')
      .doc('postnumber')
      .get();

 getpostnumber = documentSnapshot.data();
 postno = getpostnumber['postno'];
 SharedPreferences prefs = await SharedPreferences.getInstance();
    String? oid = prefs.getString('uid');
    final firestore = FirebaseFirestore.instance;
    // Query posts collection for the user's posts
 final querySnapshot = await FirebaseFirestore.instance
      .collection('posts').where('UID', isEqualTo: oid)
      .get()
      .then((snapshots) {
    ownrentalTypes = [];
   snapshots.docs.forEach((element) {
    
      // print(element.data());
     ownrentalTypes.add(element.data());
    });
      final  documentname = snapshots.docs;
      for (var document in documentname) {
      docname = document.id.toString();
    }
      print("Doc name is = $docname");
  });
return querySnapshot;
}



class _OwnFeedPageState extends State<OwnFeedPage> {
List<Map<String, dynamic>> _imageUrls = [];
 @override
  void initState() {
    super.initState();
    
    setState(() {
      _imageUrls = [];
      getAllPosts();
    });
    
  }

Future<List<Map<String, dynamic>>> getImagesFromStorage(int index) async {
  List<Map<String, dynamic>> imageList = [];

  // Initialize Firebase Storage
  final FirebaseStorage storage = FirebaseStorage.instance;

  try {
    // Replace 'your_folder_path' with the actual path to your images in Firebase Storage
    final ListResult result = await storage.ref('posts').child('post$index').listAll();
    for (final Reference reference in result.items) {
      final String imageUrl = await reference.getDownloadURL();

      // Create a Map for each image and add it to the list
      Map<String, dynamic> imageMap = {
        'url': imageUrl,
      };
      _imageUrls.add(imageMap);
      imageList.add(imageMap);
    }
    return imageList;
  } catch (e) {
    // Handle errors here
    print('Error fetching images: $e');
    return [];
  }
}
  
  @override
  Widget build(BuildContext context) {
    setState(() {
      getAllPosts();
    });
    return 
    // Scaffold(
    //   body: SafeArea(child: Text('data')),
    // );
    Scaffold(
      backgroundColor: Colors.white,
      // appBar: PreferredSize(
      //   preferredSize: Size.fromHeight(60.0),
      //   child: SafeArea(
      //     child: Container(
      //       padding: EdgeInsets.all(8.0),
      //       decoration: BoxDecoration(
      //         boxShadow: [
      //           BoxShadow(
      //             color: Colors.grey.withOpacity(0.5),
      //             spreadRadius: 5,
      //             blurRadius: 7,
      //             offset: Offset(0, 3), // changes position of shadow
      //           ),
      //         ],
      //         color: Color.fromARGB(
      //             255, 248, 250, 250), // Background color of AppBar
      //         borderRadius: BorderRadius.vertical(
      //           bottom: Radius.circular(20.0), // Rounded bottom corners
      //         ),
      //       ),
      //       child: Row(
      //         children: [
      //           IconButton(
      //             icon: Icon(Icons.meeting_room_sharp,size: 30,color: Color.fromARGB(255, 250, 70, 70),),
      //             onPressed: () {
      //               // Add logic to handle back navigation if needed
      //             },
      //           ),
      //           SizedBox(width: 8.0),
      //           Text(
      //             "সকল বিজ্ঞাপন",
      //             style: GoogleFonts.openSans(
      //                 fontSize: 22,
      //                 fontWeight: FontWeight.bold,
      //                 color: Color.fromARGB(255, 250, 70, 70)),
      //           ),
      //           Spacer(), // Adds flexible space between title and actions
      //         ],
      //       ),
      //     ),
      //   ),
      // ),
      body:FutureBuilder(
    future: getAllPosts(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Container(height: double.infinity,width: double.infinity, child: Center(child: CircularProgressIndicator())); // Show a loading indicator while fetching data.
      } else if (snapshot.hasError) {
        return Text('Error: ${snapshot.error}');
      } else {
        return  pageViewBuild();
      }
    },
  ) ,
      
      
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Navigate to your desired page when the button is pressed
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => CreateRentPostScreen()));
        },
        label: Text('ফ্রি পোস্ট করুন'),
        icon: Icon(Icons.add),
        backgroundColor: const Color.fromARGB(255, 53, 54, 54), // Customize the button color
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat, // Adjust button location
    );

  }

  SafeArea pageViewBuild() {
    return SafeArea(
      child: Container(
        width: double.infinity,
        color: Colors.white,
        child:  SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              FilterBar(),
    //           Container(
    //             height: 400,
    //             width: double.infinity,
    //             child: ListView.builder(
    //   itemCount: _imageUrls.length,
    //   itemBuilder: (context, index) {
    //     final imageUrl = _imageUrls[index][1];

    //     return ListTile(
    //       title: Image.network(imageUrl),
    //     );
    //   },
    // )
    //           ),
              // Container(
              //   height: 50,
              //   child: ListView.builder(itemBuilder: (context,index){
              //     return Text("data");
              //   }),
              // ),
    //             StreamBuilder(
    //               stream: messagesStream,
    //   builder: (context, snapshot) {
    //     if (snapshot.hasData) return const Text('Loading...');
    //     return ListView.builder(
    //       itemExtent: 225.0,
    //       itemCount: snapshot.data.documents.length,
    //       itemBuilder: (context, index) =>
    //           _buildListItems(context, snapshot.data.documents[index]),
    //     );
    //   },
    // ),
              Container(
                child: ListView.builder(
                  physics: ScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: ownrentalTypes.length,
                  itemBuilder: (BuildContext context,index){
                    int imgads = ownrentalTypes[index]["postno"];
                    Future<List<Map<String, dynamic>>> imageUrls =  getImagesFromStorage(imgads);
                    String details = ownrentalTypes[index]['houseDetails'];
                    String rent = ownrentalTypes[index]['rent'];
                    String Uid = ownrentalTypes[index]['UID']; 
                    Timestamp getdate = ownrentalTypes[index]['rentDate'];
                    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(getdate.seconds * 1000);
                    return GestureDetector(onTap:() {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>PostViewDetails(rentType: ownrentalTypes[index],imageurl: imageUrls,uid : Uid,date :dateTime)));
                    }, 
                    child: PostItem(imageurls: imageUrls, description: details, price: rent,date: dateTime));
                    
                  }
                  ),
              ),
              // PostItem(image: AssetImage("assets/images/bedroom.jpg"),description: "ফ্ল্যাট ভাড়া হবে সেপ্টেম্বর মাস থেকে, মিরপুর ১০, 597 est kazipara mirpur Dhaka 1216, 597 est kazipara mirpur Dhaka 1216",price: "৳ ১৫,৭৮৫৭০",),
              // PostItem(image: AssetImage("assets/images/bedroom2.jpg"),description:"বাসা ভাড়া খুঁজছি, ইসলামপুর" ,price: "৳ ৫,০০০",),
              // PostItem(image: AssetImage("assets/images/bedroom3.jpg"),description:"ফ্ল্যাট ভাড়া হবে সেপ্টেম্বর মাস থেকে সাভার" ,price: "৳ ১৫,৭৮৫৭০",),
              // ElevatedButton(onPressed: (){
              //   print(rentalTypes);
              // }, child: Text("data"))
              ],
          ),
        ),
      ),
    );
  }
}

class PostItem extends StatelessWidget {
  final DateTime date;
  final String description;
  final String price;
  final Future<List<Map<String, dynamic>>> imageurls;
  const PostItem({
   required this.description,
   required this.price,
   required this.imageurls,
   required this.date
  });
String getFormattedDate() {
  String monthName = DateFormat('MMMM').format(date);
  // DateFormat('MMMM dd, yyyy').format(date);
    // Format the selected date to include the month name
    return monthName;
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20.0,15.0 ,20.0,0),
      child: Column(
        children: [
          FutureBuilder(future: imageurls, 
          builder: (context,snapshot){
           final img =snapshot.data ?? [{'url' : ''}];
            return 
          Container(
            height: 200,
            width: double.infinity,
            alignment: Alignment.bottomLeft,
            decoration: BoxDecoration(
              image: DecorationImage(fit: BoxFit.fill, image: NetworkImage( img[0]['url'] )),
              borderRadius: BorderRadius.circular(10.0)
            ),
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0),gradient: LinearGradient(begin: Alignment.bottomCenter,end:Alignment.topCenter, colors: [Colors.black87,Colors.transparent])),
              child: Row(
                children: [
                  Icon(Icons.apartment_outlined,color: Colors.white,),
                  SizedBox(width: 5.0,),
                  Text("ফ্ল্যাট",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500),),
                  SizedBox(width: 10.0,),
                  Icon(Icons.calendar_month_outlined,color: Colors.white,),
                  SizedBox(width: 5.0,),
                  Text(getFormattedDate(),style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500),),
                  SizedBox(width: 10.0,),
                  Icon(Icons.visibility_outlined,color: Colors.white,),
                  SizedBox(width: 5.0,),
                  Text("0",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500),)
            
                ],
              ),
            ),
          );}
          ),
        SizedBox(height: 20.0,),
        Align(alignment: Alignment.centerLeft, child: Text(description,style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500,height: 1.5),)),
        SizedBox(height: 5.0,),
        Align(alignment: Alignment.centerLeft, child: Text("৳ $price",style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold),))
        ],
      ),
    );
  }
}

class FilterBar extends StatelessWidget {
  const FilterBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 45,
              decoration: BoxDecoration(border: Border.all(color: Colors.black12)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.sort),
                  SizedBox(width: 15.0,),
                  Text("সর্টিং")
                ],
              ),
          )),
          Expanded(
            child: Container(
              height: 45,
              decoration: BoxDecoration(border: Border.symmetric(horizontal: BorderSide(color: Colors.black12))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.location_on_outlined),
                  SizedBox(width: 15.0,),
                  Text("সর্টিং")
                ],
              ),
          )),
          Expanded(
            child: Container(
              height: 45,
              decoration: BoxDecoration(border: Border.all(color: Colors.black12)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.filter_alt_outlined),
                  SizedBox(width: 15.0,),
                  Text("সর্টিং")
                ],
              ),
          )),
        ],
      ),
    );
  }
}


