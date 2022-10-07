#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE TABLE games, teams;")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENTS WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != year ]]
    then
    #it's not the header row, proceed
    TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
    OPPONENTS_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENTS'")

    if [[ -z $TEAM_ID ]]
      then
      #insert new name

      INSERT_TEAM_ID=$($PSQL "INSERT INTO teams(name) VALUES ('$WINNER')")

      if [[ $INSERT_TEAM_ID == 'INSERT 0 1' ]]
        then
        echo Inserted into teams, $WINNER
      fi

    fi

    if [[ -z $OPPONENTS_ID ]]
      then
      #insert new name

      INSERT_OPPONENTS_ID=$($PSQL "INSERT INTO teams(name) VALUES ('$OPPONENTS')")

      if [[ $INSERT_OPPONENTS_ID == 'INSERT 0 1' ]]
        then
        echo Inserted into teams, $OPPONENTS
      fi

    fi

    TEAM_ID_Q=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
    OPPONENTS_ID_Q=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENTS'")
    #echo $TEAM_ID_Q
    echo $($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $TEAM_ID_Q, $OPPONENTS_ID_Q, $WINNER_GOALS, $OPPONENT_GOALS)")

  fi

done