

/*--------------------------------------Mini Project Report | DBMS (DBMS-I + DBMS-II) - GROUP 5 --------------------------------------*/


-- NOTE :- The insights based on the results  from the queries is mentioned after each query 



use ipl;

-- 1.	Show the percentage of wins of each bidder in the order of highest to lowest percentage.

SELECT a.bidder_id,
       a.bid_status,
       b.no_of_bids,
       CASE
         WHEN a.bid_status = 'Won' THEN Count(a.bid_status)
       END AS 'No_of_Wins',
       CASE
         WHEN a.bid_status = 'Won' THEN Round(
         ( Count(a.bid_status) / b.no_of_bids ) * 100, 2)
       END AS "PERCENTAGE"
FROM   ipl_bidding_details a
       INNER JOIN ipl_bidder_points b using(bidder_id)
WHERE  a.bid_status = 'Won'
GROUP  BY a.bidder_id,
          a.bid_status,
          b.no_of_bids; 



 -- INSIGHT
 
/*
 The SQL query calculates the number of wins and win percentage for bidders who have won bids in the IPL bidding data.
 This insight helps identify top-performing bidders based on their success in securing bids, providing valuable
 information for stakeholders to optimize the bidding process and assess bidder performance. */
    
    
    
    

-- 2 Display the number of matches conducted at each stadium with stadium name, city from the database.

SELECT a.stadium_name,
       a.city,
       Count(b.match_id) AS "No_of_matches"
FROM   ipl_stadium a
       INNER JOIN ipl_match_schedule b using(stadium_id)
GROUP  BY a.stadium_name,
          a.city; 


/*
INSIGHT 

The query enables us to understand the distribution of IPL matches across various stadiums. It provides valuable data on the number
 of matches held at each stadium, allowing us to identify venues with higher match frequencies. This information is crucial for IPL
 organizers, teams, and fans, as it helps assess the popularity and utilization of different stadiums during the tournament. 
 By analyzing the number of matches conducted at each stadium, IPL organizers can ensure proper venue management, 
 optimize match schedules, and provide better facilities for players and spectators.  */


-- 3.	In a given stadium, what is the percentage of wins by a team which has won the toss?

	SELECT stad.stadium_id,
       stad.stadium_name,
       (SELECT Count(*)
        FROM   ipl_match mat
               INNER JOIN ipl_match_schedule schd
                       ON mat.match_id = schd.match_id
        WHERE  schd.stadium_id = stad.stadium_id
               AND ( toss_winner = match_winner )) / (SELECT Count(*)
                                                      FROM
       ipl_match_schedule schd
                                                      WHERE
       schd.stadium_id = stad.stadium_id) * 100 AS 'Toss and Match Wins %'
FROM   ipl_stadium stad; 


/*
Insight:

The query provides valuable insights into the relationship between winning the toss and winning the match at each stadium.
 By calculating the percentage of toss and match wins, it allows us to identify the stadiums where winning the toss has a 
 higher impact on match outcomes. This information can be valuable for teams and captains, as it may influence their 
 decision-making during the toss phase. It also provides an indication of the significance of toss wins in contributing
 to match victories at specific venues within the IPL.
*/






-- 4 Show the total bids along with bid team and team name.  

	SELECT c.team_name,
       b.bid_team,
       Count(a.no_of_bids) AS total_bids
FROM   ipl_bidder_points a
       JOIN ipl_bidding_details b using(bidder_id)
       INNER JOIN ipl_team c
               ON c.team_id = b.bid_team
GROUP  BY c.team_name,
          b.bid_team
ORDER  BY b.bid_team; 
    
    
/*
INSIGHT 

The provided SQL query offers valuable insights into the IPL bidding process. It shows the total number of bids made by
 each IPL team. By combining data from the 'ipl_bidder_points', 'ipl_bidding_details', and 'ipl_team' tables, the query
 reveals the bidding activity .This information is essential for assessing the
 engagement and competitiveness of different teams during IPL matches. 
*/
    
    


