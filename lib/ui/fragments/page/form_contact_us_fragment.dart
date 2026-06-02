import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:hydrao_flutter_offline/constants.dart';
import 'package:hydrao_flutter_offline/l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

// const _logTag = "[FORM_CONTACT_US] ";

class FormContactUsFragment extends StatefulWidget {
  const FormContactUsFragment({super.key});

  @override
  State<FormContactUsFragment> createState() => _FormContactUsFragmentState();
}

class _FormContactUsFragmentState extends State<FormContactUsFragment> {
  double _progress = 0; // Progression de 0.0 à 1.0

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    final t = AppLocalizations.of(context)!;

    final url = (locale == 'fr')
        ? AppConstants.contactFormFrUrl
        : AppConstants.contactFormEnUrl;

    Widget content = Stack(
      children: [
        // 1. La WebView
        InAppWebView(
          initialUrlRequest: URLRequest(url: WebUri(url)),
          initialSettings: InAppWebViewSettings(
            javaScriptEnabled: true,
            // INDISPENSABLE pour les uploads :
            databaseEnabled:
                true, // Nécessaire pour le stockage temporaire d'upload
            domStorageEnabled:
                true, // Zoho en a besoin pour suivre l'ID de session d'upload
            thirdPartyCookiesEnabled:
                true, // Zoho utilise souvent un domaine différent pour l'upload (us4-files...)
            allowFileAccess: true,
            allowContentAccess: true,
            // Autorise la lecture des fichiers depuis le système de fichiers
            allowFileAccessFromFileURLs: true,
            allowUniversalAccessFromFileURLs: true,
            // Spécifique à certains formulaires qui utilisent des iframes pour l'upload
            mixedContentMode: MixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
            // Améliore le support des formulaires complexes
            useOnDownloadStart: true,
            // Permet de scroller proprement sur Android
            overScrollMode: OverScrollMode.IF_CONTENT_SCROLLS,
            // AJOUT : Empêche le clavier de cacher les champs sur certains Android
            useWideViewPort: true,
            // Sur iOS, cela aide parfois à débloquer les interactions de fichiers complexes
            useOnShowFileChooser:
                true, // FORCE l'appel du callback sur iOS également
            allowsInlineMediaPlayback: true,
          ),
          onProgressChanged: (controller, progress) {
            setState(() {
              _progress = progress / 100; // On convertit 0-100 en 0.0-1.0
            });
          },
          onLoadStop: (controller, url) async {
            setState(() {
              _progress = 1.0; // Force à 100% à l'arrêt
            });
            await controller.scrollTo(x: 0, y: 0, animated: true);
          },

          onShowFileChooser: (controller, fileChooserParams) async {
            // ANDROID only
            try {
              // bool isMultiple = fileChooserParams.mode == FileChooserMode.OPEN_MULTIPLE;
              bool isImageOnly = fileChooserParams.acceptTypes.any(
                (type) => type.contains("image"),
              );
              bool isMultiple = fileChooserParams.mode.toString().contains(
                'MULTIPLE',
              );
              // appLogger.d(
              //   "$LOG_TAG fileChooser : $fileChooserParams / mode=${fileChooserParams.mode} / acceptTypes=${fileChooserParams.acceptTypes} / title=${fileChooserParams.title}",
              // );

              List<String> selectedPaths = [];

              // On propose le choix si c'est une image, car FilePicker ne déclenche pas la caméra
              final String? source = await showModalBottomSheet<String>(
                context: context,
                builder: (context) => SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: const Icon(Icons.camera_alt),
                        title: Text(t.takeAPhoto),
                        onTap: () => Navigator.pop(context, 'camera'),
                      ),
                      ListTile(
                        leading: const Icon(Icons.photo_library),
                        title: Text(t.fromGallery),
                        onTap: () => Navigator.pop(context, 'gallery'),
                      ),
                      ListTile(
                        leading: const Icon(Icons.folder),
                        title: Text(t.fromFiles),
                        onTap: () => Navigator.pop(context, 'files'),
                      ),
                    ],
                  ),
                ),
              );

              final ImagePicker picker = ImagePicker();

              if (source == 'camera') {
                // check permissions first
                await [Permission.camera, Permission.photos].request();

                // L'appareil photo est par nature "un par un"
                final XFile? photo = await picker.pickImage(
                  source: ImageSource.camera,
                );
                if (photo != null) {
                  selectedPaths.add(Uri.file(photo.path).toString());
                }
              } else if (source == 'gallery') {
                if (isMultiple) {
                  final List<XFile> images = await picker.pickMultiImage();
                  selectedPaths.addAll(
                    images.map((img) => Uri.file(img.path).toString()),
                  );
                } else {
                  final XFile? photo = await picker.pickImage(
                    source: ImageSource.gallery,
                  );
                  if (photo != null) {
                    selectedPaths.add(Uri.file(photo.path).toString());
                  }
                }
              } else if (source == 'files') {
                FilePickerResult? result = await FilePicker.platform.pickFiles(
                  type: isImageOnly ? FileType.image : FileType.any,
                  allowMultiple: isMultiple,
                );
                if (result != null && result.files.isNotEmpty) {
                  // 2. Extraire les chemins physiques (NonNull)
                  selectedPaths = result.files
                      .where((file) => file.path != null)
                      .map((file) => Uri.file(file.path!).toString())
                      .toList();
                }
              }

              // 3. Retourner la réponse avec les chemins bruts
              return ShowFileChooserResponse(
                filePaths: selectedPaths,
                handledByClient: true,
              );
            } catch (e) {
              debugPrint("Erreur FilePicker : $e");
            }

            // 4. En cas d'annulation, on renvoie une liste vide pour libérer la WebView
            return ShowFileChooserResponse(
              filePaths: [],
              handledByClient: true,
            );
          },
          onPermissionRequest: (controller, request) async {
            // Cette fonction intercepte les demandes de la page Web
            // (Caméra, Micro, etc.) et les valide au niveau natif
            return PermissionResponse(
              resources: request.resources,
              action: PermissionResponseAction.GRANT,
            );
          },
        ),

        // 2. L'indicateur de chargement (Spinner ou Barre)
        if (_progress < 1.0)
          Container(
            color: Colors.white.withValues(alpha: 0.8), // Fond semi-transparent
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 10),
                  Text("${(_progress * 100).toInt()}%"),
                ],
              ),
            ),
          ),
      ],
    );

    return content;
  }
}
