/*class LiveDetectionScreen extends StatefulWidget {
  @override
//  List<Students> student;
  final CameraDescription cameraDescription;
  LiveDetectionScreen(/*this.student,*/ this.cameraDescription);
  _LiveDetectionScreenState createState() => _LiveDetectionScreenState();
}

enum outSideStatus { none, pendingOutRequest, pendingInRequest }

class _LiveDetectionScreenState extends State<LiveDetectionScreen> {
  Size imageSize;
  var predictions;
  bool _detectingFaces = false;
  bool pictureTaked = false;
  Future _initializeControllerFuture;
  bool cameraInitializated = false;
  List id = [];
  List<Face> faces = [];
  List studentInFrame = [];
  List outsideStatus = [];
  List studentEmbedding = [];
  List embedding = [];
  List firstName = [];
  List lastName = [];
  List status = [];
  List mainstream = [];
  List presentStream = [];
  List absentStream = [];
  List tardyStram = [];
  setUpVariables() {
    /* List<Students> studentsList = widget.student;
    for (int i = 0; i < studentsList.length; i++) {
      var student = studentsList[i];
      id.add(student.id);
      studentEmbedding.add([student.id, convertStringtoList(student.embeddings)]);
      embedding.add(student.id);
      firstName.add(student.firtstName);
      lastName.add(student.lasttName);
      status.add(personOptions.absent);
      absentStream.add(attendance(
          studentId: student.id,
          date: 0,
          status: personOptions.absent,
          lastName: student.lasttName,
          firstName: student.firtstName));
    }
  }*/
  }

  // service injection
  MLKitService _mlKitService = MLKitService();
  CameraService _cameraService = CameraService();
  FaceNetService _faceNetService = FaceNetService();

  @override
  void initState() {
    super.initState();
    setUpVariables();
    //_start();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _cameraService.dispose();
    super.dispose();
  }

  /// starts the camera & start framing faces
  _start() async {
    _initializeControllerFuture =
        _cameraService.startService(widget.cameraDescription);
    await _initializeControllerFuture;

    setState(() {
      cameraInitializated = true;
    });

    _frameFaces();
  }

  _frameFaces() {
    imageSize = _cameraService.getImageSize();

    _cameraService.cameraController.startImageStream((image) async {
      if (_cameraService.cameraController != null) {
        studentInFrame = [];
        // if its currently busy, avoids overprocessing
        if (_detectingFaces) return;

        _detectingFaces = true;
        studentInFrame = [];
        try {
          faces = await _mlKitService.getFacesFromImage(image);

          if (faces.length > 0) {
            for (int i = 0; i < faces.length; i++) {
              predictions =
                  _faceNetService.setCurrentPrediction2(image, faces[i]);
              if (predictions != null) {
                studentInFrame.add(predictions);
              }
            }
            print(studentInFrame);
            /* for (int i = 0; i < studentInFrame.length; i++) {
              int locationOFData =
                  id.firstWhere((element) => element == studentInFrame);
              var statusofPerson = status[locationOFData];
              /* if (statusofPerson == personOptions.absent) {
                int absentListLocation =
                    id.firstWhere((element) => element.studentId == studentInFrame);
                status[locationOFData] = personOptions.present;
                absentStream.removeAt(absentListLocation);
                mainstream.add(attendance(
                    studentId: id[locationOFData],
                    date: 0,
                    status: personOptions.present,
                    lastName: lastName[locationOFData],
                    firstName: firstName[locationOFData]));
                presentStream.add(attendance(
                    studentId: id[locationOFData],
                    date: 0,
                    status: personOptions.present,
                    lastName: lastName[locationOFData],
                    firstName: firstName[locationOFData]));
              }
            }*/
          }*/
          } else {
            setState(() {});
          }

          _detectingFaces = false;
        } catch (e) {
          print(e);
          _detectingFaces = false;
        }
      }
    });
  }

  _onBackPressed() {
    Navigator.of(context).pop();
  }

  _reload() {
    setState(() {
      cameraInitializated = false;
      pictureTaked = false;
    });
    this._start();
  }

  @override
  Widget build(BuildContext context) {
    final double mirror = math.pi;
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              print(snapshot.connectionState);
              if (_cameraService.cameraController != null) {
                return Transform.scale(
                  scale: 1.0,
                  child: AspectRatio(
                    aspectRatio: MediaQuery.of(context).size.aspectRatio,
                    child: OverflowBox(
                      alignment: Alignment.center,
                      child: FittedBox(
                        fit: BoxFit.fitHeight,
                        child: Container(
                          width: width,
                          height: width *
                              _cameraService.cameraController.value.aspectRatio,
                          child: Stack(
                            fit: StackFit.expand,
                            children: <Widget>[
                              CameraPreview(_cameraService.cameraController),
                              ...faces.map((data) {
                                return CustomPaint(
                                  painter: FacePainter(
                                      face: data, imageSize: imageSize),
                                );
                              }).toList()
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
          CameraHeader(
            "Create Student",
            onBackPressed: _onBackPressed,
          )
        ],
      ),
    );
  }
}

void findPeopleInFrame() {}
/*
  CameraImage cameraImage;
  CameraController cameraController;
  List id = [];
  List outsideStatus = [];
  List embedding = [];
  List firstName = [];
  List lastName = [];
  List status = [];
  List mainstream = [];
  List presentStream = [];
  List absentStream = [];
  List tardyStram = [];
  setUpVariables() {
    List<Students> studentsList = widget.student;
    for (int i = 0; i < studentsList.length; i++) {
      var student = studentsList[i];
      id.add(student.id);
      embedding.add(student.id);
      firstName.add(student.firtstName);
      lastName.add(student.lasttName);
      status.add(personOptions.absent);
      absentStream.add(attendance(
          studentId: student.id,
          date: 0,
          status: personOptions.absent,
          lastName: student.lasttName,
          firstName: student.firtstName));
    }
  }

  List findPeopeInFrame() {
    return [
      "asdfsdf",
      "asdfsdf",
      "asdfsdf",
      "asdfsdf",
      "asdfsdf",
      "asdfsdf",
      "asdfsdf"
    ];
  }

  loadCamera() async {
    cameraController = CameraController(cameras[1], ResolutionPreset.high);
    cameraController.initialize().then((value) {
      if (!mounted) {
        return;
      } else {
        setState(() {
          cameraController.startImageStream((image) {
            List ListOfId = findPeopeInFrame();
             else {}
            }
          });
        });
      }
    });
  }

  void initState() {
    super.initState();
    setUpVariables();
    loadCamera();
  }
 */
*/