-- 5.	Show the team id who won the match as per the win details.

SELECT MATCH_WINNER,WIN_DETAILS
FROM ipl_match
GROUP BY MATCH_WINNER,WIN_DETAILS;

/*
INSIGHT 

The query provides the team IDs of the match winners along with their win details. By grouping the results based on win details,
 it allows us to identify the different scenarios or reasons mentioned in the win details column when a team emerged victorious. 
*/


-- 6. Display total matches played, total matches won and total matches lost by team along with its team name.

SELECT b.team_name,
       b.team_id,
       Sum(a.matches_played),
       Sum(matches_won),
       ( Sum(a.matches_played) - Sum(matches_won) ) AS LOST_MATCHES
FROM   ipl_team_standings a
       JOIN ipl_team b
         ON a.team_id = b.team_id
GROUP  BY b.team_id,
          b.team_name; 

/*
INSIGHT 

The query provides comprehensive statistics on the performance of each team in the IPL. It displays the total number of matches played
, total matches won, and total matches lost, allowing stakeholders to assess team performance throughout the tournament.
 By understanding the number of matches won and lost, teams, analysts, and fans can gauge a team's overall competitiveness
 and success rate. This data is crucial for team management to evaluate their strategies, player selections, and overall performance. 
*/


-- 7 Display the bowlers for Mumbai Indians team.

SELECT b.player_role,
       a.team_name,
       b.player_id
FROM   ipl_team a
       JOIN ipl_team_players b using(team_id)
WHERE  b.player_role = 'Bowler'
       AND a.team_name = 'Mumbai Indians'; 

/*

INSIGHT 

The query provides a list of bowlers who are part of the "Mumbai Indians" team. By focusing on players with the role of "Bowler," the
 query helps stakeholders and fans identify the key players responsible for the team's bowling performance. Bowlers play a crucial
 role in shaping the team's success in matches, and this information allows team management and cricket enthusiasts to closely
 monitor and analyze the performance of the bowling unit within the "Mumbai Indians" team.
*/






-- 8 How many all-rounders are there in each team, Display the teams with more than 4 
-- all-rounder in descending order.

SELECT b.team_id,
       b.player_role,
       Count(b.player_role),
       a.team_name,
       b.player_id
FROM   ipl_team a
       JOIN ipl_team_players b 
       using(team_id)
WHERE  b.player_role = 'All-Rounder'
GROUP  BY b.team_id,b.player_role,
       a.team_name,
       b.player_id
HAVING Count(b.player_role) > 4
ORDER  BY Count(b.player_role) DESC; 




select
	play.TEAM_id,
	TEAM_NAME,
	count(*) as `No.of All-Rounders`
from
	ipl_team_players play
join ipl_team tea 
on
	play.TEAM_ID = tea.team_id
where
	PLAYER_ROLE = 'All-Rounder'
group by
	play.TEAM_id
having
	`No.of All-Rounders`> 4
order by
	`No.of All-Rounders` desc;



/*

INSIGHT 

The query provides a list of teams that have more than 4 all-rounders in their squad. All-rounders are versatile players who
 can contribute both with the bat and ball, and having a significant number of all-rounders in a team can offer strategic
 advantages. Teams with multiple all-rounders can adapt to various match situations and provide balance to the squad,
 making them a formidable force in the IPL. By displaying the teams with the most all-rounders in descending order,
 the query allows stakeholders, fans, and team management to identify the teams with a strong all-rounder contingent.
*/




-- 9 Write a query to get the total bidders points for each bidding status of those bidders 
# who bid on CSK when it won the match in M. Chinnaswamy Stadium bidding year-wise.
 
 # Note the total bidders’ points in descending order and the year is bidding year.
# Display columns: bidding status, bid date as year, total bidder’s points

SELECT a.bidder_id,
       b.total_points,
       ( Year(bid_date) ) AS year,
       a.bid_status,
       c.team_name,
       e.stadium_name
