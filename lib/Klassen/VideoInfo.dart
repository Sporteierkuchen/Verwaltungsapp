class VideoInfo {


  int video_id;
  String path;
  String titel;
  String logo;
  String buttontext;
  String audiopath;
  List<String> categoryListe;

  VideoInfo({

    required this.video_id,
    required this.path,
    required this.titel,
    required this.logo,
    required this.buttontext,
    required this.audiopath,
    required this.categoryListe

  });
}