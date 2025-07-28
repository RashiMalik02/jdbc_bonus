package DataAccessObject;

import MainEntities.Candidate;
import db.DatabaseConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class CandidateDAO {

    private DatabaseConnection dbConnection;

    // Constructor that takes DatabaseConnection instance
    public CandidateDAO(DatabaseConnection dbConnection) {
        this.dbConnection = dbConnection;
    }

    public void insertCandidate(Candidate c) {
        String sql = "INSERT INTO candidate(user_id, candidate_id, resume_link_path, experience, education, skill) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, c.getUserId());
            ps.setInt(2, c.getCandidateId());
            ps.setString(3, c.getResumeLinkPath());
            ps.setInt(4, c.getExperience());
            ps.setString(5, c.getEducation() );
            ps.setString(6, c.getSkill());
            ps.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
    }
}
