package DataAccessObject;

import MainEntities.Application;
import db.DatabaseConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class ApplicationDao {
    public void insert(Application app) {
        String sql = "INSERT INTO applications(application_id, candidate_id, job_id, applied_at, current_stage_id) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DatabaseConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, app.getApplicationId());
            ps.setInt(2, app.getCandidateId());
            ps.setInt(3, app.getJobId());
            ps.setTimestamp(4, app.getAppliedAt());
            ps.setInt(5, app.getCurrentStageId());
            ps.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
    }
}
