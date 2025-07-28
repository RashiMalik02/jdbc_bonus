package DataAccessObject;

import MainEntities.Job;
import db.DatabaseConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class JobDao {
    private DatabaseConnection dbConnection;

    // Constructor that takes DatabaseConnection instance
    public JobDao(DatabaseConnection dbConnection) {
        this.dbConnection = dbConnection;
    }
    public void insert(Job job) {
        String sql = "INSERT INTO job(job_id, title, company_dept_id, description, total_applications, posted_by, status) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, job.getJobId());
            ps.setString(2, job.getTitle());
            ps.setInt(3, job.getCompanyDeptId());
            ps.setString(4, job.getDescription());
            ps.setInt(5, job.getTotalApplications());
            ps.setInt(6, job.getPostedBy());
            ps.setString(7, job.getStatus());
            ps.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e.getMessage());
            ;
        }
    }
}