FROM   ipl_bidding_details a
       JOIN ipl_bidder_points b using(bidder_id)
       JOIN ipl_team c
         ON c.team_id = a.bid_team
       JOIN ipl_match_schedule d using(schedule_id)
       JOIN ipl_stadium e using(stadium_id)
WHERE  a.bid_status = 'Won'
       AND team_name = 'Chennai Super Kings'
       AND e.stadium_name LIKE '%M. Chinnaswamy Stadium%'
ORDER  BY b.total_points DESC; 



/*
Insight:

The query provides valuable insights into the total bidders' points for each bidding status (specifically 'Won') of bidders
 who bid on "Chennai Super Kings" when it won the match in the "M. Chinnaswamy Stadium" bidding year-wise. By sorting the
 results in descending order based on total bidders' points, it allows stakeholders to identify the most successful bidders
 based on their performance during CSK's matches at the M. Chinnaswamy Stadium. The output includes information about the
 bidder ID, bid date (year), total points, bidding status, CSK's team name, and the stadium name where the matches took place. 
*/


#10.	Extract the Bowlers and All Rounders those are in the 5 highest number of wickets.
-- Note 
-- 1. use the performance_dtls column from ipl_player to get the total number of wickets
--  2. Do not use the limit method because it might not give appropriate results when players have the same number of wickets
-- 3.	Do not use joins in any cases.
-- 4.	Display the following columns teamn_name, player_name, and player_role.



SELECT team_name,
       player_name,
       player_role
FROM   (
                SELECT   player_role,
                         team_name,
                         ipl_player.player_id,
                         player_name,
                         dense_rank() OVER( ORDER BY cast(trim(both ' ' FROM substring_index(substring_index(performance_dtls, 'Dot', 1), 'Wkt-',-1)) AS signed int) DESC ) AS wicket_rank
                FROM     ipl_player,
                         ipl_team_players,
                         ipl_team
                WHERE    ipl_player.player_id = ipl_team_players.player_id
                AND      ipl_team.team_id = ipl_team_players.team_id
                AND      player_role IN ('Bowler',
                                         'All-Rounder') ) derived_table
WHERE  wicket_rank <= 5;
  
  
  /*
  Insight 
  
  The query provides valuable information about the top 5 bowlers and all-rounders with the highest number of wickets in the IPL.
  By using the DENSE_RANK() function, it ensures that players with the same number of wickets are appropriately ranked,
  preventing any potential discrepancies in the results. The output includes columns for team name, player name, and player role,
  allowing stakeholders to identify the top-performing bowlers and all-rounders in the league.
  */
   
  


# 11.	show the percentage of toss wins of each bidder and display the results in descending order based on the percentage

SELECT bidder_id,
       bidder_name,
       COUNT(IF(( mat.team_id1 = bdg.bid_team
                  AND mat.toss_winner = 1 )
                 OR ( mat.team_id2 = bdg.bid_team
                      AND mat.toss_winner = 2 ), 1, NULL)) / COUNT(*) * 100 AS
       Toss_percentage
FROM   ipl_match mat
       JOIN ipl_match_schedule ms USING(match_id)
       INNER JOIN ipl_bidding_details bdg USING(schedule_id)
       INNER JOIN ipl_bidder_details USING(bidder_id)
GROUP  BY bidder_id,
          bidder_name
ORDER  BY toss_percentage desc; 

/*
Insight 

The query provides valuable insights into the success rate of each bidder in winning the toss during IPL matches.
 By calculating the toss win percentage, it allows stakeholders to identify bidders with a higher tendency to win tosses. 
 his information can be used to assess bidder strategies, evaluate the impact of winning the toss on match outcomes,
 and potentially influence bidding strategies during future IPL auctions.
*/


#12.	find the IPL season which has min duration and max duration.

-- Output columns should be like the below:
--  Tournment_ID, Tourment_name, Duration column, Duration

