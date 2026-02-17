<?php
session_start();
include_once("../database/config.php");

$sql = "SELECT a.appointment_id, p.patient_id, p.first_name, p.last_name, s.service_category, s.sub_service,
               d.first_name as dentist_first, d.last_name as dentist_last,
               a.appointment_date, a.appointment_time, a.status, a.branch
        FROM appointments a
        LEFT JOIN patient_information p ON a.patient_id = p.patient_id
        LEFT JOIN services s ON a.service_id = s.service_id
        LEFT JOIN multidisciplinary_dental_team d ON a.team_id = d.team_id
        ORDER BY a.appointment_date ASC";
$result = mysqli_query($con, $sql);
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Appointments - Admin</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:ital,wght@0,100;0,200;0,300;0,400;0,500;0,600;0,700;0,800;0,900;1,100;1,200;1,300;1,400;1,500;1,600;1,700;1,800;1,900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="appointmentDesign.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>

<!-- Notification Container -->
<div class="notification-container" id="notificationContainer"></div>

<div class="main-content">
    <div class="container">
        <a href="../views/admin.php" class="back-button" onclick="navigateBack(event)">
            <i class="fas fa-arrow-left"></i> Back to Admin
        </a>
        <h2><i class="fas fa-calendar-alt"></i> APPOINTMENTS</h2>
        <p style="color: #6b7280; margin-bottom: 30px;">Manage patient appointments, confirm, reschedule, cancel, and mark as completed.</p>
        
        <!-- Action Buttons -->
        <div class="action-buttons-container" style="display: flex; gap: 15px; flex-wrap: wrap; margin-bottom: 30px;">
            <button class="btn btn-primary" onclick="openAddAppointmentModal()">
                <i class="fas fa-plus-circle"></i> Add New Appointment
            </button>
            <button class="btn btn-accent" onclick="printAppointments()">
                <i class="fas fa-print"></i> Print Appointments
            </button>
        </div>
        
        <div class="filter-container">
            <div class="filter-group">
                <label for="filter-date-category"><i class="fas fa-calendar-day"></i> Date Category:</label>
                <select id="filter-date-category" onchange="handleDateCategoryChange()">
                    <option value="">All Dates</option>
                    <option value="today">Today</option>
                    <option value="week">This Week</option>
                    <option value="month">This Month</option>
                    <option value="custom">Custom Date</option>
                </select>
                <input type="date" id="filter-date" onchange="filterAppointments()" style="display:none; margin-left:10px;">
            </div>
            
            <div class="filter-group">
                <label for="filter-status"><i class="fas fa-filter"></i> Status Category:</label>        
                <select id="filter-status" onchange="filterAppointments()">
                    <option value="">All Status</option>
                    <option value="pending">Pending</option>
                    <option value="confirmed">Confirmed</option>
                    <option value="reschedule">Reschedule</option>
                    <option value="completed">Completed</option>
                    <option value="cancelled">Cancelled</option>
                    <option value="no-show">No-Show</option>
                </select> 
            </div>
        </div>

        <div class="table-responsive">
            <table id="appointments-table">
                <thead>
                    <tr>
                        <th>Appointment ID</th>
                        <th>Patient Name</th>
                        <th>Service</th>
                        <th>Dentist</th>
                        <th>Appointment Date</th>
                        <th>Appointment Time</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <?php 
                    if(mysqli_num_rows($result) > 0) {
                        while ($row = mysqli_fetch_assoc($result)) { 
                            $statusClass = 'status-' . strtolower($row['status']);
                    ?>
                        <tr class="appointment-row" data-date="<?php echo $row['appointment_date']; ?>" data-status="<?php echo strtolower($row['status']); ?>">
                            <td><?php echo htmlspecialchars($row['appointment_id']); ?></td>
                            <td><?php echo htmlspecialchars($row['first_name'] . ' ' . $row['last_name']); ?></td>
                            <td><?php echo htmlspecialchars($row['sub_service']); ?></td>
                            <td><?php echo htmlspecialchars($row['dentist_first'] . ' ' . $row['dentist_last']); ?></td>
                            <td><?php echo date('M j, Y', strtotime($row['appointment_date'])); ?></td>
                            <td><?php echo htmlspecialchars($row['appointment_time']); ?></td>
                            <td><span class="status <?php echo $statusClass; ?>"><?php echo htmlspecialchars($row['status']); ?></span></td>
                            <td>
                                <div class="action-btns">
                                    <?php if (strtolower($row['status']) === 'pending'): ?>
                                    <button type="button" class="action-btn btn-primary-confirmed" title="Confirm"
                                        data-appointment-id="<?php echo $row['appointment_id']; ?>"
                                        onclick="confirmAppointment(this)">
                                        <i class="fas fa-check"></i>
                                    </button>

                                    <a href="#" 
                                        class="action-btn btn-accent" 
                                        id="reschedBtn<?= $row['appointment_id'] ?>" 
                                        data-id="<?= $row['appointment_id'] ?>"
                                        onclick="return openReschedModalWithID(this, event);"
                                        title="Reschedule">
                                        <i class="fas fa-calendar-alt"></i>
                                    </a>

                                    <button type="button" class="action-btn btn-danger" title="Cancel"
                                        data-appointment-id="<?php echo $row['appointment_id']; ?>"
                                        onclick="cancelAppointmentByAdmin(this)">
                                        <i class="fas fa-times"></i>
                                    </button>

                                    <button type="button" class="action-btn btn-danger" title="No-Show"
                                        data-appointment-id="<?php echo $row['appointment_id']; ?>"
                                        onclick="markNoShow(this)">
                                        <i class="fa-regular fa-eye-slash"></i>
                                    </button>
                                    <?php else: ?>
                                    <a href="#" 
                                        class="action-btn btn-accent <?php echo (in_array(strtolower($row['status']), ['completed', 'cancelled', 'no-show']) ? 'disabled-action' : ''); ?>" 
                                        id="reschedBtn<?= $row['appointment_id'] ?>" 
                                        data-id="<?= $row['appointment_id'] ?>"
                                        onclick="<?php echo (in_array(strtolower($row['status']), ['completed', 'cancelled', 'no-show']) ? 'event.preventDefault(); return false;' : 'return openReschedModalWithID(this, event);'); ?>"
                                        title="<?php echo (in_array(strtolower($row['status']), ['completed', 'cancelled', 'no-show']) ? 'Cannot reschedule this appointment' : 'Reschedule'); ?>">
                                        <i class="fas fa-calendar-alt"></i>
                                    </a>

                                    <button type="button" class="action-btn btn-completed" title="Mark as Completed"
                                        data-patientid="<?php echo htmlspecialchars($row['patient_id']); ?>"
                                        data-appointmentid="<?php echo htmlspecialchars($row['appointment_id']); ?>"
                                        onclick="openCompleteAppointmentModal(this)">
                                        <i class="fa-solid fa-calendar-check"></i>
                                    </button>

                                    <?php if (strtolower($row['status']) === 'completed'): ?>
                                    <button type="button" class="action-btn btn-followup" title="Follow-Up"
                                        data-appointment-id="<?php echo htmlspecialchars($row['appointment_id']); ?>"
                                        data-patient-id="<?php echo htmlspecialchars($row['patient_id']); ?>"
                                        data-patient-name="<?php echo htmlspecialchars($row['first_name'] . ' ' . $row['last_name']); ?>"
                                        onclick="openFollowUpModal(this)">
                                        <i class="fa-solid fa-arrow-right"></i>
                                    </button>
                                    <?php endif; ?>

                                    <button type="button" class="action-btn btn-danger" title="No-Show"
                                        data-appointment-id="<?php echo $row['appointment_id']; ?>"
                                        onclick="markNoShow(this)">
                                        <i class="fa-regular fa-eye-slash"></i>
                                    </button>
                                    <?php endif; ?>
                                </div>
                            </td>
                        </tr>
                    <?php 
                        }
                    } else { 
                    ?>
                        <tr>
                            <td colspan="8" class="no-data">
                                <i class="fas fa-calendar-times fa-2x"></i>
                                <p>No appointments found</p>
                            </td>
                        </tr>
                    <?php } ?>
                </tbody>
            </table>
        </div>
        
        <!-- Mobile Card View -->
        <div class="mobile-card-view">
            <?php
            // Reset result pointer
            mysqli_data_seek($result, 0);
            if(mysqli_num_rows($result) > 0) {
                while ($row = mysqli_fetch_assoc($result)) {
                    $statusClass = 'status-' . strtolower($row['status']);
            ?>
                <div class="appointment-card appointment-row" data-date="<?php echo $row['appointment_date']; ?>" data-status="<?php echo strtolower($row['status']); ?>">
                    <div class="appointment-card-header">
                        <div>
                            <div class="appointment-card-id">Appointment #<?php echo htmlspecialchars($row['appointment_id']); ?></div>
                            <div class="appointment-card-patient"><?php echo htmlspecialchars($row['first_name'] . ' ' . $row['last_name']); ?></div>
                        </div>
                        <span class="status <?php echo $statusClass; ?>"><?php echo htmlspecialchars($row['status']); ?></span>
                    </div>
                    <div class="appointment-card-body">
                        <div class="appointment-card-field">
                            <div class="appointment-card-label">Service</div>
                            <div class="appointment-card-value"><?php echo htmlspecialchars($row['sub_service']); ?></div>
                        </div>
                        <div class="appointment-card-field">
                            <div class="appointment-card-label">Dentist</div>
                            <div class="appointment-card-value"><?php echo htmlspecialchars($row['dentist_first'] . ' ' . $row['dentist_last']); ?></div>
                        </div>
                        <div class="appointment-card-field">
                            <div class="appointment-card-label">Date</div>
                            <div class="appointment-card-value"><?php echo date('M j, Y', strtotime($row['appointment_date'])); ?></div>
                        </div>
                        <div class="appointment-card-field">
                            <div class="appointment-card-label">Time</div>
                            <div class="appointment-card-value"><?php echo htmlspecialchars($row['appointment_time']); ?></div>
                        </div>
                    </div>
                    <div class="appointment-card-actions">
                        <?php if (strtolower($row['status']) === 'pending'): ?>
                        <button type="button" class="action-btn btn-primary-confirmed" title="Confirm"
                            data-appointment-id="<?php echo $row['appointment_id']; ?>"
                            onclick="confirmAppointment(this)">
                            <i class="fas fa-check"></i> Confirm
                        </button>
                        <a href="#" 
                            class="action-btn btn-accent" 
                            id="reschedBtnMobile<?= $row['appointment_id'] ?>" 
                            data-id="<?= $row['appointment_id'] ?>"
                            onclick="return openReschedModalWithID(this, event);"
                            title="Reschedule">
                            <i class="fas fa-calendar-alt"></i> Reschedule
                        </a>
                        <button type="button" class="action-btn btn-danger" title="Cancel"
                            data-appointment-id="<?php echo $row['appointment_id']; ?>"
                            onclick="cancelAppointmentByAdmin(this)">
                            <i class="fas fa-times"></i> Cancel
                        </button>
                        <button type="button" class="action-btn btn-danger" title="No-Show"
                            data-appointment-id="<?php echo $row['appointment_id']; ?>"
                            onclick="markNoShow(this)">
                            <i class="fa-regular fa-eye-slash"></i> No-Show
                        </button>
                        <?php else: ?>
                        <a href="#" 
                            class="action-btn btn-accent <?php echo (in_array(strtolower($row['status']), ['completed', 'cancelled', 'no-show']) ? 'disabled-action' : ''); ?>" 
                            id="reschedBtnMobile<?= $row['appointment_id'] ?>" 
                            data-id="<?= $row['appointment_id'] ?>"
                            onclick="<?php echo (in_array(strtolower($row['status']), ['completed', 'cancelled', 'no-show']) ? 'event.preventDefault(); return false;' : 'return openReschedModalWithID(this, event);'); ?>"
                            title="<?php echo (in_array(strtolower($row['status']), ['completed', 'cancelled', 'no-show']) ? 'Cannot reschedule this appointment' : 'Reschedule'); ?>">
                            <i class="fas fa-calendar-alt"></i> Reschedule
                        </a>
                        <button type="button" class="action-btn btn-completed" title="Mark as Completed"
                            data-patientid="<?php echo htmlspecialchars($row['patient_id']); ?>"
                            data-appointmentid="<?php echo htmlspecialchars($row['appointment_id']); ?>"
                            onclick="openCompleteAppointmentModal(this)">
                            <i class="fa-solid fa-calendar-check"></i> Complete
                        </button>
                        <?php if (strtolower($row['status']) === 'completed'): ?>
                        <button type="button" class="action-btn btn-followup" title="Follow-Up"
                            data-appointment-id="<?php echo htmlspecialchars($row['appointment_id']); ?>"
                            data-patient-id="<?php echo htmlspecialchars($row['patient_id']); ?>"
                            data-patient-name="<?php echo htmlspecialchars($row['first_name'] . ' ' . $row['last_name']); ?>"
                            onclick="openFollowUpModal(this)">
                            <i class="fa-solid fa-arrow-right"></i> Follow-Up
                        </button>
                        <?php endif; ?>
                        <button type="button" class="action-btn btn-danger" title="No-Show"
                            data-appointment-id="<?php echo $row['appointment_id']; ?>"
                            onclick="markNoShow(this)">
                            <i class="fa-regular fa-eye-slash"></i> No-Show
                        </button>
                        <?php endif; ?>
                    </div>
                </div>
            <?php
                }
            } else {
            ?>
                <div class="no-data" style="text-align: center; padding: 30px; color: #6b7280;">
                    <i class="fas fa-calendar-times fa-2x"></i>
                    <p>No appointments found</p>
                </div>
            <?php } ?>
        </div>
        
        <!-- Pagination Controls -->
        <div class="pagination-container" id="pagination-container">
            <div class="pagination-info" id="pagination-info"></div>
            <div class="pagination-controls">
                <button class="pagination-btn" id="prev-page-btn" onclick="changePage(-1)" disabled>
                    <i class="fas fa-chevron-left"></i> Previous
                </button>
                <div class="pagination-numbers" id="pagination-numbers"></div>
                <button class="pagination-btn" id="next-page-btn" onclick="changePage(1)" disabled>
                    Next <i class="fas fa-chevron-right"></i>
                </button>
            </div>
        </div>
    </div>
