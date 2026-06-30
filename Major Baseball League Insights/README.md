
# Major League Baseball (MLB) Data Analysis

## Project Overview
This folder contains my solution to the final project assigned by the **Advanced SQL Querying** course offered by **Maven Analytics**. The project utilizes a historical Major League Baseball dataset to extract insights regarding players’ attributes, careers, colleges attended, and team salary expenditures.

This goal is this project is to consolidate my SQL skills and practice building a simple data workflow, moving from raw data to a final Python-based visualization.


##  My Contributions
While the course provided the dataset and a list of tasks, I wanted to add some personal contributions: Here is what I did beyond the guided instructions:
* **Cleaner SQL with Views:** Instead of repeatedly writing Common Table Expressions (CTEs), I created two SQL Views (`V_players_careers`, `V_player_teams`). This made the code much cleaner, modular, and easier to read.
* **Python & SQLAlchemy Integration:** I further processed the data out of SQL. I wrote a Python script using `SQLAlchemy` and `pandas` to query the database directly.
* **Static Dashboard:** The original project asked for tabular outputs. To better summarize the key results, I used `matplotlib` and `seaborn` to combine the most relevant queries into a clean, single-page dashboard showing the main trends (e.g., player physical evolution, cumulative team spending).


## Dashboard Highlights
The final Python script generates a static dashboard visualizing:
1. The physical evolution (height and weight) of players over the decades.
2. The number of collegiate institutions producing MLB talents over time.
3. The cumulative salary expenditure of MLB teams, showing the league's financial growth.
4. Top rankings for talent-producing universities and the highest-spending franchises.

## Technical Implementation
* **Database:** PostgreSQL
* **Programming:** Python 3.12
* **Libraries:** Pandas, SQLAlchemy, Matplotlib, Seaborn, Python-dotenv

