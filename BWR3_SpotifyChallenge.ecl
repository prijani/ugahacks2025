﻿//#OPTION('obfuscateOutput', TRUE);
IMPORT $;
SpotMusic := $.File_Music.SpotDS;

//display the first 150 records

OUTPUT(CHOOSEN(SpotMusic, 150), NAMED('Raw_MusicDS'));


//*********************************************************************************
//*********************************************************************************

//                                CATEGORY ONE 

//*********************************************************************************
//*********************************************************************************

//Challenge: 
//Sort songs by genre and count the number of songs in your total music dataset 
 

//Sort by "genre" (See SORT function)
q1a := SORT(SpotMusic, 'genre');
//Display them: (See OUTPUT)
OUTPUT(q1a, NAMED('Q1A_SortedByGenre'));

//Count and display result (See COUNT)
//Result: Total count is 1159764:
OUTPUT(COUNT(q1a), NAMED('Q1A_TotalSongs'));

//*********************************************************************************
//*********************************************************************************

//Challenge: 
//Display songs by "garage" genre and then count the total 
//Filter for garage genre and OUTPUT them:
OUTPUT(SORT(SpotMusic, 'genre'), NAMED('Q1B_SortedByGenre'));

//Count total garage songs
OUTPUT(COUNT(SpotMusic), NAMED('Q1B_TotalGarageSongs'));
//Result should have 17123 records:


//*********************************************************************************
//*********************************************************************************

//Challenge: 
//Count how many songs was produced by "Prince" in 2001

//Filter ds for 'Prince' AND 2001
q1c := SORT(SpotMusic, 'Artist_name' = 'Prince' AND 'Year' = '2001');

//Count and output total - should be 35 
OUTPUT(COUNT(q1c), NAMED('Q1C'));


//*********************************************************************************
//*********************************************************************************

//Challenge: 
//Who sang "Temptation to Exist"?

// Result should have 1 record and the artist is "New York Dolls"

//Filter for "Temptation to Exist" (name is case sensitive)
q1d := SORT(SpotMusic, 'Track_Name' = 'Temptation to Exist');
//Display result 
OUTPUT(q1d, NAMED('Q1D'));

//*********************************************************************************
//*********************************************************************************

//Challenge: 
//Output songs sorted by Artist_name and track_name, respectively

//Result: First few rows should have Artist and Track as follows:
// !!! 	Californiyeah                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
// !!! 	Couldn't Have Known                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
// !!! 	Dancing Is The Best Revenge                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          
// !!! 	Dear Can   
// (Yes, there is a valid artist named "!!!")                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          


//Sort dataset by Artist_name, and track_name:
q1e := SORT(SpotMusic, 'Artist_name', 'Track_Name');

//Output here:
OUTPUT(q1e, NAMED('Q1E'));


//*********************************************************************************
//*********************************************************************************

//Challenge: 
//Find the MOST Popular song using "Popularity" field

//Get the most Popular value (Hint: use MAX)
maxq1f := MAX(SpotMusic, 'Popularity');

//Filter dataset for the mostPop value
q1f := SORT(SpotMusic, 'Popularity' = maxq1f);

//Display the result - should be "Flowers" by Miley Cyrus
OUTPUT(q1f, NAMED('Q1F'));


//*********************************************************************************
//*********************************************************************************

//                                CATEGORY TWO

//*********************************************************************************
//*********************************************************************************

//Challenge: 
//Display all games produced by "Coldplay" Artist AND has a 
//"Popularity" greater or equal to 75 ( >= 75 ) , SORT it by title.
//Count the total result

//Result has 9 records

//Get songs by defined conditions
conditionalq2a := SORT(SpotMusic, 'Artist_name' = 'Coldplay' AND 'Popularity' >= '75');

//Sort the result
q2a := SORT(conditionalq2a, 'Track_Name');

//Output the result
OUTPUT(q2a, NAMED('Q2A'));

//Count and output result 
OUTPUT(COUNT(q2a), NAMED('Q2A_Total'));

//*********************************************************************************
//*********************************************************************************

//Challenge: 
//Count all songs that whose "SongDuration" (duration_ms) is between 200000 AND 250000 AND "Speechiness" is above .75 
//Hint: (Duration_ms BETWEEN 200000 AND 250000)

//Filter for required conditions
filteredq2b := SpotMusic(Duration_ms BETWEEN 200000 AND 250000 AND Speechiness > 0.75);
sortedq2b := SORT(filteredq2b, Duration_ms);
//Count result (should be 2153):
q2b := COUNT(sortedq2b);

//Display result:
OUTPUT(q2b, NAMED('Q2B'));
//*********************************************************************************
//*********************************************************************************

//Challenge: 
//Create a new dataset which only has "Artist", "Title" and "Year"
//Output them

//Result should only have 3 columns. 

//Hint: Create your new layout and use TRANSFORM for new fields. 
//Use PROJECT, to loop through your music dataset

