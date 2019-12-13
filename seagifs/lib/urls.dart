class Urls {
  String _trending; 
  String _search;

  Urls();

  String getURLTrending(){
    return _trending; 
  }

  void setURLTrending(){
    _trending = "https://api.giphy.com/v1/gifs/trending?api_key=5qyByQ4bJ3k8YuFb4AiM4iNAREJ8FuPk&limit=20&rating=G"; 
  }
  
  String getURLSearch(){
    return _search; 
  }

  void setURLSearch(String search, int offset){
    _search = "https://api.giphy.com/v1/gifs/search?api_key=5qyByQ4bJ3k8YuFb4AiM4iNAREJ8FuPk&q=$search&limit=20&offset=$offset&rating=G&lang=en";
  }
}