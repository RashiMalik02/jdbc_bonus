package DataAccessObject;

import MainEntities.User;
import db.DatabaseConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class UserDao {
    private static final String query = "INSERT INTO user(user_id, name, email, gender, phoneNo, dateOfBirth, password) VALUES(?, ?, ?, ?, ?, ?, ?)";

    public static void insertUser(User user) {
        try {
            Connection connection = DatabaseConnection.getConnection();
            PreparedStatement ps = connection.prepareStatement(query);

            ps.setInt(1, user.getUserId());
            ps.setString(2, user.getName());
            ps.setString(3, user.getEmail());
            ps.setString(4, user.getGender());
            ps.setString(5, user.getPhoneNo());
            ps.setDate(6, user.getDateOfBirth());
            ps.setString(7, user.getPassword());
            ps.executeUpdate();
        } catch(SQLException e) {
            System.out.println(e.getMessage());
        }
    }
}
