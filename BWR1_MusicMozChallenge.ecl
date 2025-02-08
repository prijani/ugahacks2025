//#OPTION('obfuscateOutput', TRUE);
IMPORT $;
MozMusic := $.File_Music.MozDS;

//display the first 150 records

OUTPUT(CHOOSEN(MozMusic, 150), NAMED('Moz_MusicDS'));

//*********************************************************************************
//*********************************************************************************

//                                CATEGORY ONE 

//*********************************************************************************
//*********************************************************************************

//Challenge: 
//Count all the records in the dataset:

COUNT(MozMusic);

//Result: Total count is 136510

//*********************************************************************************
//*********************************************************************************
//Challenge: 

//Sort by "name",  and display (OUTPUT) the first 50(Hint: use CHOOSEN):
OUTPUT(CHOOSEN(SORT(MozMusic, 'name'), 50), NAMED('Q1A'));
//You should see a lot of songs by NSync 



//*********************************************************************************
//*********************************************************************************
//Challenge: 
//Count total songs in the "Rock" genre and display number:

OUTPUT(COUNT(MozMusic(genre='Rock')), NAMED('Q1B_Count'));

//Result should have 12821 Rock songs

//Display your Rock songs (OUTPUT):
OUTPUT(MozMusic(genre='Rock'), NAMED('Q1B'));


//*********************************************************************************
//*********************************************************************************
//Challenge: 
//Count how many songs was released by Depeche Mode between 1980 and 1989

//Filter ds for "Depeche_Mode" AND releasedate BETWEEN 1980 and 1989
q1c := SORT(MozMusic, 'name' = 'Depeche Mode' AND 'releasedate' BETWEEN '1980' AND '1989');
// Count and display total
//Result should have 127 songs 
OUTPUT(COUNT(q1c), NAMED('Q1C'));

//Bonus points: filter out duplicate tracks (Hint: look at DEDUP):


//*********************************************************************************
//*********************************************************************************
//Challenge: 
//Who sang the song "My Way"?
//Filter for "My Way" tracktitle
q1d := MozMusic(tracktitle='My Way');
// Result should have 136 records 

//Display count and result 
OUTPUT(q1d, NAMED('Q1D'));
OUTPUT(COUNT(q1d), NAMED('Q1D_Count'));

//*********************************************************************************
//*********************************************************************************
//Challenge: 
//What song(s) in the Music Moz Dataset has the longest track title in CD format?

//Get the longest description (tracktitle) field length in CD "formats"
CDformat := MozMusic(formats = 'CD');

//Filter dataset for tracktitle with the longest value
maxq1e := MAX(CDformat, 'tracktitle');
q1e := SORT(CDformat, 'tracktitle' = maxq1e);
//Display the result
OUTPUT(q1e, NAMED('Q1E'));

//Longest track title is by the "The Brand New Heavies"               


//*********************************************************************************
//*********************************************************************************

//                                CATEGORY TWO

//*********************************************************************************
//*********************************************************************************
//Challenge: 
//Display all songs produced by "U2" , SORT it by title.

//Filter track by artist
U2 := SORT(MozMusic, 'name' = 'U2');

//Sort the result by tracktitle
U2byTitle := SORT(U2, 'tracktitle');

//Output the result
OUTPUT(U2byTitle, NAMED('Q2A'));

//Count result 
OUTPUT(COUNT(U2byTitle), NAMED('Q2A_Count'));

//Result has 190 records


//*********************************************************************************
//*********************************************************************************
//Challenge: 
//Count all songs where guest musicians appeared 

//Hint: Think of the filter as "not blank" 

//Filter for "guestmusicians"
guestMusicians := MozMusic(guestmusicians <> '');

//Display Count result
 OUTPUT(COUNT(guestMusicians), NAMED('Q2B'));                            

//Result should be 44588 songs  


//*********************************************************************************
//*********************************************************************************
//Challenge: 
//Create a new recordset which only has "Track", "Release", "Artist", and "Year"
// Get the "track" value from the MusicMoz TrackTitle field
// Get the "release" value from the MusicMoz Title field
// Get the "artist" value from the MusicMoz Name field
// Get the "year" value from the MusicMoz ReleaseDate field

//Result should only have 4 fields. 

//Hint: First create your new RECORD layout  
newLayout := RECORD
  STRING track;
  STRING release;
  STRING artist;
  STRING year;
END;


//Next: Standalone Transform - use TRANSFORM for new fields.
transformed := PROJECT(MozMusic, TRANSFORM(newLayout,
    SELF.track := LEFT.TrackTitle,
    SELF.release := LEFT.Title,
    SELF.artist := LEFT.Name,
    SELF.year := LEFT.ReleaseDate
));

//Use PROJECT, to loop through your music dataset
q2c := PROJECT(transformed, TRANSFORM(newLayout, 
    SELF.track := LEFT.track, 
    SELF.release := LEFT.release, 
    SELF.artist := LEFT.artist, 
    SELF.year := LEFT.year)
);

// Display result  
OUTPUT(q2c, NAMED('Q2C'));

//*********************************************************************************
//*********************************************************************************

//                                CATEGORY THREE

//*********************************************************************************
//*********************************************************************************

//Challenge: 
//Display number of songs per "Genre", display genre name and count for each 

//Hint: All you need is a 2 field TABLE using cross-tab
q3a := TABLE(MozMusic, 
    RECORD
        MozMusic.genre;
        INTEGER TotalSongs := COUNT(GROUP);
    END,
    genre
);

//Display the TABLE result      
OUTPUT(q3a, NAMED('Q3A'));

//Count and display total records in TABLE
OUTPUT(COUNT(q3a), NAMED('Q3A_TOTAL'));

//Result has 2 fields, Genre and TotalSongs, count is 1000

//*********************************************************************************
//*********************************************************************************
//What Artist had the most releases between 2001-2010 (releasedate)?

//Hint: All you need is a cross-tab TABLE 

//Output Name, and Title Count(TitleCnt)

//Filter for year (releasedate)
yearFiltered := MozMusic(releasedate BETWEEN '2001' AND '2010');
//Cross-tab TABLE
q3b := TABLE(yearFiltered, 
    RECORD
        yearFiltered.name;
        INTEGER TitleCnt := COUNT(GROUP);
    END,
    name
);

//Display the result      
OUTPUT(q3b, NAMED('Q3B'));

maxq3b := MAX(q3b, 'TitleCnt');
artistq3b := SORT(q3b, 'tracktitle' = maxq3b);
OUTPUT(artistq3b, NAMED('Q3B_Artist'));