WITH temp_table
     AS (SELECT tournmt_id,
                tournmt_name,
                Datediff(to_date, from_date) AS duration,
                CASE
                  WHEN Datediff(to_date, from_date) = (SELECT
                       Max(Datediff(to_date,
                           from_date))
                                                       FROM   ipl_tournament)
                THEN
                  "max_duration"
                  WHEN Datediff(to_date, from_date) = (SELECT
                       Min(Datediff(to_date,
                           from_date))
                                                       FROM   ipl_tournament)
                THEN
                  "min_duration"
                END                          AS Duration_column
         FROM   ipl_tournament)
SELECT *
FROM   temp_table
WHERE  duration_column IS NOT NULL; 


/*
Insight 

The query enables us to identify the IPL seasons with the shortest and longest durations. By calculating the duration
 and categorizing each season as either "MAX_DURATION" or "MIN_DURATION," it allows stakeholders to understand the 
 varying lengths of different IPL tournaments. This information can be valuable for analyzing the scheduling and 
 organization of IPL events over the years. It may also offer insights into the popularity and viewership trends
 during different seasons, as the tournament's duration can influence viewers' engagement and interest. 
*/


-- 13.	Write a query to display to calculate the total points month-wise for the 2017 bid year.
-- sort the results based on total points in descending order and month-wise in ascending order.

-- Note: Display the following columns:
-- 1.	Bidder ID, 2. Bidder Name, 3. bid date as Year, 4. bid date as Month, 5. Total points
-- Only use joins for the above query queries.

SELECT DISTINCT a.bidder_id,
                c.bidder_name,
                Month(bid_date),
                Year(bid_date),
                total_points
FROM   ipl_bidder_points a
       JOIN ipl_bidding_details b using(bidder_id)
       JOIN ipl_bidder_details c using(bidder_id)
WHERE  Year(bid_date) = 2017
ORDER  BY total_points DESC,
          Month(bid_date) ASC; 

/*
Insight 

The query provides valuable insights into the performance of bidders during the 2017 bid year. By calculating the total
 points for each bidder month-wise, it allows stakeholders to analyze bidder activity and success rates throughout the year.
 Sorting the results based on total points helps identify top-performing bidders, while the month-wise arrangement provides
 a chronological view of their performance over the year. This information can be used to recognize consistent and high-performing
 bidders and evaluate their strategies and decision-making during the IPL auction process. 
*/



# 14.	Write a query for the above question using sub queries by having the same constraints as the above question.

SELECT bidder_id,
       (SELECT bidder_name
        FROM   ipl_bidder_details
        WHERE  ipl_bidder_details.bidder_id = ipl_bidding_details.bidder_id) AS
       bidder_name,
       Year(bid_date)                                                        AS
       `year`,
       Monthname(bid_date)                                                   AS
       `month`,
       (SELECT total_points
        FROM   ipl_bidder_points
        WHERE  ipl_bidder_points.bidder_id = ipl_bidding_details.bidder_id)  AS
       total_points
FROM   ipl_bidding_details
WHERE  Year(bid_date) = 2017
GROUP  BY bidder_id,
          bidder_name,
          year,
          month,
          total_points
ORDER  BY total_points DESC; 

/*
Insight 

The query yields the same insights as the previous question. By employing subqueries, it retrieves the bidder name and
 total points for each bidder ID, ensuring data accuracy and consistency. The month-wise calculation provides a 
 comprehensive view of the bidder's performance throughout the year, enabling stakeholders to evaluate their success 
 and engagement during the 2017 bid year. The sorting based on total points highlights top-performing bidders, contributing
 to a better understanding of bidder activity and performance during the specified period. This data-driven approach 
 helps in assessing bidder strategies, making informed decisions, and planning for future IPL auctions effectively.
*/



/*15. Write a query to get the top 3 and bottom 3 bidders based on the total bidding points for the 2018 bidding year.
Output columns should be:
like:
Bidder Id, Ranks (optional), Total points, Highest_3_Bidders --> columns contains name of bidder, Lowest_3_Bidders  -->
 columns contains name of bidder;**/

