-- __/\\\\\\\\\\\__/\\\\\_____/\\\__/\\\\\\\\\\\\\\\_____/\\\\\_________/\\\\\\\\\_________/\\\\\\\________/\\\\\\\________/\\\\\\\________/\\\\\\\\\\________________/\\\\\\\\\_______/\\\\\\\\\_____        
--  _\/////\\\///__\/\\\\\\___\/\\\_\/\\\///////////____/\\\///\\\_____/\\\///////\\\_____/\\\/////\\\____/\\\/////\\\____/\\\/////\\\____/\\\///////\\\_____________/\\\\\\\\\\\\\___/\\\///////\\\___       
--   _____\/\\\_____\/\\\/\\\__\/\\\_\/\\\_____________/\\\/__\///\\\__\///______\//\\\___/\\\____\//\\\__/\\\____\//\\\__/\\\____\//\\\__\///______/\\\_____________/\\\/////////\\\_\///______\//\\\__      
--    _____\/\\\_____\/\\\//\\\_\/\\\_\/\\\\\\\\\\\____/\\\______\//\\\___________/\\\/___\/\\\_____\/\\\_\/\\\_____\/\\\_\/\\\_____\/\\\_________/\\\//_____________\/\\\_______\/\\\___________/\\\/___     
--     _____\/\\\_____\/\\\\//\\\\/\\\_\/\\\///////____\/\\\_______\/\\\________/\\\//_____\/\\\_____\/\\\_\/\\\_____\/\\\_\/\\\_____\/\\\________\////\\\____________\/\\\\\\\\\\\\\\\________/\\\//_____    
--      _____\/\\\_____\/\\\_\//\\\/\\\_\/\\\___________\//\\\______/\\\______/\\\//________\/\\\_____\/\\\_\/\\\_____\/\\\_\/\\\_____\/\\\___________\//\\\___________\/\\\/////////\\\_____/\\\//________   
--       _____\/\\\_____\/\\\__\//\\\\\\_\/\\\____________\///\\\__/\\\______/\\\/___________\//\\\____/\\\__\//\\\____/\\\__\//\\\____/\\\___/\\\______/\\\____________\/\\\_______\/\\\___/\\\/___________  
--        __/\\\\\\\\\\\_\/\\\___\//\\\\\_\/\\\______________\///\\\\\/______/\\\\\\\\\\\\\\\__\///\\\\\\\/____\///\\\\\\\/____\///\\\\\\\/___\///\\\\\\\\\/_____________\/\\\_______\/\\\__/\\\\\\\\\\\\\\\_ 
--         _\///////////__\///_____\/////__\///_________________\/////_______\///////////////_____\///////________\///////________\///////_______\/////////_______________\///________\///__\///////////////__

-- Your Name: Harshita Soni
-- Your Student Number: 1138784
-- By submitting, you declare that this work was completed entirely by yourself.

-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q1
SELECT COUNT(*) AS speciesCount    
  FROM Species
 WHERE description LIKE '%this%';

-- END Q1
-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q2
  SELECT username, 
         SUM(power) AS totalPhonemonPower    
    FROM Player 
			INNER JOIN 
	     Phonemon 
		 ON Player.id = Phonemon.player
GROUP BY username
  HAVING username = 'Cook' OR username = 'Hughes';

-- END Q2
-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q3
  SELECT title, 
         COUNT(Player.id) AS numberOfPlayers      
    FROM Team 
			INNER JOIN 
	     Player 
		 ON Team.id = Player.team
GROUP BY Team.id
ORDER BY numberOfPlayers DESC;

-- END Q3
-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q4
SELECT Species.id as idSpecies, 
       Species.title as title    
  FROM Species 
		  INNER JOIN 
	   Type
	   ON Species.type1=Type.id OR Species.type2=Type.id
 WHERE Type.title like '%grass%';

-- END Q4
-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q5
SELECT id AS idPlayer, 
       username     
  FROM Player 
 WHERE id NOT IN (SELECT Purchase.player 
					FROM Purchase 
							INNER JOIN 
						 Item
						 ON Purchase.item = Item.id
				   WHERE Item.type='F');

-- END Q5
-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q6
  SELECT Player.level, 
         SUM(amount) AS totalAmountSpentByAllPlayersAtLevel    
    FROM Player 
			INNER JOIN 
			(SELECT SUM(Item.price * Purchase.quantity) AS amount, 
					Purchase.player 
			   FROM Purchase 
						INNER JOIN 
					Item 
					ON Purchase.item = Item.id
		   GROUP BY Purchase.player) AS PlayerAmount
	  ON Player.id = PlayerAmount.player
GROUP BY Player.level
ORDER BY totalAmountSpentByAllPlayersAtLevel DESC; 

-- END Q6
-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q7
  SELECT Purchase.item, 
		 Item.title, 
		 SUM(Purchase.quantity) AS numTimesPurchased     
	FROM Item 
			INNER JOIN 
		 Purchase
	     ON Item.id = Purchase.item
GROUP BY Purchase.item
  HAVING numTimesPurchased = (SELECT SUM(Purchase.quantity)  
								FROM Purchase
							GROUP BY Purchase.item
							ORDER BY SUM(Purchase.quantity) DESC
							   LIMIT 1);
               
-- END Q7
-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q8
SELECT Purchase.player AS PlayerID, 
	   Player.username, 
       ( SELECT COUNT(DISTINCT Item.id) 
		   FROM Purchase 
			 	  INNER JOIN 
			    Item
			    ON Purchase.item = Item.id
		  WHERE Item.type='F' AND Purchase.player = PlayerID ) AS numberDistinctFoodItemsPurchased     
	FROM Player 
			INNER JOIN 
		 Purchase
	     ON Player.id = Purchase.player
GROUP BY Purchase.player
  HAVING numberDistinctFoodItemsPurchased = (SELECT COUNT(*) FROM Food);

-- END Q8
-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q9
  SELECT COUNT(*) AS numberOfPhonemonPairs,
	     ROUND(SQRT(POWER((P1.latitude - P2.latitude), 2) + POWER((P1.longitude - P2.longitude), 2))*100, 2) as distanceX
    FROM Phonemon P1
			CROSS JOIN
		 Phonemon P2
		 ON P1.id != P2.id AND P1.id < P2.id
GROUP BY distanceX
  HAVING distanceX = (SELECT MIN(ROUND(SQRT(POWER((P1.latitude - P2.latitude), 2) + POWER((P1.longitude - P2.longitude), 2))*100, 2))
						FROM Phonemon P1
								CROSS JOIN
							 Phonemon P2
							 ON P1.id < P2.id);

-- END Q9
-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q10
  SELECT Player.username, 
	     Type.title
	FROM Player 
			INNER JOIN 
		 Phonemon
		 ON Player.id = Phonemon.player
			INNER JOIN Species
		 ON Phonemon.species = Species.id
			INNER JOIN Type
		 ON Species.type1=Type.id OR Species.type2=Type.id
GROUP BY Type.id, Player.username
  HAVING (Type.id, COUNT(DISTINCT Species.id)) IN (SELECT Type.id,
														  COUNT(Species.id)
													 FROM Species 
															INNER JOIN 
														  Type
														  ON Species.type1=Type.id OR Species.type2=Type.id
												 GROUP BY Type.id);

-- END Q10
-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- END OF ASSIGNMENT Do not write below this line