</div>

<!-- Reschedule Modal -->
<div id="reschedModal" class="modal" style="display: none;">
    <div class="modal-content">
        <span class="close" onclick="closeReschedModal()">&times;</span>
        <h3><i class="fas fa-calendar-alt"></i> Reschedule Appointment</h3>
        <form id="rescheduleForm" onsubmit="handleRescheduleSubmit(event)">
            <input type="hidden" id="modalAppointmentID" name="appointment_id">
            
            <label for="new_date">Select New Date:</label>
            <input type="date" id="new_date_resched" name="new_date_resched" required min="<?= date('Y-m-d') ?>" onchange="loadBookedSlots()">

            <label for="new_time">Select New Time:</label>
            <select id="new_time_resched" name="new_time_slot" required>
                <option value="">Select Time Slot</option>
                <option value="firstBatch" data-slot="8AM-9AM">Morning (8AM-9AM)</option>
                <option value="secondBatch" data-slot="9AM-10AM">Morning (9AM-10AM)</option>
                <option value="thirdBatch" data-slot="10AM-11AM">Morning (10AM-11AM)</option>
                <option value="fourthBatch" data-slot="11AM-12PM">Afternoon (11AM-12PM)</option>
                <option value="fifthBatch" data-slot="1PM-2PM">Afternoon (1PM-2PM)</option>
                <option value="sixthBatch" data-slot="2PM-3PM">Afternoon (2PM-3PM)</option>
                <option value="sevenBatch" data-slot="3PM-4PM">Afternoon (3PM-4PM)</option>
                <option value="eightBatch" data-slot="4PM-5PM">Afternoon (4PM-5PM)</option>
                <option value="nineBatch" data-slot="5PM-6PM">Afternoon (5PM-6PM)</option>
                <option value="tenBatch" data-slot="6PM-7PM">Evening (6PM-7PM)</option>
                <option value="lastBatch" data-slot="7PM-8PM">Evening (7PM-8PM)</option>
            </select>

            <div style="display: flex; gap: 10px; justify-content: flex-end; margin-top: 20px; padding-top: 15px; border-top: 1px solid #e5e7eb; flex-wrap: wrap;">
                <button type="button" onclick="closeReschedModal()" class="btn modal-close-btn">Cancel</button>
                <button type="submit" class="btn btn-success">CONFIRM SCHEDULE</button>
            </div>
        </form>
    </div>
