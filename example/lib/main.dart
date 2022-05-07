import 'package:cloudimage_360_view/cloudimage_360_view.dart';
import 'package:example/components/index.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cloud Image 360 View',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ExamplePage(),
    );
  }
}

class ExamplePage extends StatefulWidget {
  const ExamplePage({Key? key}) : super(key: key);

  @override
  State<ExamplePage> createState() => _ExamplePageState();
}

class _ExamplePageState extends State<ExamplePage> {
  bool autoRotate = true;
  bool allowSwipe = true;
  int swipeSensitivity = 1;
  int rotationCount = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/ci_360.png',
                height: 100,
              ),
              Text(
                'CloudImage 360(3D) ImageView',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(color: const Color.fromARGB(255, 2, 79, 124)),
                textAlign: TextAlign.center,
              ),
              smallVerticalSpacer,
              Text(
                'Engage your customers with a stunning 360 view of your products',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              verticalSpacer,
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: AppListCard(
                  title: ExpansionTile(
                    title: const Text('Options'),
                    children: [
                      const Divider(),
                      AppSwitchTile(
                        title: const Text('Auto Rotate'),
                        value: autoRotate,
                        onChanged: (_) {
                          safeSetState(() {
                            autoRotate = !autoRotate;
                          });
                        },
                      ),
                      AppSwitchTile(
                        title: const Text('Allow Drag/Swipe'),
                        value: allowSwipe,
                        onChanged: (_) {
                          safeSetState(() {
                            allowSwipe = !allowSwipe;
                          });
                        },
                      ),
                      AppListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Drag Sensetivity'),
                            Text(
                              'Faster...Slower',
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                          ],
                        ),
                        subtitle: SizedBox(
                          height: 35,
                          child: SingleChildScrollView(
                            padding: EdgeInsets.zero,
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                for (var i = 1; i < 6; i++)
                                  ChoiceChip(
                                    selected: swipeSensitivity == i,
                                    label: Text('$i'),
                                    selectedColor: Colors.blueAccent.withOpacity(0.8),
                                    disabledColor: Colors.white54,
                                    onSelected: (_) {
                                      if (swipeSensitivity != i) {
                                        safeSetState(() {
                                          swipeSensitivity = i;
                                        });
                                      }
                                    },
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      AppListTile(
                        title: const Text('Rotation Count'),
                        subtitle: SizedBox(
                          height: 35,
                          child: SingleChildScrollView(
                            padding: EdgeInsets.zero,
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                for (var i = 0; i < 50; i++)
                                  ChoiceChip(
                                    selected: rotationCount == i,
                                    label: Text(i == 0 ? 'infinite' : '$i'),
                                    selectedColor: Colors.blueAccent.withOpacity(0.8),
                                    disabledColor: Colors.white54,
                                    onSelected: (_) {
                                      if (rotationCount != i) {
                                        safeSetState(() {
                                          rotationCount = i;
                                        });
                                      }
                                    },
                                  )
                              ],
                            ),
                          ),
                        ),
                      ),
                      verticalSpacer,
                      Text(
                        'more of features soon',
                        style:
                            Theme.of(context).textTheme.subtitle1?.copyWith(color: Colors.blueGrey),
                      ),
                      verticalSpacer,
                    ],
                  ),
                ),
              ),
              verticalSpacer,
              verticalSpacer,
              _TileBuilder(
                headerTitle: 'Horizontal & Vertical (x&y) Axis Eaxmple',
                child: Ci360View(
                  xImageModel: Ci360ImageModel.horizontal(
                    imageFolder: 'https://scaleflex.cloudimg.io/v7/demo/360-nike/',
                    imageName: (index) => 'nike-$index.jpg',
                    imagesLength: 35,
                  ),
                  yImageModel: Ci360ImageModel.vertical(
                    imageFolder: 'https://scaleflex.cloudimg.io/v7/demo/360-nike/',
                    imageName: (index) => 'nike-y-$index.jpg',
                    imagesLength: 36,
                  ),
                  options: Ci360Options(
                    swipeSensitivity: swipeSensitivity,
                    autoRotate: autoRotate,
                    rotationCount: rotationCount,
                    allowSwipeToRotate: allowSwipe,
                    onImageChanged: (index, reason, axis) {},
                  ),
                ),
              ),
              verticalSpacer,
              const Divider(thickness: 8),
              verticalSpacer,
              _TileBuilder(
                headerTitle: 'Horizontal(x) Axis Only Eaxmple',
                child: Ci360View(
                  xImageModel: Ci360ImageModel.horizontal(
                    imageFolder: 'https://scaleflex.cloudimg.io/v7/demo/earbuds/',
                    imageName: (index) => '$index.jpg',
                    imagesLength: 233,
                  ),
                  options: Ci360Options(
                    swipeSensitivity: swipeSensitivity,
                    autoRotate: autoRotate,
                    rotationCount: rotationCount,
                    allowSwipeToRotate: allowSwipe,
                    onImageChanged: (index, reason, axis) {},
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TileBuilder extends StatelessWidget {
  const _TileBuilder({
    required this.headerTitle,
    required this.child,
    Key? key,
  }) : super(key: key);

  final String headerTitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Text(
            headerTitle,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          smallVerticalSpacer,
          child,
        ],
      ),
    );
  }
}
