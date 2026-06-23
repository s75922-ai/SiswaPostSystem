package dao;

import model.Parcel;
import util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ParcelDAO {

    // =========================
    // CREATE - Add Parcel
    // =========================
    public void addParcel(Parcel p) throws Exception {
        String sql = "INSERT INTO parcels (parcel_id, matric_no, student_name, status) VALUES (?, ?, ?, ?)";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setString(1, p.getParcelId());
            ps.setString(2, p.getMatricNo());
            ps.setString(3, p.getStudentName());
            ps.setString(4, p.getStatus() != null ? p.getStatus() : "received");
            
            ps.executeUpdate();
        }
    }

    // =========================
    // RETRIEVE - Get All Parcels
    // =========================
    public List<Parcel> getAllParcels() throws Exception {
        List<Parcel> list = new ArrayList<>();
        String sql = "SELECT * FROM parcels ORDER BY received_at DESC";
        
        try (Connection con = DBConnection.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            
            while (rs.next()) {
                Parcel p = new Parcel();
                p.setParcelId(rs.getString("parcel_id"));
                p.setMatricNo(rs.getString("matric_no"));
                p.setStudentName(rs.getString("student_name"));
                p.setStatus(rs.getString("status"));
                p.setReceivedAt(rs.getTimestamp("received_at"));
                p.setCollectedAt(rs.getTimestamp("collected_at"));
                p.setProofImage(rs.getBytes("proof_image"));
                p.setProofImageName(rs.getString("proof_image_name"));
                p.setProofImageType(rs.getString("proof_image_type"));
                list.add(p);
            }
        }
        return list;
    }

    // =========================
    // RETRIEVE - Get Parcels by Matric
    // =========================
    public List<Parcel> getParcelsByMatric(String matricNo) throws Exception {
        List<Parcel> list = new ArrayList<>();
        String sql = "SELECT * FROM parcels WHERE matric_no = ? ORDER BY received_at DESC";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setString(1, matricNo);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Parcel p = new Parcel();
                p.setParcelId(rs.getString("parcel_id"));
                p.setMatricNo(rs.getString("matric_no"));
                p.setStudentName(rs.getString("student_name"));
                p.setStatus(rs.getString("status"));
                p.setReceivedAt(rs.getTimestamp("received_at"));
                p.setCollectedAt(rs.getTimestamp("collected_at"));
                p.setProofImage(rs.getBytes("proof_image"));
                p.setProofImageName(rs.getString("proof_image_name"));
                p.setProofImageType(rs.getString("proof_image_type"));
                list.add(p);
            }
        }
        return list;
    }

    // =========================
    // RETRIEVE - Get Parcel by ID
    // =========================
    public Parcel getParcelById(String parcelId) throws Exception {
        Parcel p = null;
        String sql = "SELECT * FROM parcels WHERE parcel_id = ?";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setString(1, parcelId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                p = new Parcel();
                p.setParcelId(rs.getString("parcel_id"));
                p.setMatricNo(rs.getString("matric_no"));
                p.setStudentName(rs.getString("student_name"));
                p.setStatus(rs.getString("status"));
                p.setReceivedAt(rs.getTimestamp("received_at"));
                p.setCollectedAt(rs.getTimestamp("collected_at"));
                p.setProofImage(rs.getBytes("proof_image"));
                p.setProofImageName(rs.getString("proof_image_name"));
                p.setProofImageType(rs.getString("proof_image_type"));
            }
        }
        return p;
    }

    // =========================
    // UPDATE - Update Parcel Status
    // =========================
    public void updateParcelStatus(String parcelId, String status) throws Exception {
        String sql = "UPDATE parcels SET status = ? WHERE parcel_id = ?";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setString(1, status);
            ps.setString(2, parcelId);
            ps.executeUpdate();
        }
    }

    // =========================
    // UPDATE - Collect Parcel (without image)
    // =========================
    public void collectParcel(String parcelId) throws Exception {
        String sql = "UPDATE parcels SET status = 'collected', collected_at = NOW() WHERE parcel_id = ?";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setString(1, parcelId);
            ps.executeUpdate();
        }
    }

    // =========================
    // UPDATE - Collect Parcel WITH Image Proof
    // =========================
    public void collectParcelWithProof(String parcelId, byte[] imageData, String imageName, String imageType) throws Exception {
        String sql = "UPDATE parcels SET status = 'collected', collected_at = NOW(), proof_image = ?, proof_image_name = ?, proof_image_type = ? WHERE parcel_id = ?";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setBytes(1, imageData);
            ps.setString(2, imageName);
            ps.setString(3, imageType);
            ps.setString(4, parcelId);
            ps.executeUpdate();
        }
    }

    // =========================
    // DELETE - Delete Parcel
    // =========================
    public void deleteParcel(String parcelId) throws Exception {
        String sql = "DELETE FROM parcels WHERE parcel_id = ?";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setString(1, parcelId);
            ps.executeUpdate();
        }
    }

    // =========================
    // COUNT - Get Parcel Count by Status
    // =========================
    public int countParcelsByStatus(String status) throws Exception {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM parcels WHERE status = ?";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setString(1, status);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                count = rs.getInt(1);
            }
        }
        return count;
    }
}