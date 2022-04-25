const mysql = require("mysql2");


// Create a connection to the database
const connection = mysql.createConnection({
  host: "10.107.181.238",
  user: "root",
  password: "shubham@12345",
  port: "3306",
  database: "employees_db"
});

// open the MySQL connection
connection.connect(error => {
  if (error) throw error;
  console.log("Successfully connected to the MYSQL database.");
});

module.exports = connection;
