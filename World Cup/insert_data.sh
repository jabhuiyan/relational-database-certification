#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE teams, games;")

# insert teams
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WIN_G OPP_G
do
    if [[ $WINNER != "winner" && $OPPONENT != "opponent" ]]
    then
        WINR_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER';")
        # if not found
        if [[ -z $WINR_ID ]]
        then
            WINR_INSERT=$($PSQL "INSERT INTO teams (name) VALUES ('$WINNER');")
            if [[ $WINR_INSERT == "INSERT 0 1" ]]
            then
                echo "Inserted into teams, $WINNER"
            fi
        fi

        OPPN_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT';")
        # if not found
        if [[ -z $OPPN_ID ]]
        then
            OPPN_INSERT=$($PSQL "INSERT INTO teams (name) VALUES ('$OPPONENT');")
            if [[ $OPPN_INSERT == "INSERT 0 1" ]]
            then
                echo "Inserted into teams, $OPPONENT"
            fi
        fi
    fi
done

# insert games
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WIN_G OPP_G
do
    if [[ $YEAR != "year" ]]
    then
        WINR_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER';")
        OPPN_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT';")

        INSERT_GAMES=$($PSQL "INSERT INTO games (year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ($YEAR, '$ROUND', $WINR_ID, $OPPN_ID, $WIN_G, $OPP_G);")
        if [[ $INSERT_GAMES == "INSERT 0 1" ]]
        then
            echo Inserted into games, $YEAR, $ROUND, $WINR_ID, $OPPN_ID, $WIN_G, $OPP_G
        fi
    fi
done
