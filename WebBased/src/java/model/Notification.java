package model;

import java.sql.Timestamp;
import java.text.SimpleDateFormat;

public class Notification {
    private int notificationId;
    private String matricNo;
    private String parcelId;
    private String notificationType;
    private String message;
    private String notificationStatus;
    private Timestamp createdAt;

    // JOIN DATA (optional)
    private String studentName;
    private String courierName;

    public Notification() {}

    public Notification(String matricNo, String parcelId, String notificationType, String message, String notificationStatus) {
        this.matricNo = matricNo;
        this.parcelId = parcelId;
        this.notificationType = notificationType;
        this.message = message;
        this.notificationStatus = notificationStatus;
    }

    // Getters and Setters
    public int getNotificationId() {
        return notificationId;
    }

    public void setNotificationId(int notificationId) {
        this.notificationId = notificationId;
    }

    public String getMatricNo() {
        return matricNo;
    }

    public void setMatricNo(String matricNo) {
        this.matricNo = matricNo;
    }

    public String getParcelId() {
        return parcelId;
    }

    public void setParcelId(String parcelId) {
        this.parcelId = parcelId;
    }

    public String getNotificationType() {
        return notificationType;
    }

    public void setNotificationType(String notificationType) {
        this.notificationType = notificationType;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public String getNotificationStatus() {
        return notificationStatus;
    }

    public void setNotificationStatus(String notificationStatus) {
        this.notificationStatus = notificationStatus;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public String getStudentName() {
        return studentName;
    }

    public void setStudentName(String studentName) {
        this.studentName = studentName;
    }

    public String getCourierName() {
        return courierName;
    }

    public void setCourierName(String courierName) {
        this.courierName = courierName;
    }

    public String getFormattedCreatedAt() {
        if (createdAt != null) {
            return new SimpleDateFormat("yyyy-MM-dd hh:mm a").format(createdAt);
        }
        return "";
    }
}