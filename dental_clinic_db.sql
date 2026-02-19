-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Feb 19, 2026 at 01:50 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `dental_clinic_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `appointments`
--

CREATE TABLE `appointments` (
  `appointment_id` varchar(10) NOT NULL,
  `patient_id` varchar(10) NOT NULL,
  `team_id` varchar(10) NOT NULL,
  `service_id` varchar(10) NOT NULL,
  `branch` varchar(20) NOT NULL,
  `appointment_date` date NOT NULL,
  `appointment_time` varchar(20) NOT NULL,
  `time_slot` enum('firstBatch','secondBatch','thirdBatch','fourthBatch','fifthBatch','sixthBatch','sevenBatch','eightBatch','nineBatch','tenBatch','lastBatch') NOT NULL,
  `status` enum('Pending','Confirmed','Reschedule','Completed','Cancelled','No-show','Follow-Up') DEFAULT NULL,
  `ticket_code` varchar(32) DEFAULT NULL,
  `ticket_expires_at` datetime DEFAULT NULL,
  `ticket_status` enum('issued','used','expired') NOT NULL DEFAULT 'issued',
  `arrival_verified` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `appointments`
--

INSERT INTO `appointments` (`appointment_id`, `patient_id`, `team_id`, `service_id`, `branch`, `appointment_date`, `appointment_time`, `time_slot`, `status`, `ticket_code`, `ticket_expires_at`, `ticket_status`, `arrival_verified`, `created_at`) VALUES
('A001', 'P001', 'T001', 'S002', 'Comembo Branch', '2025-11-26', '9:00AM-10:00AM', 'secondBatch', 'Confirmed', NULL, NULL, 'issued', 0, '2025-11-22 00:47:18'),
('A002', 'P002', 'T001', 'S1001', 'Comembo Branch', '2025-12-23', '11:00AM-12:00PM', 'fourthBatch', 'Cancelled', NULL, NULL, 'issued', 0, '2025-11-22 01:29:31'),
('A003', 'P003', 'T001', 'S003', 'Taytay Rizal Branch', '2025-11-26', '5:00PM-6:00PM', 'nineBatch', 'Cancelled', NULL, NULL, 'issued', 0, '2025-11-23 13:11:53'),
('A004', 'P004', 'T001', 'S1002', 'Comembo Branch', '2025-11-26', '1:00PM-2:00PM', 'fifthBatch', 'Completed', NULL, NULL, 'issued', 0, '2025-11-24 06:38:09'),
('A005', 'P005', 'T001', 'S1001', 'Comembo Branch', '2025-12-22', '10:00AM-11:00AM', 'thirdBatch', 'Completed', NULL, NULL, 'issued', 0, '2025-12-19 04:53:25'),
('A006', 'P006', 'T001', 'S002', 'Comembo Branch', '2026-01-29', '11:00AM-12:00PM', 'fourthBatch', 'Confirmed', 'BA62A48B', '2026-01-16 16:30:00', 'issued', 0, '2026-01-03 05:12:15'),
('A007', 'P006', 'T001', 'S001', 'Comembo Branch', '2026-01-16', '8:00AM-9:00AM', 'firstBatch', 'Confirmed', NULL, NULL, 'issued', 0, '2026-01-03 05:28:32'),
('A008', 'P007', 'T001', 'S002', 'Comembo Branch', '2026-02-27', '5:00PM-6:00PM', 'nineBatch', 'Reschedule', 'AD7D5821', '2026-01-23 15:30:00', 'used', 1, '2026-01-21 03:46:02'),
('A009', 'P008', 'T001', 'S002', 'Comembo Branch', '2026-01-29', '8:00AM-9:00AM', 'firstBatch', 'Pending', 'DE5328D3', '2026-01-29 09:30:00', 'used', 1, '2026-01-21 04:10:27'),
('A010', 'P001', 'T001', 'S1001', 'Comembo Branch', '2026-02-21', '7:00PM-8:00PM', 'lastBatch', 'Confirmed', NULL, NULL, 'issued', 0, '2026-02-10 09:03:19'),
('A011', 'P009', 'T001', 'S002', 'Comembo Branch', '2026-02-17', '9:00AM-10:00AM', 'secondBatch', 'Pending', NULL, NULL, 'issued', 0, '2026-02-17 00:33:24');

-- --------------------------------------------------------

--
-- Table structure for table `blocked_time_slots`
--

CREATE TABLE `blocked_time_slots` (
  `block_id` varchar(10) NOT NULL,
  `dentist_id` varchar(10) NOT NULL,
  `date` date NOT NULL,
  `time_slot` enum('firstBatch','secondBatch','thirdBatch','fourthBatch','fifthBatch','sixthBatch','sevenBatch','eightBatch','nineBatch','tenBatch','lastBatch') NOT NULL,
  `reason` varchar(255) NOT NULL,
  `created_by` varchar(10) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `blocked_time_slots`
--

INSERT INTO `blocked_time_slots` (`block_id`, `dentist_id`, `date`, `time_slot`, `reason`, `created_by`, `created_at`, `updated_at`) VALUES
('BLK002', 'T001', '2026-02-10', 'secondBatch', 'Blocked by admin', 'U0005', '2026-02-13 07:21:49', '2026-02-13 07:21:49'),
('BLK003', 'T001', '2026-02-14', 'eightBatch', 'Blocked by admin', 'U0005', '2026-02-13 07:32:20', '2026-02-13 07:32:20'),
('BLK004', 'T001', '2026-02-09', 'sixthBatch', 'Blocked by admin', 'U0005', '2026-02-13 07:32:55', '2026-02-13 07:32:55');

-- --------------------------------------------------------

--
-- Table structure for table `clinic_closures`
--

CREATE TABLE `clinic_closures` (
  `id` int(11) NOT NULL,
  `closure_date` date NOT NULL,
  `closure_type` enum('full_day','no_new_appointments') NOT NULL DEFAULT 'full_day',
  `reason` varchar(255) NOT NULL,
  `status` enum('active','inactive') NOT NULL DEFAULT 'active',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `clinic_closures`
--

INSERT INTO `clinic_closures` (`id`, `closure_date`, `closure_type`, `reason`, `status`, `created_at`) VALUES
(6, '2025-11-26', 'full_day', 'Weather', 'inactive', '2025-11-23 12:56:04'),
(7, '2025-11-30', 'full_day', 'Holiday: Bonifacio Day', 'inactive', '2025-11-23 12:59:35'),
(8, '2025-11-27', 'full_day', 'Emergency: Dentist Feel Sick', 'inactive', '2025-11-23 13:02:14'),
(9, '2025-11-24', 'full_day', 'Emergency: Vacation', 'inactive', '2025-11-23 13:03:41'),
(10, '2025-11-29', 'full_day', 'Emergency', 'active', '2025-11-24 07:05:57');

-- --------------------------------------------------------

--
-- Table structure for table `dental_blogs`
--

CREATE TABLE `dental_blogs` (
  `blog_id` varchar(10) NOT NULL,
  `title` varchar(20) NOT NULL,
  `content` text NOT NULL,
  `published_at` datetime DEFAULT NULL,
  `status` enum('published','draft','archived') DEFAULT 'draft',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `dental_blogs`
--

INSERT INTO `dental_blogs` (`blog_id`, `title`, `content`, `published_at`, `status`, `created_at`) VALUES
('B001', 'Unlock Your Best Smi', 'Hey there, smile squad! What truly makes a dazzling, healthy smile? It’s consistent daily care! We believe a radiant smile boosts your confidence and overall well-being.\n\nLet\'s talk essentials:\n*   **Brush Up!** Aim for two minutes, twice a day, with fluoride toothpaste. Think of it as a mini-spa for your teeth!\n*   **Floss is Boss!** Don\'t skip this crucial step. Flossing daily removes plaque between teeth, preventing cavities and gum disease.\n*   **Rinse & Shine:** A good mouthwash can be a fantastic addition, helping reduce bacteria and freshen your breath.\n\nRemember, regular check-ups with us are your secret weapon for keeping everything in tip-top shape. We\'re here to support your journey to a healthy, happy smile that truly shines. Keep those pearly whites gleaming!', '2025-11-12 16:09:46', 'published', '2025-11-12 08:09:46'),
('B002', 'Unlock Your Confiden', 'Your smile is a powerful tool – it brightens your day and connects you with others! At our modern clinic, we believe everyone deserves a healthy, radiant smile. The best part? Achieving it is simpler than you think with just a few consistent habits.\n\nStart with the essentials: brush for two minutes, twice a day, using fluoride toothpaste. This daily ritual effectively removes food particles and fights plaque buildup. Don\'t skip flossing! It\'s your secret weapon against hidden plaque between teeth and under the gum line, preventing cavities and gum disease. A quick swish with an antimicrobial mouthwash can offer an extra boost of freshness.\n\nBeyond your daily routine, consider what you eat. Limiting sugary snacks and drinks reduces fuel for harmful bacteria. And crucially, don\'t forget your regular dental check-ups and cleanings! These professional visits are vital for early detection, prevention, and keeping your oral health in peak condition. Let\'s keep your smile sparkling bright!', '2025-11-13 13:18:01', 'published', '2025-11-13 05:18:01'),
('B003', 'Your Daily Dose of D', 'Ever wonder what makes a smile truly radiant? It\'s more than just genetics; it\'s a consistent routine of care and a little bit of love! Here at [Your Clinic Name], we believe everyone deserves to flash their brightest grin with confidence.\n\nYour journey to a healthier, happier smile starts right at home. Remember the golden rules: brush twice a day for two minutes with fluoride toothpaste, and don\'t forget to floss daily to banish those hidden food particles and plaque. Consider a tongue scraper for fresher breath, too! What you eat plays a big role – fresh fruits and veggies help keep your gums healthy, while limiting sugary snacks protects against cavities.\n\nBut even the best home care needs a professional touch. Regular check-ups and cleanings are crucial for catching issues early and maintaining optimal oral health. Let\'s partner up to keep your smile sparkling and your confidence soaring! Ready to glow? Schedule your next visit today!', '2025-11-22 19:34:57', 'published', '2025-11-22 11:34:57'),
('B004', 'Dental Health Tip of', 'Keep your smile healthy by brushing twice a day and visiting your dentist regularly!', '2025-11-23 20:38:31', 'published', '2025-11-23 12:38:31'),
('B005', 'Dental Health Tip of', 'Keep your smile healthy by brushing twice a day and visiting your dentist regularly!', '2025-12-26 11:19:51', 'published', '2025-12-26 03:19:51'),
('B006', 'Dental Health Tip of', 'Keep your smile healthy by brushing twice a day and visiting your dentist regularly!', '2026-01-03 13:40:13', 'published', '2026-01-03 05:40:13'),
('B007', 'Dental Health Tip of', 'Keep your smile healthy by brushing twice a day and visiting your dentist regularly!', '2026-01-08 09:00:16', 'published', '2026-01-08 01:00:16'),
('B008', 'Dental Health Tip of', 'Keep your smile healthy by brushing twice a day and visiting your dentist regularly!', '2026-02-03 08:52:23', 'published', '2026-02-03 00:52:23'),
('B009', 'Dental Health Tip of', 'Keep your smile healthy by brushing twice a day and visiting your dentist regularly!', '2026-02-14 13:36:15', 'published', '2026-02-14 05:36:15');

-- --------------------------------------------------------

--
-- Table structure for table `dentist_schedule`
--

CREATE TABLE `dentist_schedule` (
  `schedule_id` varchar(10) NOT NULL,
  `dentist_id` varchar(10) NOT NULL,
  `date` date NOT NULL,
  `time_slot` enum('firstBatch','secondBatch','thirdBatch','fourthBatch','fifthBatch','sixthBatch','sevenBatch','eightBatch','nineBatch','tenBatch','lastBatch') NOT NULL,
  `status` enum('available','blocked','booked') DEFAULT 'available',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `dentist_schedule`
--

INSERT INTO `dentist_schedule` (`schedule_id`, `dentist_id`, `date`, `time_slot`, `status`, `created_at`, `updated_at`) VALUES
('DS001', 'T001', '2025-11-12', 'secondBatch', 'available', '2025-11-03 13:47:47', '2025-11-03 13:47:47');

-- --------------------------------------------------------

--
-- Table structure for table `feedback`
--

CREATE TABLE `feedback` (
  `feedback_id` int(11) NOT NULL,
  `user_id` varchar(50) NOT NULL,
  `patient_name` varchar(100) NOT NULL,
  `feedback_text` text NOT NULL,
  `appointment_id` int(11) DEFAULT NULL,
  `status` enum('pending','approved','rejected') DEFAULT 'pending',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `feedback`
--

INSERT INTO `feedback` (`feedback_id`, `user_id`, `patient_name`, `feedback_text`, `appointment_id`, `status`, `created_at`, `updated_at`) VALUES
(1, 'U0007', 'Von Sabado', 'Im So Happy and Satisfied', 0, 'approved', '2025-11-22 08:58:51', '2025-11-22 08:58:51'),
(2, 'U0009', 'Charmmain Rabano', 'The treatment is nice and fast.', 0, 'approved', '2025-11-24 07:13:06', '2025-11-24 07:13:06');

-- --------------------------------------------------------

--
-- Table structure for table `holidays`
--

CREATE TABLE `holidays` (
  `id` int(11) NOT NULL,
  `holiday_name` varchar(255) NOT NULL,
  `holiday_date` date NOT NULL,
  `recurrence` enum('once','yearly') NOT NULL DEFAULT 'once',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `multidisciplinary_dental_team`
--

CREATE TABLE `multidisciplinary_dental_team` (
  `team_id` varchar(10) NOT NULL,
  `user_id` varchar(10) NOT NULL,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `specialization` varchar(50) NOT NULL,
  `email` varchar(50) NOT NULL,
  `phone` varchar(20) NOT NULL,
  `status` enum('active','inactive') NOT NULL,
  `last_active` datetime DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `multidisciplinary_dental_team`
--

INSERT INTO `multidisciplinary_dental_team` (`team_id`, `user_id`, `first_name`, `last_name`, `specialization`, `email`, `phone`, `status`, `last_active`, `created_at`) VALUES
('T001', 'U0005', 'Michelle', 'Landero', 'Dentist', 'arisukazamoto@gmail.com', '0919299223', 'active', '2026-02-17 09:35:59', '2025-11-03 01:51:03');

-- --------------------------------------------------------

--
-- Table structure for table `patient_information`
--

CREATE TABLE `patient_information` (
  `patient_id` varchar(10) NOT NULL,
  `user_id` varchar(10) NOT NULL,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `birthdate` date NOT NULL,
  `gender` varchar(10) NOT NULL,
  `phone` varchar(20) NOT NULL,
  `email` varchar(50) NOT NULL,
  `address` varchar(50) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `patient_information`
--

INSERT INTO `patient_information` (`patient_id`, `user_id`, `first_name`, `last_name`, `birthdate`, `gender`, `phone`, `email`, `address`, `created_at`) VALUES
('P001', 'U0001', 'Vince Henrick', 'Padilla', '2015-11-04', 'Male', '09938383851', 'kirito.nakamura7@gmail.com', 'Lawin St Taguig City', '2025-11-22 00:47:18'),
('P002', 'U0007', 'Von', 'Sabado', '2007-11-07', 'male', '09287977979', 'vonjeresespi1@gmail.com', 'Lawin St Taguig City', '2025-11-22 01:29:31'),
('P003', 'U0010', 'Charles', 'Ramos', '2004-11-18', 'male', '02934023432', 'flowprince4@gmail.com', 'Anahaw St, Brgy Comembo, Taguig City, 1284', '2025-11-23 13:11:53'),
('P004', 'U0009', 'Charmmain', 'Rabano', '2007-07-02', 'Female', '09286765072', 'winoc52801@fermiro.com', 'Miyapis St Makati City', '2025-11-24 06:38:09'),
('P005', 'U0012', 'Arzen', 'Navor', '2007-12-12', 'male', '09778776562', 'arzennavor@gmail.com', 'Sta Cruz, Taytay Rizal', '2025-12-19 04:53:25'),
('P006', 'U0013', 'Mike', 'Wheeler', '1994-07-25', 'male', '09528676520', 'yaweti1928@hudisk.com', '112 Lincoln Ave Hawkings Sub', '2026-01-03 05:02:50'),
('P007', 'U0014', 'Jane', 'Cruz', '2008-01-10', 'male', '09556765130', 'mikewheelerpogi@gmail.com', 'Bldg 6 Doctor Jose P. Rizal Extension', '2026-01-21 01:21:43'),
('P008', 'U0011', 'Juan', 'Dela Cruz', '2004-06-15', 'male', '09286765204', 'mlanderodentalclinic@gmail.com', 'Sta Cruz, Taytay Rizal', '2026-01-21 04:10:27'),
('P009', 'U0015', 'Mark', 'Laungayan', '2008-02-13', 'male', '09887979656', 'uzumakinaruto6012@gmail.com', 'Lawin St Taguig City', '2026-02-17 00:33:24');

-- --------------------------------------------------------

--
-- Table structure for table `payment`
--

CREATE TABLE `payment` (
  `payment_id` varchar(10) NOT NULL,
  `appointment_id` varchar(10) NOT NULL,
  `method` varchar(50) NOT NULL,
  `account_name` varchar(50) NOT NULL,
  `account_number` varchar(50) NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `reference_no` varchar(100) DEFAULT NULL,
  `proof_image` varchar(255) DEFAULT NULL,
  `status` enum('pending','paid','refunded','failed') DEFAULT 'pending',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `payment`
--

INSERT INTO `payment` (`payment_id`, `appointment_id`, `method`, `account_name`, `account_number`, `amount`, `reference_no`, `proof_image`, `status`, `created_at`) VALUES
('PY001', 'A001', 'GCash', 'Vince Padilla', '09879975305', 500.00, '232441', 'uploads/69210816285df_GCash-iBayad_Umak-Receipt-13012025095001.PNG.jpg', 'paid', '2025-11-22 00:47:18'),
('PY002', 'A002', 'PayMaya', 'Von Jeres Sabado', '0938488488', 500.00, '132243', 'uploads/692111fb4ead4_Pay-QR4-1.jpg', 'pending', '2025-11-22 01:29:31'),
('PY003', 'A003', 'GCash', 'Charles Ramos', '09777855415', 500.00, '497965', 'uploads/692308199dfcc_GCash-iBayad_Umak-Receipt-21072025123636.PNG.jpg', 'paid', '2025-11-23 13:11:53'),
('PY004', 'A004', 'GCash', 'Charmmain Lepiten', '09777855415', 500.00, '49796576', 'uploads/6923fd5148c53_dvlogo2.png', 'paid', '2025-11-24 06:38:09'),
('PY005', 'A005', 'GCash', 'Arzen', '09897797975', 500.00, '383884', 'uploads/6944da44f4214_compressedImage.jpeg', 'paid', '2025-12-19 04:53:25'),
('PY006', 'A006', 'Cash', '', '', 500.00, '', '', 'pending', '2026-01-03 05:12:15'),
('PY007', 'A007', 'PayMaya', 'Mike Wheeler', '099878797655', 500.00, '4894886', '../uploads/6958a900331dc_52ae186ab065f0b6d7a09fbc1f896240.jpg', 'pending', '2026-01-03 05:28:32'),
('PY008', 'A008', 'Cash', '', '', 500.00, '', '', 'paid', '2026-01-21 03:46:02'),
('PY009', 'A009', 'Cash', '', '', 500.00, '', '', 'pending', '2026-01-21 04:10:27'),
('PY010', 'A010', 'GCash', 'Kenneth Jana', '09939588662', 1232131.00, '89976564', '../uploads/698af456ed745_unnamed__2_.png', 'pending', '2026-02-10 09:03:19'),
('PY011', 'A011', 'GCash', 'Mark Laungayan', '09879795632', 500.00, '3435362', '../uploads/6993b754ad7e4_9fe5cb4cf8686749c231fe849612f6f0.jpg', 'pending', '2026-02-17 00:33:24');

-- --------------------------------------------------------

--
-- Table structure for table `promotional_emails`
--

CREATE TABLE `promotional_emails` (
  `id` int(11) NOT NULL,
  `user_id` varchar(20) DEFAULT NULL,
  `email` varchar(255) NOT NULL,
  `subject` varchar(255) NOT NULL,
  `message` text NOT NULL,
  `sent_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `services`
