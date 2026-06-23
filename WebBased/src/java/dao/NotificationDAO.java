package dao;

import model.Notification;
import util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class NotificationDAO {

    // =========================
    // CREATE Notification
    // =========================
    public void addNotification(Notification n) {
        String sql = "INSERT INTO notifications (matric_no, parcel_id, notification_type, message, notification_status) VALUES (?, ?, ?, ?, ?)";
        try (Connection con = DBConnection.getConnection(); 
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, n.getMatricNo());
            ps.setString(2, n.getParcelId());
            ps.setString(3, n.getNotificationType());
            ps.setString(4, n.getMessage());
            ps.setString(5, n.getNotificationStatus() != null ? n.getNotificationStatus() : "UNREAD");
            ps.executeUpdate();
        } catch (SQLException e) { 
            e.printStackTrace(); 
        }
    }

    // =========================
    // RETRIEVE - All Notifications
    // =========================
    public List<Notification> getAllNotifications() {
        List<Notification> list = new ArrayList<>();
        String sql = "SELECT * FROM notifications ORDER BY created_at DESC";
        try (Connection con = DBConnection.getConnection(); 
             Statement st = con.createStatement(); 
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                Notification n = new Notification();
                n.setNotificationId(rs.getInt("notification_id"));
                n.setMatricNo(rs.getString("matric_no"));
                n.setParcelId(rs.getString("parcel_id"));
                n.setNotificationType(rs.getString("notification_type"));
                n.setMessage(rs.getString("message"));
                n.setNotificationStatus(rs.getString("notification_status"));
                n.setCreatedAt(rs.getTimestamp("created_at"));
                list.add(n);
            }
        } catch (SQLException e) { 
            e.printStackTrace(); 
        }
        return list;
    }

    // =========================
    // RETRIEVE - By Matric No
    // =========================
    public List<Notification> getNotificationsByMatric(String matricNo) {
        List<Notification> list = new ArrayList<>();
        String sql = "SELECT * FROM notifications WHERE matric_no = ? ORDER BY created_at DESC";
        try (Connection con = DBConnection.getConnection(); 
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, matricNo);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Notification n = new Notification();
                n.setNotificationId(rs.getInt("notification_id"));
                n.setMatricNo(rs.getString("matric_no"));
                n.setParcelId(rs.getString("parcel_id"));
                n.setNotificationType(rs.getString("notification_type"));
                n.setMessage(rs.getString("message"));
                n.setNotificationStatus(rs.getString("notification_status"));
                n.setCreatedAt(rs.getTimestamp("created_at"));
                list.add(n);
            }
        } catch (SQLException e) { 
            e.printStackTrace(); 
        }
        return list;
    }

    // =========================
    // RETRIEVE - Get by ID
    // =========================
    public Notification getNotificationById(int id) {
        Notification n = null;
        String sql = "SELECT * FROM notifications WHERE notification_id = ?";
        try (Connection con = DBConnection.getConnection(); 
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                n = new Notification();
                n.setNotificationId(rs.getInt("notification_id"));
                n.setMatricNo(rs.getString("matric_no"));
                n.setParcelId(rs.getString("parcel_id"));
                n.setNotificationType(rs.getString("notification_type"));
                n.setMessage(rs.getString("message"));
                n.setNotificationStatus(rs.getString("notification_status"));
                n.setCreatedAt(rs.getTimestamp("created_at"));
            }
        } catch (SQLException e) { 
            e.printStackTrace(); 
        }
        return n;
    }

    // =========================
    // UPDATE - Status (READ/UNREAD)
    // =========================
    public void updateStatus(int id, String status) {
        String sql = "UPDATE notifications SET notification_status = ? WHERE notification_id = ?";
        try (Connection con = DBConnection.getConnection(); 
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, status.toUpperCase());
            ps.setInt(2, id);
            ps.executeUpdate();
        } catch (SQLException e) { 
            e.printStackTrace(); 
        }
    }

    // =========================
    // DELETE
    // =========================
    public void deleteNotification(int id) {
        String sql = "DELETE FROM notifications WHERE notification_id = ?";
        try (Connection con = DBConnection.getConnection(); 
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (SQLException e) { 
            e.printStackTrace(); 
        }
    }

    // =========================
    // COUNT UNREAD - By Matric
    // =========================
    public int countUnreadNotifications(String matricNo) {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM notifications WHERE matric_no = ? AND notification_status = 'UNREAD'";
        try (Connection con = DBConnection.getConnection(); 
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, matricNo);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException e) { 
            e.printStackTrace(); 
        }
        return count;
    }
}