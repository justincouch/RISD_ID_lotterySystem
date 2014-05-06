class Gene
{
  ArrayList geneCourses;
  int[] geneStudentsAChoices;
  int[] geneStudentsBChoices;
  float tabulatedScore; // addition of all 'correctness'
  float fitness; // percentage of targetFitness
  
  Gene()
  {
    geneCourses = new ArrayList();
    geneCourses = initCourses( 0 );
    geneStudentsAChoices = new int[ numberOfStudents ];
    geneStudentsBChoices = new int[ numberOfStudents ];
    tabulatedScore = 0;
    fitness = 0;
    
    placeStudents();
  }
  
  void placeStudents()
  {
    for ( int i=0; i<students.size(); i++ ){
      int numAchoices = 4;
      int numBchoices = 4;
      Student si = (Student) students.get( i );
      if ( si.groupPreference.equals( "A" ) ){
        numAchoices /= 2;
      }
      else if ( si.groupPreference.equals( "B" ) ){
        numBchoices /= 2;
      }
      // grab random A choice
      int chA = floor( random( numAchoices ) );
      String chAname = (String) si.groupAChoices.get( chA );
      geneStudentsAChoices[ i ] = chA; 
      // grab random B choice
      int chB = floor( random( numBchoices ) );
      String chBname = (String) si.groupBChoices.get( chB );
      geneStudentsBChoices[ i ] = chB; 
      
      for ( int j=0; j<geneCourses.size(); j++ ){
        Course cj = (Course) geneCourses.get( j );
        if ( cj.courseName.equals( chAname ) || cj.courseName.equals( chBname ) ){
          cj.addStudent( si );
        }
      }
    }
  }
  
  void evaluateFitness()
  {
    //println( "------  EVALUATING FITNESS ------" );
    tabulatedScore = 0;
    fitness = 0;
    
    for ( int i=0; i<geneCourses.size(); i++ ){
      Course ci = (Course) geneCourses.get( i );
      for ( int j=0; j<ci.studentsInCourse.size(); j++ ){
        Student sj = (Student) ci.studentsInCourse.get( j );
        float aMult = 0;
        float bMult = 0;
        if ( sj.groupPreference.equals( "A" ) ){
          aMult = prefMult;
          bMult = regMult;
        }
        else if ( sj.groupPreference.equals( "B" ) ){
          aMult = regMult;
          bMult = prefMult;
        }
        
        for ( int k=0; k<sj.groupAChoices.size(); k++ ){
          String sjChAk = (String) sj.groupAChoices.get( k );
          String sjChBk = (String) sj.groupBChoices.get( k );
          //println( "choice: " + sjChAk );
          //println( "course: " + ci.courseName );
          if ( ci.courseName.equals( sjChAk ) ){
            tabulatedScore += aMult * ( sj.groupAChoices.size()-1 - k );
          }
          if ( ci.courseName.equals( sjChBk ) ){
            tabulatedScore += bMult * ( sj.groupAChoices.size()-1 - k );
          }
        }
      }
      
      if ( ci.numStudentsInCourse() < ci.minNumber ){
        tabulatedScore -= tooFewPenalty * ( ci.minNumber - ci.numStudentsInCourse() );
      }
      else if ( ci.numStudentsInCourse() > ci.maxNumber ){
        tabulatedScore -= tooManyPenalty * ( ci.numStudentsInCourse() - ci.maxNumber );
      }
    }
    
    //println( tabulatedScore );
    fitness = tabulatedScore / targetFitness;
    //println( fitness );
  }
  
  void setCoursesByChoices(){
    for ( int j=0; j<geneCourses.size(); j++ ){
      Course cj = (Course) geneCourses.get( j );
      cj.clearCourse();
    }
    for ( int i=0; i<students.size(); i++ ){
      Student si = (Student) students.get( i );
      
      // grab random A choice
      int chA = geneStudentsAChoices[ i ];
      String chAname = (String) si.groupAChoices.get( chA );
      // grab random B choice
      int chB = geneStudentsBChoices[ i ];
      String chBname = (String) si.groupBChoices.get( chB );
      
      for ( int j=0; j<geneCourses.size(); j++ ){
        Course cj = (Course) geneCourses.get( j );
        
        if ( cj.courseName.equals( chAname ) || cj.courseName.equals( chBname ) ){
          cj.addStudent( si );
        }
      }
    }
  }
  
  Gene crossover( Gene partner )
  {
    Gene child = new Gene();
    
    int randSplit = floor( random( numberOfStudents ) );
    
    for ( int i=0; i<numberOfStudents; i++ ){
      if ( i<randSplit ){
        child.geneStudentsAChoices[i] = geneStudentsAChoices[i];
        child.geneStudentsBChoices[i] = geneStudentsBChoices[i];
      }
      else {
        child.geneStudentsAChoices[i] = partner.geneStudentsAChoices[i];
        child.geneStudentsBChoices[i] = partner.geneStudentsBChoices[i];
      }
    }
    child.setCoursesByChoices();
    
    return child;
  }
  
  void mutate()
  {
    int numAchoices = numChoices;
    int numBchoices = numChoices;
    for ( int i=0; i<numberOfStudents; i++ ){
      Student si = (Student) students.get( i );
      float roll = random( 1 );
      if ( roll < mutationRate ){
        int kInt = -1;
        for ( int j=0; j<si.groupAChoices.size(); j++ ){
          String sijch = (String) si.groupAChoices.get(j);
          if ( sijch.equals( "ID-20ST-03 Khipra Nichols: Design for Living with Pets Monday 8:00a - 1:00p" ) ){
            kInt = j;
          }
        }
        
        if ( si.groupPreference.equals( "A" ) ){
          numAchoices /= 2;
        }
        else if ( si.groupPreference.equals( "B" ) ){
          numBchoices /= 2;
        }
        
        if ( kInt != -1 ){
          geneStudentsAChoices[i] = kInt;
        }
        else {
          geneStudentsAChoices[i] = floor( random( numAchoices ) );
        }
        geneStudentsBChoices[i] = floor( random( numBchoices ) );
      }
    }
    setCoursesByChoices();
  }
  
  void calculateCourseSizes()
  {
    
  }
}