-- Tables Used 
-- ipl_bidder_points; 
-- ipl_bidder_details;

SELECT *
FROM   (SELECT pts.bidder_id,
               pts.total_points,
               Dense_rank()
                 OVER(
                   ORDER BY pts.total_points DESC) AS Ranks,
               bdr.bidder_name,
               'Highest_3_Bidders'                 AS 'Highest/Lowest_3_Bidders'
        FROM   ipl_bidder_points pts
               INNER JOIN ipl_bidder_details bdr
                       ON pts.bidder_id = bdr.bidder_id) temp
WHERE  ranks < 4
UNION ALL
(SELECT *
 FROM   (SELECT pts.bidder_id,
                pts.total_points,
                Rank()
                  OVER(
                    ORDER BY pts.total_points ) AS Ranks2,
                bdr.bidder_name,
                'Lowest_3_Bidders'
         FROM   ipl_bidder_points pts
                INNER JOIN ipl_bidder_details bdr
                        ON pts.bidder_id = bdr.bidder_id)temp2
 WHERE  ranks2 < 4); 


/*
Insight 

The query provides valuable insights into the top-performing and least-performing bidders based on their total
 bidding points during the 2018 bidding year. By calculating the ranks and combining the results using the UNION ALL
 operator, it offers a comprehensive view of bidder performance. The output includes bidder IDs, total points, and 
 bidder names for the top 3 and bottom 3 bidders, making it easy to identify key performers and areas for improvement
 . This information can be used by stakeholders, such as IPL organizers and team management, to assess bidder activity,
 competitiveness, and success during the bidding process.
*/




-- 16. Create two tables called Student_details and Student_details_backup.

-- Table 1: Attributes 		
-- Student id, Student name, mail id, mobile no.	

-- Table 2:  Attributes 
-- Student id, student name, mail id, mobile no.

-- Feel free to add more columns the above one is just an example schema.
-- Assume you are working in an Ed-tech company namely Great Learning where 
-- you will be inserting and modifying the details of the students in the Student details table. 
-- Every time the students changed their details like mobile number, You need to update their details 
-- in the student details table.  Here is one thing you should ensure whenever the new students' details come, 
-- you should also store them in the Student backup table so that if you modify the details in the student details table, 
-- you will be having the old details safely.
-- You need not insert the records separately into both tables rather Create a trigger in such a way that It should insert 
-- the details into the Student back table when you inserted the student details into the student table automatically
--  * 
--  * */

-- Create Student_details table
CREATE TABLE Student_details (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(100),
    mail_id VARCHAR(100),
    mobile_no VARCHAR(15)
);

-- Create Student_details_backup table
CREATE TABLE Student_details_backup (
    backup_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    student_name VARCHAR(100),
    mail_id VARCHAR(100),
    mobile_no VARCHAR(15),
    backup_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create Trigger for inserting into backup table on insert in main table
DELIMITER //
CREATE TRIGGER tr_StudentDetailsBackup AFTER INSERT ON Student_details 
FOR EACH ROW 
BEGIN
  INSERT INTO Student_details_backup (student_id, student_name, mail_id, mobile_no) 
  VALUES (NEW.student_id, NEW.student_name, NEW.mail_id, NEW.mobile_no);
END;
//




/* 

Insight

The SQL script presented above implements a data model and trigger to address the requirements of an Ed-tech company
 called "Great Learning." The data model consists of two tables: "Student_details" and "Student_details_backup."

The "Student_details" table serves as the primary repository for current student details, featuring attributes
 like student_id, student_name, mail_id, and mobile_no. This table is designed to store up-to-date information about enrolled students in the Ed-tech platform.

On the other hand, the "Student_details_backup" table acts as a historical records repository, capturing
 the previous states of student details. It mirrors the structure of the "Student_details" table,
 incorporating attributes such as student_id, student_name, mail_id, and mobile_no, in addition to 
 "backup_id," which is an auto-incrementing primary key, and "backup_timestamp," a timestamp indicating when the backup entry was created.
*/



