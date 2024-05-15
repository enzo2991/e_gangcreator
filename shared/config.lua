Config = {}

Config.Locale = "fr"

Config.Queries = {
    gangs = {query = 'SELECT * FROM jobs2'},
    grade = {query = 'SELECT * FROM job2_grades WHERE job_name = ?'},
    money = {query = 'SELECT money FROM addon_account_data WHERE account_name = ? LIMIT 1',prefix = "gang_"}
}