
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:another_flushbar/flushbar.dart';
import 'package:image_cropper/image_cropper.dart';







class CaptureScreen extends StatefulWidget {
  const CaptureScreen({Key? key}) : super(key: key);


  @override
  _CaptureScreenState createState() => _CaptureScreenState();
}

class _CaptureScreenState extends State<CaptureScreen> {
  String imagePath = 'asd';
  String selectedItem = '';

  String finalText = '';

  late File pickedImage;
  String imageName = '';

  bool isImageLoaded = false;
  final pdf = pw.Document();




  getImageFromGallery() async {
    if (selectedItem=='Scan Images from Gallery') {
      final XFile? tempStore = await ImagePicker().pickImage(
          source: ImageSource.gallery);


      setState(() {
        pickedImage = File(tempStore!.path);
        isImageLoaded = true;
        imagePath = tempStore.path.toString();
        cropImage(pickedImage);


      });
    }

    if (selectedItem=='Scan by Camera') {
      final XFile? tempStore = await ImagePicker().pickImage(
          source: ImageSource.camera);
      // String? detected = (await EdgeDetection.detectEdge);



      setState(() {
        pickedImage = File(tempStore!.path);
        isImageLoaded = true;
        imagePath = tempStore.path.toString();
        cropImage(pickedImage);
        // imagePath= detected!;



      });
    }



  }


  cropImage(File picked) async{
    File? cropped = await ImageCropper.cropImage(
      androidUiSettings: const AndroidUiSettings(
        toolbarColor: Colors.blue,
        toolbarWidgetColor: Colors.white,
        toolbarTitle: "Crop Image",
      ),

      sourcePath: picked.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9,
      ],



    );
    setState(() {
      pickedImage = cropped!;
    });

  }






  @override

  Widget build(BuildContext context)
  {
    selectedItem = ModalRoute.of(context)!.settings.arguments.toString();
    return Scaffold(
      appBar: AppBar(
        title: Text(selectedItem,
        style: GoogleFonts.atma(
          fontSize: 15.0,
          fontWeight: FontWeight.bold,
        ),
          ),
        actions: [
          TextButton(
              onPressed: getImageFromGallery,
              child: const Icon(
                Icons.add_a_photo,
                color: Colors.white,
              ),

          ),


        IconButton(
              icon: const Icon(Icons.copy),
            onPressed: (){
          }, )
        ],
      ),



      body: SingleChildScrollView(   //bottom overflowed by XX pixels NOT ANYMORE
        child: Column(
          children: [
            const SizedBox(height: 100),
            isImageLoaded?  Center(
              child: Container(
              //   height: 300.0,
              //   width: 300.0,
              //   decoration: BoxDecoration(
              //     image: DecorationImage(
              //         image: FileImage(pickedImage),
              //         fit: BoxFit.cover
              //   ),
              // ),
                alignment: Alignment.center,
                child: Image.file(
                  pickedImage,
                  fit: BoxFit.contain, // This is needed
                  width: 300,
                ),
            )
            ) : Container(),

            const SizedBox(height: 60.0),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SelectableText(finalText,

              ),
            ),
          ],

        ),
      ),




      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // getText(imagePath);

        },
        child: const Icon(
          Icons.check
        ),
      ),


        bottomNavigationBar: BottomAppBar(

          child: IconButton(icon: const Icon(Icons.picture_as_pdf,
            color: Colors.pink,

          ), onPressed: () {
            // createPDF();
            // savePDF();
            }),

            ),

    );

  }

  showPrintedMessage(String title, String msg) {
    Flushbar(
      title: title,
      message: msg,
      duration: const Duration(seconds: 3),
      icon: const Icon(
        Icons.info,
        color: Colors.blue,

      ),

    ).show(context);
  }
}














































































































































//   createPDF() async{
//
//       final image = pw.MemoryImage(
//       pickedImage.readAsBytesSync(),
//     );
//
//
//     pdf.addPage(pw.Page(pageFormat: PdfPageFormat.a4, build: (pw.Context context) {
//       return pw.Center(
//         child: pw.Image(image),
//
//
//       ); // Center
//     }));
//
//
//
//   }
//
//
//
//   savePDF() async{
//     String imageName = pickedImage.path.split('/').last;
//
//
//     try{
//
//         final dir = await getExternalStorageDirectory();
//         final file = File('${dir!.path}/$imageName.pdf');
//         await file.writeAsBytes(await pdf.save());
//         showPrintedMessage('success', 'saved to Documents');
//
//
//     }
//     catch(e){
//       showPrintedMessage('error', e.toString());
//
//     }
//
//
//   }





  // Future getText(String path) async {
  //   finalText = '';
  //   final inputImage = InputImage.fromFile(pickedImage);
  //   final textDetector = GoogleMlKit.vision.textDetector();
  //   final RecognisedText _recognizedText = await textDetector.processImage(
  //       inputImage);
  //
  //   for (TextBlock block in _recognizedText.blocks) {
  //     for (TextLine textLine in block.lines) {
  //       for (TextElement textElement in textLine.elements) {
  //         setState(() {
  //           finalText = finalText + ' ' + textElement.text;
  //         });
  //       }
  //
  //       finalText = finalText + "\n";
  //     }
  //   }
  // }
