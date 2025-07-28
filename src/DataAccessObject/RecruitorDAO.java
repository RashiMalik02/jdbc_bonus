package DataAccessObject;

import MainEntities.Recruitor;
import db.DatabaseConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class RecruitorDAO {
    private DatabaseConnection dbConnection;

    // Constructor that takes DatabaseConnection instance
    public RecruitorDAO(DatabaseConnection dbConnection) {
        this.dbConnection = dbConnection;
    }

    public void insert(Recruitor r) {
        String sql = "INSERT INTO recruitor(user_id, recruitor_id, company_id) VALUES (?, ?, ?)";
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, r.getUserId());
            ps.setInt(2, r.getRecruitorId());
            ps.setInt(3, r.getCompanyId());
            ps.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
    }
}