</div>

<!-- Complete Appointment Modal -->
<div id="complete-appointment-modal" class="complete-appointment-modal">
    <div class="complete-appointment-content">
        <div class="complete-appointment-header">
            <h3><i class="fa-solid fa-check-to-slot"></i>Complete Appointment</h3>
            <span class="complete-appointment-close">&times;</span>
        </div>
        <div class="complete-appointment-body">
            <form id="treatmentForm" onsubmit="handleTreatmentSubmit(event)">
                <input type="hidden" id="treatment_patient_id" name="patient_id">
                <input type="hidden" id="treatment_appointment_id" name="appointment_id">

                <div class="complete-appointment-form-group">
                    <label for="patient-id">Patient ID:</label>
                    <input type="text" id="patient_id" value="" readonly>
                </div>
                
                <div class="complete-appointment-form-group">
                    <label for="treatment_type">Treatment:</label>
                    <input type="text" id="treatment_type" name="treatment" required>
                </div>
                
                <div class="complete-appointment-form-group">
                    <label for="prescription_given">Prescription:</label>
                    <input type="text" id="prescription_given" name="prescription_given" required>
                </div>
                
                <div class="complete-appointment-form-group">
                    <label for="treatment_notes">Notes:</label>
                    <input type="text" id="treatment_notes" name="treatment_notes" required>
                </div>
                
                <div class="complete-appointment-form-group">
                    <label for="treatment_cost">Treatment Cost (₱):</label>
                    <input type="number" id="treatment_cost" name="treatment_cost" step="0.01" min="0" required>
                </div>
                
                <div class="complete-appointment-actions">
                    <button type="button" class="btn btn-danger" id="cancelCompleteAppointment">CANCEL</button>
                    <button type="submit" class="btn btn-completed">COMPLETE AND SAVE</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Follow-Up Modal -->
