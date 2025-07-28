import DataAccessObject.UserDao;
import MainEntities.User;
import db.DatabaseConnection;

import java.sql.*;
import java.util.Scanner;

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);

        System.out.println("Database Connection Setup");
        System.out.print("Please enter your database URL (e.g., jdbc:mysql://localhost:3306/schemaDb): ");
        String dbUrl = sc.nextLine();

        System.out.print("Please enter your database username: ");
        String dbUser = sc.nextLine();

        System.out.print("Please enter your database password: ");
        String dbPassword = sc.nextLine();

        DatabaseConnection dbConnection = new DatabaseConnection(dbUrl, dbUser, dbPassword);

        //inserting user using jdbc
        //CRUD of main entities using jdbc
        User user = new User(78, "Abhinav", "abhinavsuri@email.com", "MALE", "+1-525-1501", new Date(1899, 8, 2), "hashed_password_78");
        UserDao userDao = new UserDao(dbConnection);
        userDao.insertUser(user);


        //implementing frequent queries
        //frequent query:1
        //List all candidates in the interview stage for a given job.
        try {

            Connection connection = dbConnection.getConnection();
            String query1 = "select A.candidate_id \n" +
                    "from applications as A\n" +
                    "join application_stage as B\n" +
                    "on (A.current_stage_id = B.stage_id and B.title = 'interview') and (A.job_id = ?);";
            PreparedStatement preparedStatement = connection.prepareStatement(query1);
            preparedStatement.setInt(1, 1);

            try (ResultSet resultSet = preparedStatement.executeQuery()) {
                System.out.println("Query1: ");
                while (resultSet.next()) {
                    int candidate_id = resultSet.getInt("candidate_id");

                    System.out.println("Candidate ID: " + candidate_id);
                    System.out.println();
                }

            } catch (Exception e) {
                System.out.println(e.getMessage());
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }

        //frequent query:2
        //Retrieve interview schedules for an interviewer.
        try {
            Connection connection = dbConnection.getConnection();
            String query2 = "select * from interviews\n" +
                    "where interviewer_id = ? and status = 'scheduled' order by scheduled_at;";
            PreparedStatement preparedStatement = connection.prepareStatement(query2);
            preparedStatement.setInt(1, 2001);

            try(ResultSet resultSet = preparedStatement.executeQuery()) {
                System.out.println("Query2: ");
                while(resultSet.next()) {
                    int id = resultSet.getInt("id");
                    int application_id = resultSet.getInt("application_id");
                    int interviewer_id = resultSet.getInt("interviewer_id");
                    String status = resultSet.getString("status");

                    System.out.println("interview id: " + id);
                    System.out.println("application id: " + application_id);
                    System.out.println("interviewer id: " + interviewer_id);
                    System.out.println("Status: " + status);
                    System.out.println();
                }

        } catch (SQLException e) {
            System.out.println(e.getMessage());
        } } catch (Exception e) {
                System.out.println(e.getMessage());
        }

        //frequent query:3
        //Find jobs with more than 50 applications.
        try {
            Connection connection = dbConnection.getConnection();
            String query3 = "select * from job where total_applications > 50;";
            PreparedStatement preparedStatement = connection.prepareStatement(query3);

            try(ResultSet resultSet = preparedStatement.executeQuery()) {
                System.out.println("Query3: ");
                while(resultSet.next()) {
                    int job_id = resultSet.getInt("job_id");
                    int total_applications = resultSet.getInt("total_applications");
                    String title = resultSet.getString("title");

                    System.out.println("job id: " + job_id);
                    System.out.println("total applications: " + total_applications);
                    System.out.println("title: " + title);
                    System.out.println();
                }

            } catch (SQLException e) {
                System.out.println(e.getMessage());
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }

        //frequent query:4
        //Show offer acceptance rate per department.
        try {
            Connection connection = dbConnection.getConnection();
            String query4 = "select company_dept_id , round(((total_accepted_offers / total_offers) * 100) , 2) as acceptance_rate\n" +
                    "from company_department;";
            PreparedStatement preparedStatement = connection.prepareStatement(query4);

            try(ResultSet resultSet = preparedStatement.executeQuery()) {
                System.out.println("Query 4:");
                while(resultSet.next()) {
                    int company_dept_id = resultSet.getInt("company_dept_id");
                    int acceptance_rate = resultSet.getInt("acceptance_rate");

                    System.out.println("Company dept id: " + company_dept_id);
                    System.out.println("Acceptance rate: " + acceptance_rate);
                    System.out.println();
                }

            } catch (SQLException e) {
                System.out.println(e.getMessage());
            }

        } catch (Exception e) {
            System.out.println(e.getMessage());
        }

        //frequent query:5
        //Show status of all applications of a candidate.
        try {
            Connection connection = dbConnection.getConnection();
            String query5 = "select A.application_id , J.job_id, J.title as Job_name , B.title as application_status from applications as A\n" +
                            "join application_stage as B on (A.candidate_id = ?) and (A.current_stage_id = B.stage_id)\n" +
                            "join job as J on A.job_id = J.job_id;";
            PreparedStatement preparedStatement = connection.prepareStatement(query5);
            preparedStatement.setInt(1, 1001);

            try(ResultSet resultSet = preparedStatement.executeQuery()) {
                System.out.println("Query 5:");
                while(resultSet.next()) {
                    int application_id = resultSet.getInt("application_id");
                    int job_id = resultSet.getInt("job_id");
                    String Job_name = resultSet.getString("Job_name");
                    String status = resultSet.getString("application_status");

                    System.out.println("application Id: " + application_id);
                    System.out.println("Job Id: " + job_id);
                    System.out.println("Job title: " + Job_name);
                    System.out.println("status: " + status);
                    System.out.println();
                }

            } catch (SQLException e) {
                System.out.println(e.getMessage());
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }


    }
}