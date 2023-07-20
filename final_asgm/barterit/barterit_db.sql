-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jul 21, 2023 at 01:18 AM
-- Server version: 10.4.28-MariaDB
-- PHP Version: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `barterit_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `tbl_cards`
--

CREATE TABLE `tbl_cards` (
  `card_id` int(5) NOT NULL,
  `user_id` int(5) NOT NULL,
  `card_name` varchar(50) NOT NULL,
  `card_number` varchar(50) NOT NULL,
  `card_month` int(5) NOT NULL,
  `card_year` int(5) NOT NULL,
  `card_cvv` int(5) NOT NULL,
  `card_type` varchar(50) NOT NULL,
  `card_datereg` datetime(6) NOT NULL DEFAULT current_timestamp(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_cards`
--

INSERT INTO `tbl_cards` (`card_id`, `user_id`, `card_name`, `card_number`, `card_month`, `card_year`, `card_cvv`, `card_type`, `card_datereg`) VALUES
(1, 1, 'Apanineh', '4293  1212  1869  8514', 8, 20, 653, 'PayPal', '2023-07-21 04:06:43.653029'),
(2, 1, 'Tang Wei Chiang', '9999  8888  7777  6666', 5, 24, 321, 'Visa', '2023-07-21 04:07:23.292644'),
(3, 5, 'Apapa', '1111  1111  1111  1111', 1, 25, 678, 'MasterCard', '2023-07-21 04:44:28.201397');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_carts`
--

CREATE TABLE `tbl_carts` (
  `cart_id` int(5) NOT NULL,
  `item_id` varchar(5) NOT NULL,
  `item_title` varchar(5) NOT NULL,
  `cart_price` float NOT NULL,
  `user_id` varchar(5) NOT NULL,
  `seller_id` varchar(5) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_items`
--

