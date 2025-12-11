import os
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

# Set Seaborn style
sns.set(style="whitegrid")

# ===============================
# 0. Create plots directory
# ===============================
plots_dir = '/home/prachanda/npl-player-insights-2024/plots'
os.makedirs(plots_dir, exist_ok=True)

# ===============================
# 1. Load CSV files
# ===============================
total_players = pd.read_csv('tmp/total_players.csv')
total_teams = pd.read_csv('tmp/total_teams.csv')
type_players = pd.read_csv('tmp/type_players.csv')
team_total_spend = pd.read_csv('tmp/team_total_spend.csv')
team_avg_per_player = pd.read_csv('tmp/team_avg_per_player.csv')
top20_players = pd.read_csv('tmp/top20_players.csv')
role_salary = pd.read_csv('tmp/role_salary.csv')
salary_tiers = pd.read_csv('tmp/salary_tiers.csv')
player_team_pct = pd.read_csv('tmp/player_team_pct.csv')

# Fix column names (PostgreSQL often exports lowercase)
type_players.columns = [c.lower() for c in type_players.columns]
team_total_spend.columns = [c.lower() for c in team_total_spend.columns]
team_avg_per_player.columns = [c.lower() for c in team_avg_per_player.columns]
top20_players.columns = [c.lower() for c in top20_players.columns]
role_salary.columns = [c.lower() for c in role_salary.columns]
salary_tiers.columns = [c.lower() for c in salary_tiers.columns]
player_team_pct.columns = [c.lower() for c in player_team_pct.columns]

# ===============================
# 2. General Overview Plots
# ===============================

# Domestic vs Overseas Players
plt.figure(figsize=(6,4))
sns.barplot(data=type_players, x='type', y='player_count', palette='Set2')
plt.title('Domestic vs Overseas Players')
plt.ylabel('Number of Players')
plt.xlabel('Type')
plt.tight_layout()
plt.savefig(os.path.join(plots_dir, 'type_players.png'))
plt.show()

# ===============================
# 3. Team-wise Analysis Plots
# ===============================

# Total spend per team
plt.figure(figsize=(10,6))
sns.barplot(data=team_total_spend, x='team', y='total_spend_lakh', palette='coolwarm')
plt.title('Total Spend per Team (in Lakh)')
plt.xticks(rotation=45)
plt.ylabel('Total Spend (Lakh)')
plt.xlabel('Team')
plt.tight_layout()
plt.savefig(os.path.join(plots_dir, 'team_total_spend.png'))
plt.show()

# Average spend per player by team
plt.figure(figsize=(10,6))
sns.barplot(data=team_avg_per_player, x='team', y='avg_per_player', palette='viridis')
plt.title('Average Spend per Player by Team (in Lakh)')
plt.xticks(rotation=45)
plt.ylabel('Average Spend (Lakh)')
plt.xlabel('Team')
plt.tight_layout()
plt.savefig(os.path.join(plots_dir, 'team_avg_per_player.png'))
plt.show()

# ===============================
# 4. Player-wise Analysis
# ===============================

# Top 20 Most Expensive Players
plt.figure(figsize=(12,6))
sns.barplot(data=top20_players, x='player', y='price_in_lakh', hue='team', dodge=False)
plt.title('Top 20 Most Expensive Players')
plt.xticks(rotation=90)
plt.ylabel('Price (Lakh)')
plt.xlabel('Player')
plt.legend(title='Team', bbox_to_anchor=(1.05, 1), loc='upper left')
plt.tight_layout()
plt.savefig(os.path.join(plots_dir, 'top20_players.png'))
plt.show()

# Role-wise average salary
plt.figure(figsize=(8,5))
sns.barplot(data=role_salary, x='role', y='avg_salary', palette='magma')
plt.title('Average Salary by Role')
plt.ylabel('Average Salary (Lakh)')
plt.xlabel('Role')
plt.tight_layout()
plt.savefig(os.path.join(plots_dir, 'role_salary.png'))
plt.show()

# Salary Tier Distribution
plt.figure(figsize=(6,4))
sns.countplot(data=salary_tiers, x='salary_tier', palette='pastel')
plt.title('Player Distribution by Salary Tier')
plt.ylabel('Number of Players')
plt.xlabel('Salary Tier')
plt.tight_layout()
plt.savefig(os.path.join(plots_dir, 'salary_tier_distribution.png'))
plt.show()

# Player contribution to team budget
plt.figure(figsize=(10,6))
sns.barplot(data=player_team_pct, x='player', y='salary_contribution_percent', hue='team', dodge=False)
plt.title('Player Contribution to Team Salary (%)')
plt.xticks(rotation=90)
plt.ylabel('Contribution (%)')
plt.xlabel('Player')
plt.legend(title='Team', bbox_to_anchor=(1.05, 1), loc='upper left')
plt.tight_layout()
plt.savefig(os.path.join(plots_dir, 'player_team_contribution.png'))
plt.show()