<div id="followUpModal" class="modal" style="display: none;">
    <div class="modal-content">
        <span class="close" onclick="closeFollowUpModal()">&times;</span>
        <h3><i class="fa-solid fa-arrow-right"></i> Schedule Follow-Up Appointment</h3>
        <form id="followUpForm" action="../controllers/saveFollowUp.php" method="POST">
            <input type="hidden" id="followup_patient_id" name="patient_id">
            <input type="hidden" id="followup_appointment_id" name="original_appointment_id">
            
            <label for="followup_patient_name">Patient Name:</label>
            <input type="text" id="followup_patient_name" name="patient_name" readonly required>

            <label for="followup_date">Follow-Up Date:</label>
            <input type="date" id="followup_date" name="appointment_date" required min="<?= date('Y-m-d', strtotime('+1 day')) ?>">

            <label for="followup_time">Follow-Up Time:</label>
            <select id="followup_time" name="time_slot" required>
                <option value="">Select Time</option>
                <option value="firstBatch">Morning (8AM-9AM)</option>
                <option value="secondBatch">Morning (9AM-10AM)</option>
                <option value="thirdBatch">Morning (10AM-11AM)</option>
                <option value="fourthBatch">Afternoon (11AM-12PM)</option>
                <option value="fifthBatch">Afternoon (1PM-2PM)</option>
                <option value="sixthBatch">Afternoon (2PM-3PM)</option>
                <option value="sevenBatch">Afternoon (3PM-4PM)</option>
                <option value="eightBatch">Afternoon (4PM-5PM)</option>
                <option value="nineBatch">Afternoon (5PM-6PM)</option>
                <option value="tenBatch">Evening (6PM-7PM)</option>
                <option value="lastBatch">Evening (7PM-8PM)</option>
            </select>

            <div style="display: flex; gap: 10px; justify-content: flex-end; margin-top: 20px; padding-top: 15px; border-top: 1px solid #e5e7eb; flex-wrap: wrap;">
                <button type="button" onclick="closeFollowUpModal()" class="btn modal-close-btn">Cancel</button>
                <button type="submit" class="btn btn-success">Save Follow-Up</button>
            </div>
        </form>
    </div>
</div>

