package dao;

import model.User;
import util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {

    // =========================
    // CREATE USER
    // =========================
    public int addUser(User u) throws Exception {
        String sql = "INSERT INTO users(fullName, matricNo, email, password, role, status) VALUES(?,?,?,?,?,?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, u.getFullName());
            ps.setString(2, u.getMatricNo());
            ps.setString(3, u.getEmail());
            ps.setString(4, u.getPassword());
            ps.setString(5, u.getRole());
            ps.setString(6, u.getStatus() != null ? u.getStatus() : "active");

            int result = ps.executeUpdate();
            
            if (result > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    u.setUserId(rs.getInt(1));
                }
            }
            return result;
        }
    }

    // =========================
    // AUTHENTICATE
    // =========================
    public User authenticateUser(String matricNo, String password) throws Exception {
        User user = null;
        String sql = "SELECT * FROM users WHERE matricNo = ? AND password = ? AND status = 'active'";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, matricNo);
            ps.setString(2, password);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    user = new User();
                    user.setUserId(rs.getInt("userId"));
                    user.setFullName(rs.getString("fullName"));
                    user.setMatricNo(rs.getString("matricNo"));
                    user.setEmail(rs.getString("email"));
                    user.setRole(rs.getString("role"));
                    user.setStatus(rs.getString("status"));
                }
            }
        }
        return user;
    }

    // =========================
    // GET ALL USERS
    // =========================
    public List<User> getAllUsers() throws Exception {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM users ORDER BY fullName ASC";

        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {

            while (rs.next()) {
                User u = new User();
                u.setUserId(rs.getInt("userId"));
                u.setFullName(rs.getString("fullName"));
                u.setMatricNo(rs.getString("matricNo"));
                u.setEmail(rs.getString("email"));
                u.setRole(rs.getString("role"));
                u.setStatus(rs.getString("status"));
                list.add(u);
            }
        }
        return list;
    }

    // =========================
    // GET USER BY ID
    // =========================
    public User getUserById(int userId) throws Exception {
        User user = null;
        String sql = "SELECT * FROM users WHERE userId = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                user = new User();
                user.setUserId(rs.getInt("userId"));
                user.setFullName(rs.getString("fullName"));
                user.setMatricNo(rs.getString("matricNo"));
                user.setEmail(rs.getString("email"));
                user.setRole(rs.getString("role"));
                user.setStatus(rs.getString("status"));
            }
        }
        return user;
    }

    // =========================
    // GET USER BY MATRIC
    // =========================
    public User getUserByMatric(String matricNo) throws Exception {
        User user = null;
        String sql = "SELECT * FROM users WHERE matricNo = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, matricNo);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                user = new User();
                user.setUserId(rs.getInt("userId"));
                user.setFullName(rs.getString("fullName"));
                user.setMatricNo(rs.getString("matricNo"));
                user.setEmail(rs.getString("email"));
                user.setRole(rs.getString("role"));
                user.setStatus(rs.getString("status"));
            }
        }
        return user;
    }

    // =========================
    // UPDATE USER
    // =========================
    public void updateUser(User u) throws Exception {
        String sql = "UPDATE users SET fullName=?, matricNo=?, email=?, role=?, status=? WHERE userId=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, u.getFullName());
            ps.setString(2, u.getMatricNo());
            ps.setString(3, u.getEmail());
            ps.setString(4, u.getRole());
            ps.setString(5, u.getStatus());
            ps.setInt(6, u.getUserId());

            ps.executeUpdate();
        }
    }

    // =========================
    // UPDATE USER STATUS
    // =========================
    public void updateUserStatus(int userId, String status) throws Exception {
        String sql = "UPDATE users SET status = ? WHERE userId = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, status);
            ps.setInt(2, userId);
            ps.executeUpdate();
        }
    }

    // =========================
    // DELETE USER
    // =========================
    public void deleteUser(int userId) throws Exception {
        String sql = "DELETE FROM users WHERE userId=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.executeUpdate();
        }
    }

    // =========================
    // CHECK IF USER EXISTS
    // =========================
    public boolean userExists(String matricNo, String email) throws Exception {
        String sql = "SELECT COUNT(*) FROM users WHERE matricNo = ? OR email = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, matricNo);
            ps.setString(2, email);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        }
        return false;
    }
}