class Phenome
{
  float studentSquareSizeW;
  float studentSquareSizeH;
  float colW;
  float rowH;
  int gutter;
  int padding;
  float mult;
  Gene g;
  
  Phenome( Gene _g )
  {
    g = _g;
    studentSquareSizeW = 24;
    studentSquareSizeH = 15;
    gutter = 2;
    padding = 2;
    colW = studentSquareSizeW + padding*2;
    rowH = studentSquareSizeH + padding;
  }
  
  void render( int _x, int _y, float _mult )
  {
    mult = _mult;
    pushMatrix();
      translate( _x, _y );
      scale( _mult );
      drawCourses();
    popMatrix();
  }
  
  void render( int _x, int _y, float _mult, PGraphics img )
  {
    mult = _mult;
    img.pushMatrix();
      img.translate( _x, _y );
      img.scale( _mult );
      drawCourses( img );
    img.popMatrix();
  }
  
  void drawCourses()
  {
    fill( 0 );
    if ( mult < 1.0 ) textSize( 28 );
    else textSize( 10 );
    text( g.fitness, 0, -10 );
    color chCol = #ffffff;
    color prefCol = #ffffff;
    for ( int i=0; i<numberOfCourses; i++ ){
      Course ci = (Course) g.geneCourses.get( i );
      
      noFill();
      strokeWeight( 1 );
      
      if ( ci.group.equals( "A" ) ){
        stroke( choiceColorsBLUE[0] );
      }
      else if ( ci.group.equals( "B" ) ){
        stroke( choiceColorsRED[0] );
      }
      
      rect( i*colW, -padding/2, colW, ci.minNumber * (rowH) ); 
      rect( i*colW, -padding/2, colW, ci.maxNumber * (rowH) );
     
      for ( int j=0; j<ci.numStudentsInCourse(); j++ ){
        chCol = #ffffff;
        prefCol = #ffffff;
        Student sj = (Student) ci.studentsInCourse.get( j );
        if ( sj.groupPreference.equals( "A" ) ){
          prefCol = choiceColorsBLUE[0];
        }
        else if ( sj.groupPreference.equals( "B" ) ){
          prefCol = choiceColorsRED[0];
        }
        for ( int k=0; k<sj.groupAChoices.size(); k++ ){
          String sjChAk = (String) sj.groupAChoices.get( k );
          String sjChBk = (String) sj.groupBChoices.get( k );
          if ( ci.courseName.equals( sjChAk ) || ci.courseName.equals( sjChBk ) ){
            chCol = choiceColorsGREEN[ k ];
            break;
          }
        }
        stroke( 100 );
        strokeWeight( 0.25 );
        fill( chCol );
        rect( i*colW + padding, j*rowH, studentSquareSizeW, studentSquareSizeH );
        //if ( prefCol == #ffffff ) println( "why is this white?" );
        fill( prefCol );
        ellipseMode( CORNER );
        ellipse( i*colW + padding + 1, j*rowH + 11, 3, 3 );
        fill( 0 );
        if ( mult > 1.0 ){
          textSize( 5 );
          text( sj.lastName + ", ", i*colW + padding + 0.5, j*rowH + 5 );
          text( sj.firstName, i*colW + padding + 0.5, j*rowH + 10 );
        }
      } 
    }
  }
  
  void drawCourses( PGraphics img )
  {
    img.fill( 0 );
    if ( mult < 1.0 ) img.textSize( 28 );
    else img.textSize( 10 );
    img.text( g.fitness, 0, -10 );
    color chCol = #ffffff;
    color prefCol = #ffffff;
    for ( int i=0; i<numberOfCourses; i++ ){
      Course ci = (Course) g.geneCourses.get( i );
      
      img.noFill();
      img.strokeWeight( 1 );
      
      if ( ci.group.equals( "A" ) ){
        img.stroke( choiceColorsBLUE[0] );
      }
      else if ( ci.group.equals( "B" ) ){
        img.stroke( choiceColorsRED[0] );
      }
      
      img.rect( i*colW, -padding/2, colW, ci.minNumber * (rowH) ); 
      img.rect( i*colW, -padding/2, colW, ci.maxNumber * (rowH) );
     
      for ( int j=0; j<ci.numStudentsInCourse(); j++ ){
        chCol = #ffffff;
        prefCol = #ffffff;
        Student sj = (Student) ci.studentsInCourse.get( j );
        if ( sj.groupPreference.equals( "A" ) ){
          prefCol = choiceColorsBLUE[0];
        }
        else if ( sj.groupPreference.equals( "B" ) ){
          prefCol = choiceColorsRED[0];
        }
        for ( int k=0; k<sj.groupAChoices.size(); k++ ){
          String sjChAk = (String) sj.groupAChoices.get( k );
          String sjChBk = (String) sj.groupBChoices.get( k );
          if ( ci.courseName.equals( sjChAk ) || ci.courseName.equals( sjChBk ) ){
            chCol = choiceColorsGREEN[ k ];
            break;
          }
        }
        img.stroke( 100 );
        img.strokeWeight( 0.25 );
        img.fill( chCol );
        img.rect( i*colW + padding, j*rowH, studentSquareSizeW, studentSquareSizeH );
        //if ( prefCol == #ffffff ) println( "why is this white?" );
        img.fill( prefCol );
        img.ellipseMode( CORNER );
        img.ellipse( i*colW + padding + 1, j*rowH + 11, 3, 3 );
        img.fill( 0 );
        if ( mult > 1.0 ){
          img.textSize( 5 );
          img.text( sj.lastName + ", ", i*colW + padding + 0.5, j*rowH + 5 );
          img.text( sj.firstName, i*colW + padding + 0.5, j*rowH + 10 );
        }
      } 
    }
  }
}
