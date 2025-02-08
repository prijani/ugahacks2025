//#OPTION('obfuscateOutput', TRUE);
IMPORT $;
MSDMusic := $.File_Music.MSDDS;

//display the first 150 records

OUTPUT(CHOOSEN(MSDMusic, 150), NAMED('Raw_MusicDS'));

//*********************************************************************************
//*********************************************************************************

//                                CATEGORY ONE 

//*********************************************************************************
//*********************************************************************************
//Challenge: 
//Reverse Sort by "year" and count your total music dataset and display the first 50

//Result: Total count is 1000000

//Reverse sort by "year"
q1a := SORT(MSDMusic, -['year']);

//display the first 50
CHOOSEN(q1a, 50);

//Count and display result
OUTPUT(COUNT(q1a), NAMED('Q1A'));

//*********************************************************************************
//*********************************************************************************
//Challenge: 
//Display first 50 songs by of year 2010 and then count the total 

//Result should have 9397 songs for 2010

//Filter for 2010 and display the first 50
OUTPUT(CHOOSEN(SORT(MSDMusic, 'year' = '2010'), 50), NAMED('Q1B'));

//Count total songs released in 2010:
OUTPUT(COUNT(SORT(MSDMusic, 'year' = '2010')), NAMED('Q1B_Count'));

//*********************************************************************************
//*********************************************************************************
//Challenge: 
//Count how many songs was produced by "Prince" in 1982

//Result should have 4 counts

//Filter ds for "Prince" AND 1982
q1c := SORT(MSDMusic, 'artist_name' = 'Prince' AND 'year' = '1982');
//Count and print total 
OUTPUT(q1c, NAMED('Q1C'));
OUTPUT(COUNT(q1c), NAMED('Q1C_Count'));

//*********************************************************************************
//*********************************************************************************
//Challenge: 
//Who sang "Into Temptation"?

// Result should have 3 records

//Filter for "Into Temptation"
q1d := SORT(MSDMusic, 'title' = 'Into Temptation');

//Display result 
OUTPUT(q1d, NAMED('Q1D'));

//*********************************************************************************
//*********************************************************************************
//Challenge: 
//Sort songs by Artist and song title, output the first 100

//Result: The first 10 records have no artist name, followed by "- PlusMinus"                                     

//Sort dataset by Artist, and Title
q1e := SORT(MSDMusic, 'artist_name', 'title');

//Output the first 100
OUTPUT(CHOOSEN(q1e, 100), NAMED('Q1E'));

//*********************************************************************************
//*********************************************************************************
//Challenge: 
//What is the hottest song by year in the Million Song Dataset?
//Sort Result by Year (filter out zero Year values)
q1f := SORT(MSDMusic, 'year' != '0');

//Result is 
OUTPUT(q1f, NAMED('Q1F'));
//Get the datasets maximum hotness value
maxHotness := MAX(q1f, 'song_hotness');

//Filter dataset for the maxHot value
q1fMax := SORT(q1f, 'song_hotness' = maxHotness);

//Display the result
OUTPUT(q1fMax, NAMED('Q1F_Max'));

//*********************************************************************************
//*********************************************************************************

//                                CATEGORY TWO

//*********************************************************************************
//*********************************************************************************
//Challenge: 
//Display all songs produced by the artist "Coldplay" AND has a 
//"Song Hotness" greater or equal to .75 ( >= .75 ) , SORT it by title.
//Count the total result

//Result has 47 records

//Get songs by defined conditions
coldplay := MSDMusic(artist_name = 'Coldplay' AND song_hotness >= .75);

//Sort the result
coldplaySorted := SORT(coldplay, 'title');

//Output the result
OUTPUT(coldplaySorted, NAMED('Q2A'));

//Count and output result 
OUTPUT(COUNT(coldplaySorted), NAMED('Q2A_Count'));

//*********************************************************************************
//*********************************************************************************
//Challenge: 
//Count all songs where "Duration" is between 200 AND 250 (inclusive) 
//AND "song_hotness" is not equal to 0 
//AND familarity > .9

//Result is 762 songs  

//Hint: (SongDuration BETWEEN 200 AND 250)

//Filter for required conditions
hotSongs := MSDMusic(duration BETWEEN 200 AND 250 AND song_hotness != 0 AND familiarity > .9);
//Count result
COUNT(hotSongs);                      
//Display result
OUTPUT(COUNT(hotSongs), NAMED('Q2B'));

//*********************************************************************************
//*********************************************************************************
//Challenge: 
//Create a new dataset which only has  "Title", "Artist_Name", "Release_Name" and "Year"
//Display the first 50