CREATE TABLE `tbl_items` (
  `item_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `item_title` varchar(50) NOT NULL,
  `item_description` varchar(100) DEFAULT NULL,
  `item_type` varchar(50) NOT NULL,
  `item_price` decimal(10,2) NOT NULL,
  `item_state` varchar(50) NOT NULL,
  `item_latitude` double NOT NULL,
  `item_longitude` double NOT NULL,
  `item_locality` varchar(50) NOT NULL,
  `item_created_at` datetime DEFAULT current_timestamp(),
  `item_bartered` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_items`
--

INSERT INTO `tbl_items` (`item_id`, `user_id`, `item_title`, `item_description`, `item_type`, `item_price`, `item_state`, `item_latitude`, `item_longitude`, `item_locality`, `item_created_at`, `item_bartered`) VALUES
(1, 1, 'Pottery Set', 'Made from London.', 'Arts and Crafts', 250.00, 'Kedah', 6.4502267, 100.4958833, 'Changlun', '2023-07-05 01:21:43', 0),
(2, 1, 'Harry Potter ', '1st Edition remade', 'Books and Media', 300.00, 'Kedah', 6.4502267, 100.4958833, 'Changlun', '2023-07-05 01:23:32', 0),
(3, 1, 'Monogatari', '10 year anniversary edition', 'Books and Media', 250.00, 'Kedah', 6.4502267, 100.4958833, 'Changlun', '2023-07-05 01:24:37', 0),
(4, 1, 'Michael Jackson Album', 'Variety of album disc from Michael Jackson', 'Collectibles', 500.00, 'Kedah', 6.4502267, 100.4958833, 'Changlun', '2023-07-05 01:25:46', 0),
(5, 1, '18k Gold Pocket Watch', 'Antique pocket watch from England royalists', 'Collectibles', 26000.00, 'Kedah', 6.4502267, 100.4958833, 'Changlun', '2023-07-05 01:26:48', 0),
(6, 1, 'Acer Aspire 5', 'Condition still new, bought it on 2022', 'Electronics', 2000.00, 'Kedah', 6.4502267, 100.4958833, 'Changlun', '2023-07-05 01:27:44', 0),
(7, 1, 'Garmin Smartwatch', 'The package is still unbox state', 'Electronics', 400.00, 'Kedah', 6.4502267, 100.4958833, 'Changlun', '2023-07-06 15:42:08', 0),
(10, 1, 'Gucci handbag', 'Authentic product bought fom korea.', 'Fashion and clothing', 11000.00, 'Kedah', 6.4502267, 100.4958833, 'Changlun', '2023-07-06 15:48:36', 0),
(11, 1, 'Balenciaga jacket ', 'Got it from Balenciaga showcase day', 'Fashion and clothing', 20000.00, 'Kedah', 6.4502267, 100.4958833, 'Changlun', '2023-07-06 15:50:11', 0),
(12, 1, 'Outdoor garden teak set', 'Used once or twice. As good as new.', 'Garden and Outdoor', 1400.00, 'Kedah', 6.4502267, 100.4958833, 'Changlun', '2023-07-06 15:53:41', 0),
(13, 2, 'Kiehl gift set', 'Expired in 2025', 'Health and Beauty', 250.00, 'Kedah', 6.4502267, 100.4958833, 'Changlun', '2023-07-06 15:55:46', 0),
(14, 2, 'Antique wooden chair', 'Red ooden chair. Condition 8/10. Self collect a tmn melawati area.', 'Home and Furniture', 400.00, 'Kedah', 6.4502267, 100.4958833, 'Changlun', '2023-07-06 15:57:53', 0),
(15, 2, 'Antique wooden dresser', 'Has minor flaws or defects', 'Home and Furniture', 180.00, 'Kedah', 6.4502267, 100.4958833, 'Changlun', '2023-07-06 15:58:46', 0),
(16, 2, 'Electronic guitar', 'Tiger George Lynch Signature 1986 - First Edition OG Wrap. Made in Japan', 'Music and Instruments', 36999.00, 'Kedah', 6.4502267, 100.4958833, 'Changlun', '2023-07-06 16:04:21', 0),
(17, 2, 'Mountain bike', 'Nosh Grizzly S MTB 293x8s 16\"', 'Sports and Fitness', 1350.00, 'Kedah', 6.4502267, 100.4958833, 'Changlun', '2023-07-06 16:07:06', 0),
(18, 2, 'Treadmill ', 'Horizon T202. Used with care. Flaws, if any, are barely noticeable', 'Sports and Fitness', 1800.00, 'Kedah', 6.4502267, 100.4958833, 'Changlun', '2023-07-06 16:10:38', 0),
(19, 2, 'Board Game', 'The City of Kings KS Premium Edition Board Game', 'Toys and Games', 550.00, 'Kedah', 6.4502267, 100.4958833, 'Changlun', '2023-07-06 16:13:44', 0),
(20, 2, 'Drone', 'DJI Mini 3 (DJI RC)', 'Toys and Games', 3099.00, 'Kedah', 6.4502267, 100.4958833, 'Changlun', '2023-07-06 16:14:55', 0),
(21, 2, 'Proton Saga 1985', 'Proton Saga Manufactured in the year of 1985.', 'Vehicles and Automotive', 2300.00, 'Kedah', 6.4502267, 100.4958833, 'Changlun', '2023-07-06 16:16:31', 0),
(22, 2, 'Yamaha Bike', '2019 Yamaa Tracer 900 GT', 'Vehicles and Automotive', 554900.00, 'Kedah', 6.4502267, 100.4958833, 'Changlun', '2023-07-06 16:17:34', 0);

-- --------------------------------------------------------

--
-- Table structure for table `tbl_orders`
--

CREATE TABLE `tbl_orders` (
  `order_id` int(5) NOT NULL,
  `order_bill` int(6) NOT NULL,
  `order_paid` float NOT NULL,
  `user_id` int(5) NOT NULL,
  `seller_id` int(5) NOT NULL,
  `order_date` datetime(6) NOT NULL DEFAULT current_timestamp(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_orders`
--

INSERT INTO `tbl_orders` (`order_id`, `order_bill`, `order_paid`, `user_id`, `seller_id`, `order_date`) VALUES
(1, 231791, 250, 1, 0, '2023-07-21 06:04:01.168962'),
(2, 261164, 250, 1, 0, '2023-07-21 06:20:48.730213'),
(3, 511092, 550, 1, 0, '2023-07-21 06:27:17.814389'),
(4, 753125, 2300, 1, 0, '2023-07-21 07:08:59.367960'),
(5, 277652, 554900, 1, 0, '2023-07-21 07:10:47.010897'),
(6, 930135, 1800, 1, 0, '2023-07-21 07:17:42.006719');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_users`
--

CREATE TABLE `tbl_users` (
  `user_id` int(11) NOT NULL,
  `user_name` varchar(30) NOT NULL,
  `user_email` varchar(50) NOT NULL,
  `user_pass` varchar(40) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_users`
--

INSERT INTO `tbl_users` (`user_id`, `user_name`, `user_email`, `user_pass`) VALUES
(1, 'Apanineh', 'apanineh123@gmail.com', '63bf0cc1889fcc984571e6ef1e57860dc083eca8'),
(2, 'Tang Wei Chiang', 'tangweichiang0109@gmail.com', '1ad5d160b508512daf5b094e40315523ddb92b52'),
(4, 'Johnny', 'Johnny123@gmail.com', '766d10deedbf1adc15e0036094048c2f1ef64406'),
(5, 'apapa', 'apapa123@gmail.com', '20eabe5d64b0e216796e834f52d61fd0b70332fc');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `tbl_cards`
--
ALTER TABLE `tbl_cards`
  ADD PRIMARY KEY (`card_id`);

--
-- Indexes for table `tbl_carts`
--
ALTER TABLE `tbl_carts`
  ADD PRIMARY KEY (`cart_id`);

--
-- Indexes for table `tbl_items`
--
ALTER TABLE `tbl_items`
  ADD PRIMARY KEY (`item_id`);

--
-- Indexes for table `tbl_orders`
--
ALTER TABLE `tbl_orders`
  ADD PRIMARY KEY (`order_id`);

--
-- Indexes for table `tbl_users`
--
ALTER TABLE `tbl_users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `user_email` (`user_email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `tbl_cards`
--
ALTER TABLE `tbl_cards`
  MODIFY `card_id` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `tbl_carts`
--
ALTER TABLE `tbl_carts`
  MODIFY `cart_id` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `tbl_items`
--
ALTER TABLE `tbl_items`
  MODIFY `item_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT for table `tbl_orders`
--
ALTER TABLE `tbl_orders`
  MODIFY `order_id` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `tbl_users`
--
ALTER TABLE `tbl_users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