<script>
    // Notification System
    function showNotification(type, title, message, iconHtml = '', duration = 5000) {
        const container = document.getElementById('notificationContainer');
        if (!container) return;
        
        const notification = document.createElement('div');
        notification.className = `notification ${type}`;
        
        const icon = iconHtml || (type === 'success' ? '<i class="fas fa-check-circle"></i>' :
                      type === 'warning' ? '<i class="fas fa-exclamation-triangle"></i>' :
                      type === 'error' ? '<i class="fas fa-times-circle"></i>' :
                      '<i class="fas fa-info-circle"></i>');
        
        notification.innerHTML = `
            <div style="flex-shrink: 0; font-size: 24px; color: ${type === 'success' ? '#10B981' : type === 'warning' ? '#F59E0B' : type === 'error' ? '#EF4444' : '#3B82F6'};">
                ${icon}
            </div>
            <div style="flex-grow: 1;">
                <div style="font-weight: 600; color: #111827; margin-bottom: 5px;">${title}</div>
                <div style="font-size: 14px; color: #6B7280;">${message}</div>
            </div>
            <button onclick="this.parentElement.remove()" style="background: transparent; border: none; color: #9CA3AF; cursor: pointer; font-size: 18px; padding: 0; width: 24px; height: 24px; display: flex; align-items: center; justify-content: center;">
                <i class="fas fa-times"></i>
            </button>
        `;
        
        container.appendChild(notification);
        
        setTimeout(() => {
            notification.style.animation = 'slideInRight 0.4s ease-out reverse';
            setTimeout(() => notification.remove(), 400);
        }, duration);
    }
    
    // Navigate back to admin
    function navigateBack(event) {
        if (event) event.preventDefault();
        const mainContent = document.querySelector('.main-content');
        if (mainContent) {
            mainContent.style.opacity = '0';
            mainContent.style.transition = 'opacity 0.3s ease-in-out';
        }
        setTimeout(() => {
            window.location.href = '../views/admin.php';
        }, 300);
        return false;
    }
    
    // Pagination Variables
    let currentPage = 1;
    const rowsPerPage = 5;
    
    // Handle Date Category Change
    function handleDateCategoryChange() {
        const dateCategory = document.getElementById("filter-date-category").value;
        const dateInput = document.getElementById("filter-date");
        
        if (dateCategory === "custom") {
            dateInput.style.display = "inline-block";
            dateInput.value = "";
        } else {
            dateInput.style.display = "none";
            dateInput.value = "";
            filterAppointments();
        }
    }
    
    // Filter appointments and update pagination
    function filterAppointments() {
        const dateCategory = document.getElementById("filter-date-category").value;
        const selectedDate = document.getElementById("filter-date").value;
        const selectedStatus = document.getElementById("filter-status").value.toLowerCase();
        // Get all appointment rows (includes both table rows TR and mobile cards div since cards have both classes)
        const allRows = document.querySelectorAll(".appointment-row");
        
        const today = new Date();
        today.setHours(0, 0, 0, 0);
        const todayStr = today.toISOString().split('T')[0];
        
        let weekStart = null, weekEnd = null;
        let monthStart = null, monthEnd = null;
        
        if (dateCategory === "week") {
            const dayOfWeek = today.getDay();
            const daysToMonday = dayOfWeek === 0 ? 6 : dayOfWeek - 1;
            weekStart = new Date(today);
            weekStart.setDate(today.getDate() - daysToMonday);
            weekStart.setHours(0, 0, 0, 0);
            weekEnd = new Date(weekStart);
            weekEnd.setDate(weekStart.getDate() + 6); // Monday to Sunday (7 days)
            weekEnd.setHours(23, 59, 59, 999);
        } else if (dateCategory === "month") {
            monthStart = new Date(today.getFullYear(), today.getMonth(), 1);
            monthStart.setHours(0, 0, 0, 0);
            monthEnd = new Date(today.getFullYear(), today.getMonth() + 1, 0);
            monthEnd.setHours(23, 59, 59, 999);
        }
        
        let visibleRows = [];
        
        // Helper function to check if date matches filter
        function matchesDateFilter(rowDate, dateCategory, selectedDate, todayStr, weekStart, weekEnd, monthStart, monthEnd) {
            if (dateCategory === "custom" && selectedDate) {
                return rowDate === selectedDate;
            } else if (dateCategory === "today") {
                return rowDate === todayStr;
            } else if (dateCategory === "week") {
                const rowDateObj = new Date(rowDate);
                rowDateObj.setHours(0, 0, 0, 0);
                return rowDateObj >= weekStart && rowDateObj <= weekEnd;
            } else if (dateCategory === "month") {
                const rowDateObj = new Date(rowDate);
                rowDateObj.setHours(0, 0, 0, 0);
                return rowDateObj >= monthStart && rowDateObj <= monthEnd;
            }
            return true; // "All Dates" or empty category
        }
        
        // Filter all appointment rows (both table rows and mobile cards)
        allRows.forEach(row => {
            const rowDate = row.getAttribute("data-date");
            const rowStatus = row.getAttribute("data-status") ? row.getAttribute("data-status").toLowerCase() : "";
            
            const matchesDate = matchesDateFilter(rowDate, dateCategory, selectedDate, todayStr, weekStart, weekEnd, monthStart, monthEnd);
            const matchesStatus = selectedStatus === "" || rowStatus === selectedStatus;
            
            if (matchesDate && matchesStatus) {
                row.setAttribute("data-visible", "true");
                visibleRows.push(row);
            } else {
                row.setAttribute("data-visible", "false");
            }
        });

        // Reset to first page when filtering
        currentPage = 1;
        
        // Update pagination with filtered results
        updatePagination(visibleRows);
        showPage(visibleRows, currentPage);
    }
    
    // Update pagination controls
    function updatePagination(visibleRows) {
        // Filter rows based on current view (mobile cards on mobile, table rows on desktop)
        const isMobileView = window.innerWidth <= 768;
        const filteredRows = visibleRows ? visibleRows.filter(row => {
            if (isMobileView) {
                return row.classList.contains('appointment-card');
            } else {
                return row.tagName === 'TR';
            }
        }) : [];
        
        const totalRows = filteredRows.length;
        const totalPages = Math.ceil(totalRows / rowsPerPage);
        const paginationContainer = document.getElementById("pagination-container");
        const paginationInfo = document.getElementById("pagination-info");
        const paginationNumbers = document.getElementById("pagination-numbers");
        const prevBtn = document.getElementById("prev-page-btn");
        const nextBtn = document.getElementById("next-page-btn");

        if (totalRows === 0) {
            paginationContainer.style.display = "none";
            return;
        }

        paginationContainer.style.display = "flex";

        const startRow = (currentPage - 1) * rowsPerPage + 1;
        const endRow = Math.min(currentPage * rowsPerPage, totalRows);
        paginationInfo.textContent = `Showing ${startRow}-${endRow} of ${totalRows} appointments`;

        prevBtn.disabled = currentPage === 1;
        nextBtn.disabled = currentPage >= totalPages;

        paginationNumbers.innerHTML = "";
        
        // Responsive: Show fewer page numbers on smaller screens
        const isMobile = window.innerWidth <= 768;
        const isSmallMobile = window.innerWidth <= 480;
        const maxPagesToShow = isSmallMobile ? 3 : isMobile ? 4 : 5;
        let startPage = Math.max(1, currentPage - Math.floor(maxPagesToShow / 2));
        let endPage = Math.min(totalPages, startPage + maxPagesToShow - 1);

        if (endPage - startPage < maxPagesToShow - 1) {
            startPage = Math.max(1, endPage - maxPagesToShow + 1);
        }

        if (startPage > 1) {
            createPageNumber(1, paginationNumbers);
            if (startPage > 2) {
                createEllipsis(paginationNumbers);
            }
        }

        for (let i = startPage; i <= endPage; i++) {
            createPageNumber(i, paginationNumbers);
        }

        if (endPage < totalPages) {
            if (endPage < totalPages - 1) {
                createEllipsis(paginationNumbers);
            }
            createPageNumber(totalPages, paginationNumbers);
        }
    }

    function createPageNumber(pageNum, container) {
        const pageBtn = document.createElement("button");
        pageBtn.className = "pagination-number" + (pageNum === currentPage ? " active" : "");
        pageBtn.textContent = pageNum;
        pageBtn.onclick = () => goToPage(pageNum);
        container.appendChild(pageBtn);
    }

    function createEllipsis(container) {
        const ellipsis = document.createElement("span");
        ellipsis.className = "pagination-number ellipsis";
        ellipsis.textContent = "...";
        container.appendChild(ellipsis);
    }

    function showPage(visibleRows, page) {
        if (!visibleRows || visibleRows.length === 0) {
            // Hide all rows if no visible rows
            document.querySelectorAll(".appointment-row").forEach(row => {
                if (row.tagName === 'TR') {
                    row.style.display = "none";
                } else if (row.classList.contains('appointment-card')) {
                    row.style.display = "none";
                }
            });
            return;
        }
        
        // Check if we're on mobile (table is hidden, mobile cards are shown)
        const isMobile = window.innerWidth <= 768;
        
        // Filter visibleRows to only include elements for current view
        const filteredRows = visibleRows.filter(row => {
            if (isMobile) {
                // On mobile: only show mobile cards
                return row.classList.contains('appointment-card');
            } else {
                // On desktop: only show table rows
                return row.tagName === 'TR';
            }
        });
        
        const startIndex = (page - 1) * rowsPerPage;
        const endIndex = startIndex + rowsPerPage;
        const rowsToShow = filteredRows.slice(startIndex, endIndex);

        // First, hide all appointment rows
        document.querySelectorAll(".appointment-row").forEach(row => {
            if (row.tagName === 'TR') {
                row.style.display = "none";
            } else if (row.classList.contains('appointment-card')) {
                row.style.display = "none";
            }
        });

        // Show only rows for current page
        rowsToShow.forEach(row => {
            if (row.tagName === 'TR') {
                // Table row: show on desktop
                row.style.display = "table-row";
            } else if (row.classList.contains('appointment-card')) {
                // Mobile card: show on mobile
                row.style.display = "block";
            }
        });
    }

    function goToPage(page) {
        // Get all currently visible rows based on filter
        const rows = document.querySelectorAll(".appointment-row[data-visible='true']");
        if (rows.length === 0) {
            updatePagination([]);
            showPage([], page);
            return;
        }

        currentPage = page;
        const visibleRows = Array.from(rows);
        updatePagination(visibleRows);
        showPage(visibleRows, currentPage);
    }

    function changePage(direction) {
        // Get all currently visible rows based on filter
        const rows = document.querySelectorAll(".appointment-row[data-visible='true']");
        if (rows.length === 0) return;

        const totalPages = Math.ceil(rows.length / rowsPerPage);
        const newPage = currentPage + direction;

        if (newPage >= 1 && newPage <= totalPages) {
            goToPage(newPage);
        }
    }
    
    // Confirm Appointment
    function confirmAppointment(button) {
        const appointmentId = button.getAttribute('data-appointment-id');
        if (!appointmentId) {
            showNotification('error', 'Error', 'Appointment ID not found. Please refresh the page.');
            return;
        }
        
        const formData = new FormData();
        formData.append('appointment_id', appointmentId);
        
        const originalHTML = button.innerHTML;
        const originalText = button.textContent.trim();
        button.disabled = true;
        // Preserve text if it exists (for mobile cards)
        if (originalText && originalText.length > 0 && !originalText.match(/^[<i]/)) {
            button.innerHTML = '<i class="fas fa-spinner fa-spin"></i> ' + originalText;
        } else {
            button.innerHTML = '<i class="fas fa-spinner fa-spin"></i>';
        }
        
        fetch('../controllers/confirmAppointment.php', {
            method: 'POST',
            body: formData
        })
        .then(response => {
            if (!response.ok) {
                throw new Error('Network response was not ok');
            }
            const contentType = response.headers.get("content-type");
            if (contentType && contentType.includes("application/json")) {
                return response.json();
            } else {
                return response.text().then(text => {
                    // Try to parse as JSON if possible
                    try {
                        return JSON.parse(text);
                    } catch {
                        return { success: true };
                    }
                });
            }
        })
        .then(data => {
            if (data.success || data.status === 'success' || !data.message) {
                showNotification('success', 'Appointment Confirmed', `Appointment #${appointmentId} has been confirmed.`);
                setTimeout(() => {
                    location.reload();
                }, 1500);
            } else {
                showNotification('error', 'Error', data.message || 'Failed to confirm appointment. Please try again.');
                button.disabled = false;
                button.innerHTML = originalHTML;
            }
        })
        .catch(error => {
            console.error('Error:', error);
            showNotification('error', 'Error', 'An error occurred while confirming the appointment. Please try again.');
            button.disabled = false;
            button.innerHTML = originalHTML;
        });
    }
    
    // Mark No-Show
    function markNoShow(button) {
        const appointmentId = button.getAttribute('data-appointment-id');
        if (!appointmentId) {
            showNotification('error', 'Error', 'Appointment ID not found. Please refresh the page.');
            return;
        }
        
        const formData = new FormData();
        formData.append('appointment_id', appointmentId);
        
        const originalHTML = button.innerHTML;
        const originalText = button.textContent.trim();
        button.disabled = true;
        // Preserve text if it exists (for mobile cards)
        if (originalText && originalText.length > 0 && !originalText.match(/^[<i]/)) {
            button.innerHTML = '<i class="fas fa-spinner fa-spin"></i> ' + originalText;
        } else {
            button.innerHTML = '<i class="fas fa-spinner fa-spin"></i>';
        }
        
        fetch('../controllers/noshowAppointment.php', {
            method: 'POST',
            body: formData
        })
        .then(response => {
            if (!response.ok) {
                throw new Error('Network response was not ok');
            }
            const contentType = response.headers.get("content-type");
            if (contentType && contentType.includes("application/json")) {
                return response.json();
            } else {
                return response.text().then(text => {
                    try {
                        return JSON.parse(text);
                    } catch {
                        return { success: true };
                    }
                });
            }
        })
        .then(data => {
            if (data.success || data.status === 'success' || !data.message) {
                showNotification('success', 'Marked as No-Show', `Appointment #${appointmentId} has been marked as no-show.`);
                setTimeout(() => {
                    location.reload();
                }, 1500);
            } else {
                showNotification('error', 'Error', data.message || 'Failed to mark as no-show. Please try again.');
                button.disabled = false;
                button.innerHTML = originalHTML;
            }
        })
        .catch(error => {
            console.error('Error:', error);
            showNotification('error', 'Error', 'An error occurred while marking as no-show. Please try again.');
            button.disabled = false;
            button.innerHTML = originalHTML;
        });
    }
    
    // Cancel Appointment by Admin
    function cancelAppointmentByAdmin(button) {
        const appointmentId = button.getAttribute('data-appointment-id');
        if (!appointmentId) {
            showNotification('error', 'Error', 'Appointment ID not found. Please refresh the page.');
            return;
        }
        
        if (!confirm(`Are you sure you want to cancel Appointment #${appointmentId}? An email notification will be sent to the patient.`)) {
            return;
        }
        
        const formData = new FormData();
        formData.append('appointment_id', appointmentId);
        
        const originalHTML = button.innerHTML;
        const originalText = button.textContent.trim();
        button.disabled = true;
        // Preserve text if it exists (for mobile cards)
        if (originalText && originalText.length > 0 && !originalText.match(/^[<i]/)) {
            button.innerHTML = '<i class="fas fa-spinner fa-spin"></i> ' + originalText;
        } else {
            button.innerHTML = '<i class="fas fa-spinner fa-spin"></i>';
        }
        
        fetch('../controllers/adminCancelAppointment.php', {
            method: 'POST',
            body: formData
        })
        .then(response => {
            if (!response.ok) {
                throw new Error('Network response was not ok');
            }
            const contentType = response.headers.get("content-type");
            if (contentType && contentType.includes("application/json")) {
                return response.json();
            } else {
                return response.text().then(text => {
                    try {
                        return JSON.parse(text);
                    } catch {
                        return { success: true };
                    }
                });
            }
        })
        .then(data => {
            if (data.success) {
                showNotification('success', 'Appointment Cancelled', data.message || 'Appointment has been cancelled and email notification sent.');
                setTimeout(() => {
                    location.reload();
                }, 1500);
            } else {
                showNotification('error', 'Error', data.error || data.message || 'Failed to cancel appointment. Please try again.');
                button.disabled = false;
                button.innerHTML = originalHTML;
            }
        })
        .catch(error => {
            console.error('Error:', error);
            showNotification('error', 'Error', 'An error occurred while cancelling the appointment. Please try again.');
            button.disabled = false;
            button.innerHTML = originalHTML;
        });
    }
    
    // Handle Reschedule Form Submit
    function handleRescheduleSubmit(event) {
        event.preventDefault();
        
        const form = event.target;
        const formData = new FormData(form);
        const appointmentId = document.getElementById('modalAppointmentID').value;
        const newDate = document.getElementById('new_date_resched').value;
        const timeSelect = document.getElementById('new_time_resched');
        const timeText = timeSelect.options[timeSelect.selectedIndex].text;
        
        const submitBtn = form.querySelector('button[type="submit"]');
        const originalText = submitBtn.innerHTML;
        submitBtn.disabled = true;
        submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Processing...';
        
        fetch('../controllers/rescheduleAppointment.php', {
            method: 'POST',
            body: formData
        })
        .then(response => {
            const contentType = response.headers.get("content-type");
            if (contentType && contentType.includes("application/json")) {
                return response.json();
            } else {
                return { success: true };
            }
        })
        .then(data => {
            if (data.success || data.status === 'success' || !data.message) {
                showNotification('success', 'Appointment Rescheduled', `Appointment #${appointmentId} has been rescheduled to ${newDate} at ${timeText}.`);
                closeReschedModal();
                setTimeout(() => {
                    location.reload();
                }, 2000);
            } else {
                showNotification('error', 'Error', data.message || 'Failed to reschedule appointment. Please try again.');
                submitBtn.disabled = false;
                submitBtn.innerHTML = originalText;
            }
        })
        .catch(error => {
            console.error('Error:', error);
            showNotification('error', 'Error', 'An error occurred while rescheduling. Please try again.');
            submitBtn.disabled = false;
            submitBtn.innerHTML = originalText;
        });
    }
    
    // Reschedule functions
    function openReschedModalWithID(btn, event) {
        if (event) {
            event.preventDefault();
        }
        const appointmentID = btn.getAttribute('data-id');
        
        if (!appointmentID) {
            showNotification('error', 'Error', 'Appointment ID not found. Please try again.');
            return false;
        }
        
        const modalAppointmentIDInput = document.getElementById('modalAppointmentID');
        if (modalAppointmentIDInput) {
            modalAppointmentIDInput.value = appointmentID;
        }
        
        const reschedForm = document.querySelector('#reschedModal form');
        if (reschedForm) {
            const dateInput = reschedForm.querySelector('#new_date_resched');
            const timeSelect = reschedForm.querySelector('#new_time_resched');
            if (dateInput) dateInput.value = '';
            if (timeSelect) timeSelect.value = '';
            if (modalAppointmentIDInput) modalAppointmentIDInput.value = appointmentID;
        }
        
        openReschedModal();
        return false;
    }

    function loadBookedSlots() {
        const dateInput = document.getElementById('new_date_resched');
        const timeSelect = document.getElementById('new_time_resched');
        
        if (!dateInput.value) {
            const options = timeSelect.querySelectorAll('option:not(:first-child)');
            options.forEach(opt => {
                opt.disabled = false;
                opt.textContent = opt.textContent.replace(' (Booked)', '');
            });
            return;
        }
        
        fetch(`../controllers/getAppointmentsAdminResched.php?new_date_resched=${dateInput.value}`)
            .then(response => response.json())
            .then(bookedSlots => {
                const slotMapping = {
                    'firstBatch': '8AM-9AM',
                    'secondBatch': '9AM-10AM',
                    'thirdBatch': '10AM-11AM',
                    'fourthBatch': '11AM-12PM',
                    'fifthBatch': '1PM-2PM',
                    'sixthBatch': '2PM-3PM',
                    'sevenBatch': '3PM-4PM',
                    'eightBatch': '4PM-5PM',
                    'nineBatch': '5PM-6PM',
                    'tenBatch': '6PM-7PM',
                    'lastBatch': '7PM-8PM'
                };
                
                const options = timeSelect.querySelectorAll('option');
                options.forEach(opt => {
                    if (opt.value === '') return;
                    
                    const slotTime = slotMapping[opt.value];
                    const isBooked = bookedSlots.includes(opt.value) || bookedSlots.includes(slotTime);
                    
                    opt.disabled = isBooked;
                    
                    const baseLabel = opt.textContent.split(' (Booked)')[0];
                    opt.textContent = baseLabel + (isBooked ? ' (Booked)' : '');
                });
                
                timeSelect.value = '';
            })
            .catch(error => {
                console.error('Error loading booked slots:', error);
                showNotification('error', 'Error', 'Failed to load available time slots. Please try again.');
            });
    }

    function openReschedModal() {
        const modal = document.getElementById("reschedModal");
        if (modal) {
            modal.style.display = "block";
            document.body.style.overflow = 'hidden';
        }
    }

    function closeReschedModal() {
        const modal = document.getElementById("reschedModal");
        if (modal) {
            modal.style.display = "none";
            document.body.style.overflow = 'auto';
            const form = document.querySelector('#reschedModal form');
            if (form) form.reset();
        }
    }
    
    // Complete Appointment Modal
    function openCompleteAppointmentModal(button) {
        const patientId = button.getAttribute('data-patientid');
        const appointmentId = button.getAttribute('data-appointmentid');
        
        if (!patientId || !appointmentId) {
            showNotification('error', 'Error', 'Missing patient or appointment information.');
            return;
        }
        
        const modal = document.getElementById('complete-appointment-modal');
        const patientIdInput = document.getElementById('treatment_patient_id');
        const appointmentIdInput = document.getElementById('treatment_appointment_id');
        const patientIdDisplay = document.getElementById('patient_id');
        
        if (!modal) {
            showNotification('error', 'Error', 'Modal not found. Please refresh the page.');
            return;
        }
        
        if (!patientIdInput || !appointmentIdInput || !patientIdDisplay) {
            showNotification('error', 'Error', 'Form elements not found. Please refresh the page.');
            return;
        }
        
        patientIdInput.value = patientId;
        appointmentIdInput.value = appointmentId;
        patientIdDisplay.value = patientId;

        modal.style.display = 'block';
        document.body.style.overflow = 'hidden';
    }

    function closeCompleteAppointmentModal() {
        const modal = document.getElementById('complete-appointment-modal');
        if (modal) {
            modal.style.display = 'none';
            document.body.style.overflow = 'auto';
        }
    }
    
    // Handle Treatment Form Submit
    function handleTreatmentSubmit(event) {
        event.preventDefault();
        
        const form = event.target;
        const formData = new FormData(form);
        const appointmentId = document.getElementById('treatment_appointment_id').value;
        
        const submitBtn = form.querySelector('button[type="submit"]');
        const originalText = submitBtn.innerHTML;
        submitBtn.disabled = true;
        submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Saving...';
        
        fetch('../controllers/saveTreatment.php', {
            method: 'POST',
            body: formData
        })
        .then(response => {
            if (!response.ok) {
                throw new Error('Network response was not ok: ' + response.status);
            }
            
            const contentType = response.headers.get("content-type");
            if (contentType && contentType.includes("application/json")) {
                return response.json();
            } else {
                return response.text().then(text => {
                    text = text.trim();
                    const jsonMatch = text.match(/\{[\s\S]*\}/);
                    if (jsonMatch) {
                        try {
                            return JSON.parse(jsonMatch[0]);
                        } catch (e) {
                            throw new Error('Invalid JSON response: ' + text.substring(0, 100));
                        }
                    }
                    throw new Error('No JSON found in response: ' + text.substring(0, 100));
                });
            }
        })
        .then(data => {
            if (data.success === true || data.status === 'success') {
                showNotification('success', 'Appointment Completed', `Appointment #${appointmentId} has been completed and treatment saved.`);
                closeCompleteAppointmentModal();
                form.reset();
                setTimeout(() => {
                    location.reload();
                }, 2000);
            } else {
                const errorMsg = data.message || 'Failed to save treatment. Please try again.';
                showNotification('error', 'Error', errorMsg);
                submitBtn.disabled = false;
                submitBtn.innerHTML = originalText;
            }
        })
        .catch(error => {
            console.error('Fetch error:', error);
            showNotification('error', 'Error', 'An error occurred while saving treatment: ' + error.message);
            submitBtn.disabled = false;
            submitBtn.innerHTML = originalText;
        });
    }
    
    // Follow-Up Modal
    function openFollowUpModal(button) {
        const appointmentId = button.getAttribute('data-appointment-id');
        const patientId = button.getAttribute('data-patient-id');
        const patientName = button.getAttribute('data-patient-name');
        
        const patientIdInput = document.getElementById('followup_patient_id');
        const appointmentIdInput = document.getElementById('followup_appointment_id');
        const patientNameInput = document.getElementById('followup_patient_name');
        
        if (patientIdInput) patientIdInput.value = patientId;
        if (appointmentIdInput) appointmentIdInput.value = appointmentId;
        if (patientNameInput) patientNameInput.value = patientName;
        
        const modal = document.getElementById('followUpModal');
        if (modal) {
            modal.style.display = 'block';
            document.body.style.overflow = 'hidden';
        }
    }
    
    function closeFollowUpModal() {
        const modal = document.getElementById('followUpModal');
        if (modal) {
            modal.style.display = 'none';
            document.body.style.overflow = 'auto';
            const form = document.getElementById('followUpForm');
            if (form) form.reset();
        }
    }
    
    function printAppointments() {
        window.print();
    }
    
    // Add Appointment Modal Functions (placeholder - implement if needed)
    function openAddAppointmentModal() {
        showNotification('info', 'Coming Soon', 'Add appointment functionality will be available soon.');
    }
    
    // Event listeners
    document.addEventListener('DOMContentLoaded', function() {
        const allRows = document.querySelectorAll(".appointment-row");
        const allCards = document.querySelectorAll(".appointment-card");
        
        allRows.forEach(row => {
            row.setAttribute("data-visible", "true");
        });
        
        allCards.forEach(card => {
            card.setAttribute("data-visible", "true");
        });

        setTimeout(() => {
            filterAppointments();
        }, 100);
        
        // Update pagination on window resize for responsive behavior
        let resizeTimeout;
        let lastWidth = window.innerWidth;
        window.addEventListener('resize', function() {
            clearTimeout(resizeTimeout);
            resizeTimeout = setTimeout(function() {
                const currentWidth = window.innerWidth;
                const wasMobile = lastWidth <= 768;
                const isMobile = currentWidth <= 768;
                
                // If switching between mobile and desktop, refresh pagination
                if (wasMobile !== isMobile) {
                    const rows = document.querySelectorAll(".appointment-row[data-visible='true']");
                    if (rows.length > 0) {
                        const visibleRows = Array.from(rows);
                        // Reset to page 1 when switching views
                        currentPage = 1;
                        updatePagination(visibleRows);
                        showPage(visibleRows, currentPage);
                    }
                } else {
                    // Just update pagination display
                    const rows = document.querySelectorAll(".appointment-row[data-visible='true']");
                    if (rows.length > 0) {
                        const visibleRows = Array.from(rows);
                        updatePagination(visibleRows);
                        showPage(visibleRows, currentPage);
                    }
                }
                lastWidth = currentWidth;
            }, 250);
        });
        
        // Complete appointment modal close
        const completeModal = document.getElementById('complete-appointment-modal');
        if (completeModal) {
            const closeBtn = completeModal.querySelector('.complete-appointment-close');
            const cancelBtn = document.getElementById('cancelCompleteAppointment');
            
            if (closeBtn) {
                closeBtn.addEventListener('click', closeCompleteAppointmentModal);
            }
            
            if (cancelBtn) {
                cancelBtn.addEventListener('click', closeCompleteAppointmentModal);
            }
            
            window.addEventListener('click', function(event) {
                if (event.target === completeModal) {
                    closeCompleteAppointmentModal();
                }
            });
        }
        
        // Close modals when clicking outside
        window.addEventListener('click', function(event) {
            const reschedModal = document.getElementById('reschedModal');
            const followUpModal = document.getElementById('followUpModal');
            
            if (event.target === reschedModal) {
                closeReschedModal();
            }
            if (event.target === followUpModal) {
                closeFollowUpModal();
            }
        });
    });
</script>

</body>
</html>