//Define RECORD here:
NewLayout := RECORD
    STRING Artist;
    STRING Title;
    INTEGER Year;
END;

//Standalone TRANSFORM Here:
NewTransform := PROJECT(SpotMusic, TRANSFORM(NewLayout,
    SELF.Artist := LEFT.Artist_name,
    SELF.Title := LEFT.Track_Name,
    SELF.Year := LEFT.Year
));

//PROJECT here:
NewDataSet := PROJECT(NewTransform, NewLayout);

//OUTPUT your PROJECT here:
OUTPUT(NewDataSet, NAMED('Q2C'));
      

//*********************************************************************************
//*******************************************************************************

//CORRELATION Challenge: 
//1- What’s the correlation between "Popularity" AND "Liveness"
correlationPopularityLiveness := CORRELATION(SpotMusic, Popularity, Liveness);

//2- What’s the correlation between "Loudness" AND "Energy"

correlationLayout := RECORD
    REAL4 Loudness;
    REAL Energy_Converted;
END;

convertedDataSet := PROJECT(SpotMusic, TRANSFORM(correlationLayout,
    SELF.Loudness := LEFT.Loudness,
    SELF.Energy_Converted := (REAL)LEFT.Energy
));

q2d := PROJECT(convertedDataSet, TRANSFORM(correlationLayout, 
    SELF.Loudness := LEFT.Loudness, 
    SELF.Energy_Converted := LEFT.Energy_Converted
));

correlationLoudnessEnergy := CORRELATION(convertedDataSet, Loudness, Energy_Converted);

//Result for liveness = -0.05696845812100079, Energy = -0.03441566150625201
OUTPUT(correlationPopularityLiveness, NAMED('Q2D_PopularityLiveness'));
OUTPUT(correlationLoudnessEnergy, NAMED('Q2D_LoudnessEnergy'));


//*********************************************************************************
//*********************************************************************************

//                                CATEGORY THREE

//*********************************************************************************
//*********************************************************************************

//Challenge: 
//Create a new dataset which only has following conditions
//   *  STRING Column(field) named "Song" that has "Track_Name" values
//   *  STRING Column(field) named "Artist" that has "Artist_name" values
//   *  New BOOLEAN Column called isPopular, and it's TRUE is IF "Popularity" is greater than 80
//   *  New DECIMAL3_2 Column called "Funkiness" which is  "Energy" + "Danceability"
//Display the output

//Result should have 4 columns called "Song", "Artist", "isPopular", and "Funkiness"


//Hint: Create your new layout and use TRANSFORM for new fields. 
//      Use PROJECT, to loop through your music dataset

//Define the RECORD layout
q3aLayout := RECORD
    STRING Song;
    STRING Artist;
    BOOLEAN isPopular;
    DECIMAL3_2 Funkiness;
END;

//Build TRANSFORM
transformq3a := PROJECT(SpotMusic, TRANSFORM(q3aLayout,
        SELF.Song := LEFT.Track_Name,
        SELF.Artist := LEFT.Artist_Name,
        SELF.isPopular := LEFT.Popularity > 80,
        SELF.Funkiness := (DECIMAL3_2)LEFT.Energy + LEFT.Danceability
));

//Project here:
q3a := PROJECT(transformq3a, q3aLayout);

//Display result here:
OUTPUT(q3a, NAMED('Q3A'));

                       
                                              
//*********************************************************************************
//*********************************************************************************

//Challenge: 
//Display number of songs for each "Genre", output and count your total 

//Result has 2 col, Genre and TotalSongs, count is 82

//Hint: All you need is a TABLE - this is a CrossTab report 
genreCount := TABLE(SpotMusic, 
    RECORD
        SpotMusic.genre;
        INTEGER TotalSongs := COUNT(GROUP);
    END,
    genre
);

//Printing the first 50 records of the result      
OUTPUT(CHOOSEN(genreCount, 50), NAMED('Q3B_GenreCount'));

//Count and display total - there should be 82 unique genres
OUTPUT(COUNT(genreCount), NAMED('Q3B_TotalGenres'));

//Bonus: What is the top genre?
topGenre := SORT(genreCount, -TotalSongs)[1];
OUTPUT(topGenre, NAMED('Q3B_TopGenre'));

//*********************************************************************************
//*********************************************************************************
//Calculate the average "Danceability" per "Artist" for "Year" 2023

//Hint: All you need is a TABLE 

//Result has 37600 records with two col, Artist, and DancableRate.

//Filter for year 2023
filtered2023 := SpotMusic(Year = 2023);

// Create a TABLE to calculate the average "Danceability" per "Artist"
avgDanceability := TABLE(filtered2023, 
    RECORD
        filtered2023.Artist_name;
        REAL8 DanceableRate := AVE(GROUP, filtered2023.Danceability);
    END,
    Artist_name
);

// Output the result
OUTPUT(avgDanceability, NAMED('Q3C'));




