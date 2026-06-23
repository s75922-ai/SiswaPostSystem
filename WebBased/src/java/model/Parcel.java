package model;

import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.Base64;

public class Parcel {
    private String parcelId;
    private String matricNo;
    private String studentName;
    private String status;
    private Timestamp receivedAt;
    private Timestamp collectedAt;
    
    // Image fields
    private byte[] proofImage;
    private String proofImageName;
    private String proofImageType;

    public Parcel() {}

    public Parcel(String parcelId, String matricNo, String studentName, String status) {
        this.parcelId = parcelId;
        this.matricNo = matricNo;
        this.studentName = studentName;
        this.status = status;
    }

    // Getters and Setters
    public String getParcelId() {
        return parcelId;
    }

    public void setParcelId(String parcelId) {
        this.parcelId = parcelId;
    }

    public String getMatricNo() {
        return matricNo;
    }

    public void setMatricNo(String matricNo) {
        this.matricNo = matricNo;
    }

    public String getStudentName() {
        return studentName;
    }

    public void setStudentName(String studentName) {
        this.studentName = studentName;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getReceivedAt() {
        return receivedAt;
    }

    public void setReceivedAt(Timestamp receivedAt) {
        this.receivedAt = receivedAt;
    }

    public Timestamp getCollectedAt() {
        return collectedAt;
    }

    public void setCollectedAt(Timestamp collectedAt) {
        this.collectedAt = collectedAt;
    }

    // Image Getters and Setters
    public byte[] getProofImage() {
        return proofImage;
    }

    public void setProofImage(byte[] proofImage) {
        this.proofImage = proofImage;
    }

    public String getProofImageName() {
        return proofImageName;
    }

    public void setProofImageName(String proofImageName) {
        this.proofImageName = proofImageName;
    }

    public String getProofImageType() {
        return proofImageType;
    }

    public void setProofImageType(String proofImageType) {
        this.proofImageType = proofImageType;
    }

    // Helper Methods
    public String getProofImageBase64() {
        if (proofImage != null && proofImage.length > 0) {
            return Base64.getEncoder().encodeToString(proofImage);
        }
        return null;
    }

    public boolean hasProofImage() {
        return proofImage != null && proofImage.length > 0;
    }

    public String getFormattedReceivedAt() {
        if (receivedAt != null) {
            return new SimpleDateFormat("yyyy-MM-dd hh:mm a").format(receivedAt);
        }
        return "";
    }

    public String getFormattedCollectedAt() {
        if (collectedAt != null) {
            return new SimpleDateFormat("yyyy-MM-dd hh:mm a").format(collectedAt);
        }
        return "-";
    }
}