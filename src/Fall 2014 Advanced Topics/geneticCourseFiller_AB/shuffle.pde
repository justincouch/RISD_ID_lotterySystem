int[] shuffledChoices(int choiceNumber)
{
  StringList choiceList = new StringList();
  int[] choiceListInt = new int[choiceNumber];

  for (int increment00 = 0; increment00 < choiceNumber; increment00++) { 
    choiceList.append(str(increment00));
  } 
  
  //println("Pre shuffle "+choiceList);
  choiceList.shuffle();

  for (int increment00 = 0; increment00 < choiceNumber; increment00++) { 
    choiceListInt[increment00] = int(choiceList.get(increment00));
  } 

  //println("Post shuffle "+choiceListInt);

  return choiceListInt;
}

String [] randShuffle(String[] in){
  int syze = in.length;
  //println(in);
  
  for (int i=syze; i>1; i--){
    swap(in, i-1, floor(random(i-1)));
  }
  
  //println(in);
  return in;
}

void swap(String[] s, int a, int b){
  String s0 = s[a];
  s[a] = s[b];
  s[b] = s0;
}