--

CREATE TABLE `services` (
  `service_id` varchar(10) NOT NULL,
  `service_category` varchar(50) NOT NULL,
  `sub_service` varchar(50) NOT NULL,
  `description` text NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `services`
--

INSERT INTO `services` (`service_id`, `service_category`, `sub_service`, `description`, `price`, `created_at`) VALUES
('S001', 'General Dentistry', 'Checkups', 'Routine dental checkups involve a comprehensive examination and cleaning to prevent oral disease, while a tooth extraction is the removal of a tooth that is too damaged or infected to be saved', 0.00, '2025-11-01 03:44:24'),
('S002', 'Orthodontics', 'Braces', 'To provide a comprehensive overview that captures the essential ideas while leaving out the non-essential details. A good summary is always much shorter than the original.', 0.00, '2025-11-02 00:37:46'),
('S003', 'Oral Surgery', 'Tooth Extraction (Bunot)', 'The professional, gentle removal of a tooth that is irreparably damaged, decayed, or causing crowding and infection. We prioritize patient comfort and use local anesthesia to ensure a smooth procedure, helping to protect the overall health of your mouth.', 0.00, '2025-11-09 11:02:31'),
('S004', 'Endodontics', 'Root Canal Treatment', 'A procedure to save a severely damaged tooth when the pulp (nerve) inside is infected or inflamed. We carefully clean, sterilize, and seal the internal root canal system to eliminate pain, infection, and the need for extraction, preserving the natural tooth structures', 0.00, '2025-11-09 11:01:04'),
('S005', 'Prosthodontics Treatments (Pustiso)', 'Crowns', 'Dental crowns are custom-made caps placed entirely over a damaged or weakened tooth. They are used to restore the tooth\'s shape, strength, and appearance following a root canal or extensive decay, providing protection and improving function.', 0.00, '2025-11-09 11:12:36'),
('S1001', 'General Dentistry', 'Oral Prophylaxis (Cleaning)', 'A professional dental cleaning is a procedure typically performed by a dental hygienist or dentist to thoroughly clean your teeth and maintain optimal oral health.', 0.00, '2025-11-02 00:33:50'),
('S1002', 'General Dentistry', 'Fluoride Application', 'Professional Fluoride Treatment Topical application to remineralize weak enamel and significantly reduce the risk of cavities, promoting long-term oral health for all ages.', 0.00, '2025-11-09 10:56:37'),
('S1003', 'General Dentistry', 'Pit & Fissure Sealants', 'A fast, painless, protective barrier applied to the chewing surfaces of back teeth (molars). This thin, tooth-colored coating instantly seals the deep grooves to block out food, plaque, and bacteria, effectively preventing over 80% of cavities in the sealed areas', 0.00, '2025-11-09 10:58:07'),
('S1004', 'General Dentistry', 'Tooth Restoration (Pasta)', 'A procedure to repair teeth damaged by decay, fractures, or cracks. We gently remove the damaged material and restore the tooth\'s shape, function, and appearance using durable, tooth-colored composite resin (or other chosen materials). This prevents further decay and eliminates sensitivity.', 0.00, '2025-11-09 10:59:55'),
('S2001', 'Orthodontics', 'Retainers', 'Custom-made dental appliances used after orthodontic treatment (like braces or aligners). Retainers are essential to stabilize and maintain the new position of your teeth, preventing them from shifting back and ensuring your beautifully straight smile lasts a lifetime.', 0.00, '2025-11-09 11:08:05'),
('S5001', 'Prosthodontics Treatments (Pustiso)', 'Dentures', 'Removable appliances that replace missing teeth and surrounding tissues. We provide full (complete) and partial dentures that are custom designed to restore your ability to chew, speak clearly, and improve your smile and facial contours.', 0.00, '2025-11-09 11:13:27');

-- --------------------------------------------------------

--
-- Table structure for table `system_alerts`
--

CREATE TABLE `system_alerts` (
  `alert_id` varchar(10) NOT NULL,
  `user_id` varchar(10) NOT NULL,
  `role` enum('dentist','patient','admin') NOT NULL,
  `title` varchar(255) NOT NULL,
  `message` text NOT NULL,
  `related_appointment_id` varchar(10) DEFAULT NULL,
  `is_read` tinyint(1) DEFAULT 0,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `system_alerts`
--

INSERT INTO `system_alerts` (`alert_id`, `user_id`, `role`, `title`, `message`, `related_appointment_id`, `is_read`, `created_at`) VALUES
('AL001', 'U0005', 'admin', 'Pending Appointment - Action Required', 'There is a pending appointment that requires your attention:\n\nPatient: Juan Dela Cruz\nService: Braces\nDentist: Dr. Michelle Landero\nDate: 2026-01-29\nTime: 8:00AM-9:00AM\n\nPlease review and confirm or cancel this appointment.', 'A009', 0, '2026-02-17 08:42:24'),
('AL002', 'U0005', 'admin', 'Pending Appointment - Action Required', 'There is a pending appointment that requires your attention:\n\nPatient: Mark Laungayan\nService: Braces\nDentist: Dr. Michelle Landero\nDate: 2026-02-17\nTime: 8:00AM-9:00AM\n\nPlease review and confirm or cancel this appointment.', 'A011', 0, '2026-02-17 08:42:24'),
('AL003', 'U0005', 'dentist', 'Inactivity Alert - Appointment with Vince Henrick Padilla', 'You have a confirmed appointment scheduled:\n\nPatient: Vince Henrick Padilla\nDate: 2026-02-21\nTime: 7:00PM-8:00PM\n\nPlease update your account status to active or contact the administrator.', 'A010', 0, '2026-02-17 08:52:13'),
('AL004', 'U0001', 'patient', 'Appointment Alert - Dentist Inactive', 'Your confirmed appointment may be affected:\n\nDentist: Dr. Michelle Landero\nDate: 2026-02-21\nTime: 7:00PM-8:00PM\n\nThe assigned dentist is currently inactive. Please contact the clinic for assistance.', 'A010', 0, '2026-02-17 08:52:13'),
('AL005', 'U0005', 'admin', 'Dentist Logged Out - Appointment Alert', 'Dr. Michelle Landero has logged out. They have an appointment with Mark Laungayan on February 18, 2026 at 3:00PM-4:00PM for Braces.', 'A011', 0, '2026-02-17 09:14:55'),
('AL006', 'U0005', 'admin', 'Dentist Logged Out - Appointment Alert', 'Dr. Michelle Landero has logged out. They have an appointment with Vince Henrick Padilla on February 21, 2026 at 7:00PM-8:00PM for Oral Prophylaxis (Cleaning).', 'A010', 0, '2026-02-17 09:14:55'),
('AL007', 'U0005', 'admin', 'Dentist Logged Out - Appointment Alert', 'Dr. Michelle Landero has logged out. They have an appointment with Jane Cruz on February 27, 2026 at 5:00PM-6:00PM for Braces.', 'A008', 0, '2026-02-17 09:14:55'),
('AL008', 'U0005', 'admin', 'Dentist Logged Out - Appointment Alert', 'Dr. Michelle Landero has logged out. They have an appointment with Mark Laungayan on February 18, 2026 at 3:00PM-4:00PM for Braces.', 'A011', 0, '2026-02-17 09:16:01'),
('AL009', 'U0005', 'admin', 'Dentist Logged Out - Appointment Alert', 'Dr. Michelle Landero has logged out. They have an appointment with Vince Henrick Padilla on February 21, 2026 at 7:00PM-8:00PM for Oral Prophylaxis (Cleaning).', 'A010', 0, '2026-02-17 09:16:01'),
('AL010', 'U0005', 'admin', 'Dentist Logged Out - Appointment Alert', 'Dr. Michelle Landero has logged out. They have an appointment with Jane Cruz on February 27, 2026 at 5:00PM-6:00PM for Braces.', 'A008', 0, '2026-02-17 09:16:01'),
('AL011', 'U0005', 'admin', 'Dentist Logged Out - Appointment Alert', 'Dr. Michelle Landero has logged out. They have an appointment with Mark Laungayan on February 17, 2026 at 9:00AM-10:00AM for Braces.', 'A011', 0, '2026-02-17 09:22:44'),
('AL012', 'U0005', 'admin', 'Dentist Logged Out - Appointment Alert', 'Dr. Michelle Landero has logged out. They have an appointment with Vince Henrick Padilla on February 21, 2026 at 7:00PM-8:00PM for Oral Prophylaxis (Cleaning).', 'A010', 0, '2026-02-17 09:22:44'),
('AL013', 'U0005', 'admin', 'Dentist Logged Out - Appointment Alert', 'Dr. Michelle Landero has logged out. They have an appointment with Jane Cruz on February 27, 2026 at 5:00PM-6:00PM for Braces.', 'A008', 0, '2026-02-17 09:22:44');

-- --------------------------------------------------------

--
-- Table structure for table `treatment_history`
--

CREATE TABLE `treatment_history` (
  `treatment_id` varchar(10) NOT NULL,
  `patient_id` varchar(10) NOT NULL,
  `treatment` varchar(50) NOT NULL,
  `prescription_given` varchar(50) NOT NULL,
  `treatment_cost` decimal(10,2) DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `treatment_history`
--

INSERT INTO `treatment_history` (`treatment_id`, `patient_id`, `treatment`, `prescription_given`, `treatment_cost`, `notes`, `created_at`, `updated_at`) VALUES
('TR0001', 'P002', 'Cleaning', 'None', 1000.00, 'N/A', '2025-11-22 09:58:07', '2025-11-22 09:58:07'),
('TR0002', 'P001', 'Braces', 'None', 20000.00, 'None', '2025-11-22 10:16:42', '2025-11-22 10:16:42'),
('TR0003', 'P004', 'Flouride', 'N/a', 500.00, 'N/A', '2025-11-24 07:58:13', '2025-11-24 07:58:13'),
('TR0004', 'P005', 'Cleaning', 'Anti Biotic', 400.00, 'None', '2026-01-22 12:47:48', '2026-01-22 12:47:48');

-- --------------------------------------------------------

--
-- Table structure for table `user_account`
--

CREATE TABLE `user_account` (
  `user_id` varchar(10) NOT NULL,
  `role` enum('patient','dentist','admin') NOT NULL,
  `status` enum('active','blocked') NOT NULL DEFAULT 'active',
  `last_login` timestamp NULL DEFAULT NULL,
  `username` varchar(50) NOT NULL,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `birthdate` date DEFAULT NULL,
  `gender` varchar(50) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `password_hash` varchar(255) NOT NULL,
  `email` varchar(50) NOT NULL,
  `phone` varchar(20) NOT NULL,
  `contactNumber_verify` enum('verified','not_verified') NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `user_account`
--

INSERT INTO `user_account` (`user_id`, `role`, `status`, `last_login`, `username`, `first_name`, `last_name`, `birthdate`, `gender`, `address`, `password_hash`, `email`, `phone`, `contactNumber_verify`, `created_at`) VALUES
('U0001', 'patient', 'active', '2026-02-17 00:08:33', 'vince', 'Vince Henrick', 'Padilla', '2015-11-04', 'Male', 'Lawin St Taguig City', '$2y$10$0iOkoTCVPQas8LMIlMJxR.Qn3Ct5szu0sFofMZO.BlcWyc4oB0XXm', 'kirito.nakamura7@gmail.com', '09938383851', 'verified', '2025-11-01 02:24:21'),
('U0003', 'patient', 'active', NULL, 'naruto12', 'Naruto', 'Uzumaki', '2015-11-15', 'Male', 'Pinagsama Taguig City', '$2y$10$3z4B7P1ZA1l8rbearzvOCu2tqa9oGTCIqi7gv/BDgM7JErvjb0F46', 'kirito.nakamura3@gmail.com', '09286765223', 'verified', '2025-11-01 05:28:23'),
('U0004', 'patient', 'active', NULL, 'ashley', 'Ashley', 'Gonzales', '2016-11-30', 'Male', 'Anahaw St Comembo Taguig City', '$2y$10$cKZ21NJJca/NNuyaUl.Q5eFTHSJ9TUafKK.4SRBesVOIAlBjaS6Ye', 'lafox77022@dwakm.com', '09949495656', 'verified', '2025-11-03 00:29:29'),
('U0005', 'admin', 'active', '2026-02-17 01:35:59', 'admin', 'Michelle Landero', 'Landero', '2018-11-12', 'Male', 'Kyoto Japan', '$2y$10$VkO.yPV1Xi/.7FQgWjgYHuI2Gckbjp/jTBdmmXJXafHpKrI6e7que', 'arisukazamoto@gmail.com', '0919299223', 'verified', '2025-11-03 00:48:04'),
('U0006', 'patient', 'active', '2026-01-21 04:08:16', 'kenneth', 'Kenneth', 'Jana', '2005-07-06', 'male', 'Anahaw St, Comembo. Taguig City', '$2y$10$Prd1QuepoUXja3./fNpPNu92.cwqynUThplFLOfNL83suy8C9tB6e', 'bodagi7557@limtu.com', '09988976545', 'verified', '2025-11-08 00:31:58'),
('U0007', 'patient', 'active', '2025-11-23 12:56:21', 'von', 'Von', 'Sabado', '2007-11-07', 'male', 'Lawin St Taguig City', '$2y$10$VZzSR9BkzQMglf0IZ1N/3OixRpwsBns2tk04GAC/PD4A3ctqAAKli', 'vonjeresespi1@gmail.com', '09287977979', 'verified', '2025-11-13 04:57:23'),
('U0008', 'patient', 'active', '2025-12-02 02:23:10', 'charles', 'Charles', 'Ramos', '2005-11-23', 'male', 'Amarillo St Taguig City', '$2y$10$xksl0yu97OmyBJHm.WjWFOxBTxgLB07fso.n62oVWeOsnu7axudSG', 'yeyof71832@gyknife.com', '92867657245', 'verified', '2025-11-16 06:53:58'),
('U0009', 'patient', 'active', '2025-12-02 02:23:57', 'cha', 'Charmmain', 'Rabano', '2007-07-02', 'male', 'Miyapis St', '$2y$10$.DT72DajqWL2e2Spzx8xXeqzoO8zL6xkQUJi1C0JKVxcDiv0oZlvy', 'winoc52801@fermiro.com', '09286765072', 'verified', '2025-11-16 13:41:02'),
('U0010', 'patient', 'active', '2025-12-02 02:35:21', 'charlesramos', 'Charles', 'Ramos', '2004-11-18', 'male', 'Anahaw St, Brgy Comembo, Taguig City, 1284', '$2y$10$e509QovcsisdG5VCdGf8Be5vA/5EypvE/ROI431QQ8ijffK1w553C', 'flowprince4@gmail.com', '02934023432', 'verified', '2025-11-20 08:26:14'),
('U0011', 'patient', 'active', '2026-01-21 04:09:49', 'juan', 'Juan', 'Dela Cruz', '2004-06-15', 'male', 'Sta Cruz, Taytay Rizal', '$2y$10$Kh8iodJoGZq6oKTxza0r7e.aO/7Uh5GPghTavRDg9pGo1hxx5cuKO', 'mlanderodentalclinic@gmail.com', '09286765204', 'verified', '2025-11-22 12:07:14'),
('U0012', 'patient', 'active', '2025-12-19 04:46:48', 'arzen', 'Arzen', 'Navor', '2007-12-12', 'male', 'Sta Cruz, Taytay Rizal', '$2y$10$ZGEE4wu90rNGVxahLR0OqedBvHyIjSHzDEMeSOFbuFUk9eUJUq1Bm', 'arzennavor@gmail.com', '09778776562', 'verified', '2025-12-19 04:46:36'),
('U0013', 'patient', 'active', '2026-01-03 06:20:58', 'mike', 'Mike', 'Wheeler', '1994-07-25', 'male', '112 Lincoln Ave Hawkings Sub', '$2y$10$.dnP97oxvUQiEpS9o5RVpuh6WFn7v0QJhYbnY.QNKjupKKBD8oYU.', 'yaweti1928@hudisk.com', '09528676520', 'verified', '2026-01-03 04:28:21'),
('U0014', 'patient', 'active', '2026-01-21 01:03:27', 'jane', 'Jane', 'Cruz', '2008-01-10', 'male', 'Bldg 6 Doctor Jose P. Rizal Extension', '$2y$10$raUshW7ZtJsXD0zn101BiOqq1T0kbxPaeQGbKZKqvY5mca/8FMsga', 'mikewheelerpogi@gmail.com', '09556765130', 'verified', '2026-01-21 01:03:14'),
('U0015', 'patient', 'active', '2026-02-17 01:16:12', 'marklaungayan', 'Mark', 'Laungayan', '2008-02-13', 'male', 'Lawin St Taguig City', '$2y$10$rY8u5WonX6lbWi9el/a.Ju8aSufEM5yslVjS2nOpIdc3ksYNOiRCe', 'uzumakinaruto6012@gmail.com', '09887979656', 'verified', '2026-02-17 00:31:18');

-- --------------------------------------------------------

--
-- Table structure for table `walkin_appointments`
--

CREATE TABLE `walkin_appointments` (
  `walkin_id` varchar(20) NOT NULL,
  `patient_id` varchar(50) NOT NULL,
  `service` varchar(100) NOT NULL,
  `sub_service` varchar(100) NOT NULL,
  `dentist_name` varchar(100) NOT NULL DEFAULT 'Dr. Michelle Landero',
  `branch` varchar(100) NOT NULL,
  `status` varchar(50) DEFAULT 'Walk-in',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `walkin_appointments`
--

INSERT INTO `walkin_appointments` (`walkin_id`, `patient_id`, `service`, `sub_service`, `dentist_name`, `branch`, `status`, `created_at`) VALUES
('WI002', 'P001', 'Orthodontics', 'Braces', 'Dr. Michelle Landero', 'Comembo Branch', 'Walk-in', '2026-02-11 06:08:08');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `appointments`
--
ALTER TABLE `appointments`
  ADD PRIMARY KEY (`appointment_id`),
  ADD KEY `fk_appointment_patient` (`patient_id`),
  ADD KEY `fk_appointment_team` (`team_id`),
  ADD KEY `fk_appointment_service` (`service_id`),
  ADD KEY `idx_appointments_ticket_code` (`ticket_code`);

--
-- Indexes for table `blocked_time_slots`
--
ALTER TABLE `blocked_time_slots`
  ADD PRIMARY KEY (`block_id`),
  ADD UNIQUE KEY `unique_blocked_slot` (`dentist_id`,`date`,`time_slot`),
  ADD KEY `created_by` (`created_by`);

--
-- Indexes for table `clinic_closures`
--
ALTER TABLE `clinic_closures`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_active_closure` (`closure_date`,`status`),
  ADD KEY `idx_closure_date` (`closure_date`),
  ADD KEY `idx_status` (`status`);

--
-- Indexes for table `dental_blogs`
--
ALTER TABLE `dental_blogs`
  ADD PRIMARY KEY (`blog_id`);

--
-- Indexes for table `dentist_schedule`
--
ALTER TABLE `dentist_schedule`
  ADD PRIMARY KEY (`schedule_id`),
  ADD UNIQUE KEY `unique_slot` (`dentist_id`,`date`,`time_slot`);

--
-- Indexes for table `feedback`
--
ALTER TABLE `feedback`
  ADD PRIMARY KEY (`feedback_id`),
  ADD UNIQUE KEY `unique_user_feedback` (`user_id`),
  ADD KEY `fk_feedback_appointment` (`appointment_id`);

--
-- Indexes for table `holidays`
--
ALTER TABLE `holidays`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_holiday_date` (`holiday_date`);

--
-- Indexes for table `multidisciplinary_dental_team`
--
ALTER TABLE `multidisciplinary_dental_team`
  ADD PRIMARY KEY (`team_id`),
  ADD KEY `fk_team_user` (`user_id`);

--
-- Indexes for table `patient_information`
--
ALTER TABLE `patient_information`
  ADD PRIMARY KEY (`patient_id`),
  ADD KEY `fk_patient_user` (`user_id`);

--
-- Indexes for table `payment`
--
ALTER TABLE `payment`
  ADD PRIMARY KEY (`payment_id`),
  ADD KEY `fk_payment_appointment` (`appointment_id`);

--
-- Indexes for table `promotional_emails`
--
ALTER TABLE `promotional_emails`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_user_id` (`user_id`),
  ADD KEY `idx_email` (`email`),
  ADD KEY `idx_sent_at` (`sent_at`);

--
-- Indexes for table `services`
--
ALTER TABLE `services`
  ADD PRIMARY KEY (`service_id`);

--
-- Indexes for table `system_alerts`
--
ALTER TABLE `system_alerts`
  ADD PRIMARY KEY (`alert_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `related_appointment_id` (`related_appointment_id`);

--
-- Indexes for table `treatment_history`
--
ALTER TABLE `treatment_history`
  ADD PRIMARY KEY (`treatment_id`),
  ADD KEY `patient_id` (`patient_id`);

--
-- Indexes for table `user_account`
--
ALTER TABLE `user_account`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `walkin_appointments`
--
ALTER TABLE `walkin_appointments`
  ADD PRIMARY KEY (`walkin_id`),
  ADD KEY `fk_walkin_patient` (`patient_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `clinic_closures`
--
ALTER TABLE `clinic_closures`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `feedback`
--
ALTER TABLE `feedback`
  MODIFY `feedback_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `holidays`
--
ALTER TABLE `holidays`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `promotional_emails`
--
ALTER TABLE `promotional_emails`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `appointments`
--
ALTER TABLE `appointments`
  ADD CONSTRAINT `fk_appointment_patient` FOREIGN KEY (`patient_id`) REFERENCES `patient_information` (`patient_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_appointment_service` FOREIGN KEY (`service_id`) REFERENCES `services` (`service_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_appointment_team` FOREIGN KEY (`team_id`) REFERENCES `multidisciplinary_dental_team` (`team_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `blocked_time_slots`
--
ALTER TABLE `blocked_time_slots`
  ADD CONSTRAINT `blocked_time_slots_ibfk_1` FOREIGN KEY (`dentist_id`) REFERENCES `multidisciplinary_dental_team` (`team_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `blocked_time_slots_ibfk_2` FOREIGN KEY (`created_by`) REFERENCES `user_account` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `dentist_schedule`
--
ALTER TABLE `dentist_schedule`
  ADD CONSTRAINT `dentist_schedule_ibfk_1` FOREIGN KEY (`dentist_id`) REFERENCES `multidisciplinary_dental_team` (`team_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `multidisciplinary_dental_team`
--
ALTER TABLE `multidisciplinary_dental_team`
  ADD CONSTRAINT `fk_team_user` FOREIGN KEY (`user_id`) REFERENCES `user_account` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `patient_information`
--
ALTER TABLE `patient_information`
  ADD CONSTRAINT `fk_patient_user` FOREIGN KEY (`user_id`) REFERENCES `user_account` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `payment`
--
ALTER TABLE `payment`
  ADD CONSTRAINT `fk_payment_appointment` FOREIGN KEY (`appointment_id`) REFERENCES `appointments` (`appointment_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `treatment_history`
--
ALTER TABLE `treatment_history`
  ADD CONSTRAINT `treatment_history_ibfk_1` FOREIGN KEY (`patient_id`) REFERENCES `patient_information` (`patient_id`);

--
-- Constraints for table `walkin_appointments`
--
ALTER TABLE `walkin_appointments`
  ADD CONSTRAINT `fk_walkin_patient` FOREIGN KEY (`patient_id`) REFERENCES `patient_information` (`patient_id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