//Result should only have 4 columns. 

//Hint: Create your new RECORD layout and use TRANSFORM for new fields. 
//Use PROJECT, to loop through your music dataset

newLayout := RECORD
    STRING Title;
    STRING Artist_Name;
    STRING Release_Name;
    UNSIGNED Year;
END;

//Standalone Transform 
transformed := PROJECT(MSDMusic, TRANSFORM(newLayout,
    SELF.Title := LEFT.title,
    SELF.Artist_Name := LEFT.artist_name,
    SELF.Release_Name := LEFT.release_name,
    SELF.Year := LEFT.year
));

//PROJECT
q2c := PROJECT(transformed, TRANSFORM(newLayout, 
    SELF.Title := LEFT.Title, 
    SELF.Artist_Name := LEFT.Artist_Name, 
    SELF.Release_Name := LEFT.Release_Name, 
    SELF.Year := LEFT.Year
));

// Display result  
OUTPUT(CHOOSEN(q2c,50), NAMED('Q2C'));

//*********************************************************************************
//*********************************************************************************

//Challenge: 
//1- What’s the correlation between "song_hotness" AND "artist_hotness"
//2- What’s the correlation between "barsstartdev" AND "beatsstartdev"

correlationHotness := CORRELATION(MSDMusic, song_hotness, artist_hotness);
correlationStartdev := CORRELATION(MSDMusic, barsstartdev, beatsstartdev);
OUTPUT(correlationHotness, NAMED('Q2C_Hotness'));
OUTPUT(correlationStartdev, NAMED('Q2C_Startdev'));

//Result for hotness = 0.4706972681953097, StartDev = 0.8896342348554744



//*********************************************************************************
//*********************************************************************************

//                                CATEGORY THREE

//*********************************************************************************
//*********************************************************************************
//Challenge: 
//Create a new dataset which only has following conditions
//   *  Column named "Song" that has "Title" values 
//   *  Column named "Artist" that has "artist_name" values 
//   *  New BOOLEAN Column called isPopular, and it's TRUE is IF "song_hotness" is greater than .80
//   *  New BOOLEAN Column called "IsTooLoud" which is TRUE IF "Loudness" > 0
//Display the first 50

//Result should have 4 columns named "Song", "Artist", "isPopular", and "IsTooLoud"


//Hint: Create your new layout and use TRANSFORM for new fields. 
//      Use PROJECT, to loop through your music dataset

//Create the RECORD layout
layout := RECORD
    STRING Song;
    STRING Artist;
    BOOLEAN isPopular;
    BOOLEAN IsTooLoud;
END;

//Build your TRANSFORM

//Creating the PROJECT
q3a := PROJECT(MSDMusic, TRANSFORM(layout,
    SELF.Song := LEFT.title,
    SELF.Artist := LEFT.artist_name,
    SELF.isPopular := IF(LEFT.song_hotness > .80, TRUE, FALSE),
    SELF.IsTooLoud := IF(LEFT.loudness > 0, TRUE, FALSE)
));

//Display the result
OUTPUT(CHOOSEN(q3a, 50), NAMED('Q3A'));
                       
                                              
//*********************************************************************************
//*********************************************************************************
//Challenge: 
//Display number of songs per "Year" and count your total 

//Result has 2 col, Year and TotalSongs, count is 89

//Hint: All you need is a cross-tab TABLE 
yearSongs := TABLE(MSDMusic, 
    RECORD
        MSDMusic.year;
        INTEGER TotalSongs := COUNT(GROUP);
    END,
    year
);

//Display the  result      
OUTPUT(yearSongs, NAMED('Q3B'));
//Count and display total number of years counted
OUTPUT(COUNT(yearSongs), NAMED('Q3B_Count'));

//*********************************************************************************
//*********************************************************************************
// What Artist had the overall hottest songs between 2006-2007?
// Calculate average "song_hotness" per "Artist_name" for "Year" 2006 and 2007

// Hint: All you need is a TABLE, and see the TOPN function for your OUTPUT 

// Output the top ten results showing two columns, Artist_Name, and HotRate.

// Filter for year
filteredYears := MSDMusic(Year IN [2006, 2007]);
// Create a Cross-Tab TABLE:
avgHotness := TABLE(filteredYears, 
    RECORD
        STRING Artist_name := filteredYears.artist_name;
        REAL hotness := AVE(GROUP, filteredYears.song_hotness);
    END,
    Artist_name
);
// Display the top ten results with top "HotRate"      
topTenHotness := TOPN(avgHotness, 10, hotness, -1);
OUTPUT(topTenHotness, NAMED('Q3C'));