-- phpMyAdmin SQL Dump
-- version 4.9.0.1
-- https://www.phpmyadmin.net/
--
-- Host: sql105.infinityfree.com
-- Generation Time: Nov 07, 2026 at 03:41 PM
-- Server version: 11.4.13-MariaDB
-- PHP Version: 7.2.22

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `if0_42292902_battleground_calc`
--

-- --------------------------------------------------------

--
-- Table structure for table `audit_logs`
--

CREATE TABLE `audit_logs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED DEFAULT NULL,
  `table_name` varchar(50) NOT NULL,
  `record_id` char(36) NOT NULL,
  `action` varchar(20) NOT NULL,
  `old_data` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL
) ;

-- --------------------------------------------------------

--
-- Table structure for table `auth_groups_users`
--

CREATE TABLE `auth_groups_users` (
  `id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `group` varchar(255) NOT NULL,
  `created_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `auth_groups_users`
--

INSERT INTO `auth_groups_users` (`id`, `user_id`, `group`, `created_at`) VALUES
(1, 1, 'user', '2026-04-19 09:41:34'),
(2, 2, 'user', '2026-04-19 09:45:41'),
(3, 1, 'admin', '2026-04-19 17:11:16'),
(4, 2, 'admin', '2026-04-19 17:11:16'),
(5, 3, 'user', '2026-04-19 17:11:16'),
(6, 3, 'admin', '2026-04-20 11:37:54');

-- --------------------------------------------------------

--
-- Table structure for table `auth_identities`
--

CREATE TABLE `auth_identities` (
  `id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `type` varchar(255) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `secret` varchar(255) NOT NULL,
  `secret2` varchar(255) DEFAULT NULL,
  `expires` datetime DEFAULT NULL,
  `extra` text DEFAULT NULL,
  `force_reset` tinyint(1) NOT NULL DEFAULT 0,
  `last_used_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `auth_identities`
--

INSERT INTO `auth_identities` (`id`, `user_id`, `type`, `name`, `secret`, `secret2`, `expires`, `extra`, `force_reset`, `last_used_at`, `created_at`, `updated_at`) VALUES
(1, 1, 'email_password', NULL, 'feyfeypor02@gmail.com', '$2y$12$dy8AkAC0MsTOqN4/tqisN.sJ8vsbqgZhG8ekmIL114diA0a5YRJxC', NULL, NULL, 0, '2026-11-07 11:57:11', '2026-04-19 09:41:34', '2026-11-07 11:57:11'),
(2, 2, 'email_password', NULL, 'feyfeypor03@gmail.com', '$2y$12$tKbEYlxtVGqsyFv2Zst/LuvSYYaLdpbTOmNyHve1D14LtqjVvNKJe', NULL, NULL, 0, '2026-08-26 05:44:26', '2026-04-19 09:45:41', '2026-08-26 05:44:26'),
(3, 3, 'email_password', NULL, 'public.dummy@local.test', '$2y$12$LFi/57WFXOQdho2K6f795eRKpLhGnyNdVpGdmQPKgSi5L1hXwVEl2', NULL, NULL, 0, '2026-04-20 06:52:15', '2026-04-19 17:11:16', '2026-04-20 06:52:15');

-- --------------------------------------------------------

--
-- Table structure for table `auth_logins`
--

CREATE TABLE `auth_logins` (
  `id` int(10) UNSIGNED NOT NULL,
  `ip_address` varchar(255) NOT NULL,
  `user_agent` varchar(255) DEFAULT NULL,
  `id_type` varchar(255) NOT NULL,
  `identifier` varchar(255) NOT NULL,
  `user_id` int(10) UNSIGNED DEFAULT NULL,
  `date` datetime NOT NULL,
  `success` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `auth_logins`
--

INSERT INTO `auth_logins` (`id`, `ip_address`, `user_agent`, `id_type`, `identifier`, `user_id`, `date`, `success`) VALUES
(1, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-04-19 09:42:41', 1),
(2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', 'email_password', 'feyfeypor03@gmail.com', 2, '2026-04-19 10:01:13', 1),
(3, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', 'email_password', 'feyfeypor03@gmail.com', 2, '2026-04-19 10:11:59', 1),
(4, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', 'email_password', 'feyfeypor03@gmail.com', 2, '2026-04-19 11:14:13', 1),
(5, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', 'email_password', 'feyfeypor03@gmail.com', 2, '2026-04-19 13:52:47', 1),
(6, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', 'email_password', 'feyfeypor03@gmail.com', 2, '2026-04-19 16:23:17', 1),
(7, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', 'email_password', 'feyfeypor03@gmail.com', 2, '2026-04-20 03:32:20', 1),
(8, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', 'email_password', 'feyfeypor01@gmail.com', NULL, '2026-04-20 04:30:15', 0),
(9, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', 'email_password', 'feyfeypor01@gmail.com', NULL, '2026-04-20 04:30:24', 0),
(10, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-04-20 04:30:32', 1),
(11, '::1', 'Mozilla/5.0 (Windows NT; Windows NT 10.0; en-US) WindowsPowerShell/5.1.19041.2673', 'email_password', 'public.dummy@local.test', 3, '2026-04-20 04:38:46', 1),
(12, '::1', 'Mozilla/5.0 (Windows NT; Windows NT 10.0; en-US) WindowsPowerShell/5.1.19041.2673', 'email_password', 'public.dummy@local.test', 3, '2026-04-20 04:39:13', 1),
(13, '::1', 'Mozilla/5.0 (Windows NT; Windows NT 10.0; en-US) WindowsPowerShell/5.1.19041.2673', 'email_password', 'public.dummy@local.test', 3, '2026-04-20 05:32:16', 1),
(14, '::1', 'Mozilla/5.0 (Windows NT; Windows NT 10.0; en-US) WindowsPowerShell/5.1.19041.2673', 'email_password', 'public.dummy@local.test', 3, '2026-04-20 05:32:58', 1),
(15, '::1', 'Mozilla/5.0 (Windows NT; Windows NT 10.0; en-US) WindowsPowerShell/5.1.19041.2673', 'email_password', 'public.dummy@local.test', 3, '2026-04-20 05:33:27', 1),
(16, '::1', 'Mozilla/5.0 (Windows NT; Windows NT 10.0; en-US) WindowsPowerShell/5.1.19041.2673', 'email_password', 'public.dummy@local.test', 3, '2026-04-20 06:02:47', 1),
(17, '::1', 'Mozilla/5.0 (Windows NT; Windows NT 10.0; en-US) WindowsPowerShell/5.1.19041.2673', 'email_password', 'public.dummy@local.test', 3, '2026-04-20 06:03:08', 1),
(18, '::1', 'Mozilla/5.0 (Windows NT; Windows NT 10.0; en-US) WindowsPowerShell/5.1.19041.2673', 'email_password', 'public.dummy@local.test', 3, '2026-04-20 06:50:50', 1),
(19, '::1', 'Mozilla/5.0 (Windows NT; Windows NT 10.0; en-US) WindowsPowerShell/5.1.19041.2673', 'email_password', 'public.dummy@local.test', 3, '2026-04-20 06:51:12', 1),
(20, '::1', 'Mozilla/5.0 (Windows NT; Windows NT 10.0; en-US) WindowsPowerShell/5.1.19041.2673', 'email_password', 'public.dummy@local.test', 3, '2026-04-20 06:51:40', 1),
(21, '::1', 'Mozilla/5.0 (Windows NT; Windows NT 10.0; en-US) WindowsPowerShell/5.1.19041.2673', 'email_password', 'public.dummy@local.test', 3, '2026-04-20 06:52:15', 1),
(22, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-04-20 07:23:11', 1),
(23, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-04-20 13:11:52', 1),
(24, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-04-20 17:19:49', 1),
(25, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-04-21 00:04:37', 1),
(26, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-04-21 00:38:13', 1),
(27, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-04-21 03:26:05', 1),
(28, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-04-21 03:34:46', 1),
(29, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', 'email_password', 'feyfeypor03@gmail.com', 2, '2026-04-21 08:08:30', 1),
(30, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', 'email_password', 'feyfeypor03@gmail.com', 2, '2026-04-21 09:18:37', 1),
(31, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', 'email_password', 'feyfeypor03@gmail.com', 2, '2026-04-21 09:47:17', 1),
(32, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', 'email_password', 'feyfeypor01@gmail.com', NULL, '2026-04-21 10:25:23', 0),
(33, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-04-21 10:25:29', 1),
(34, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', 'email_password', 'feyfeypor01@gmail.com', NULL, '2026-04-21 10:37:15', 0),
(35, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-04-21 10:37:20', 1),
(36, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-04-21 10:48:12', 1),
(37, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-04-21 10:58:27', 1),
(38, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-04-21 11:15:50', 1),
(39, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', 'email_password', 'feyfeypor01@gmail.com', NULL, '2026-04-21 11:59:06', 0),
(40, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-04-21 11:59:16', 1),
(41, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-04-21 12:22:42', 1),
(42, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-04-21 12:38:23', 1),
(43, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-04-21 13:17:56', 1),
(44, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-04-21 17:06:14', 1),
(45, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-04-21 17:17:19', 1),
(46, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-04-21 17:23:22', 1),
(47, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-04-21 17:35:24', 1),
(48, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-04-21 17:35:59', 1),
(49, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-04-22 00:09:11', 1),
(50, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-04-22 00:23:25', 1),
(51, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-04-22 00:45:21', 1),
(52, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-04-22 01:06:58', 1),
(53, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-04-22 01:15:16', 1),
(54, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-04-22 01:24:10', 1),
(55, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-04-22 02:14:16', 1),
(56, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-04-22 07:02:18', 1),
(57, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-04-22 07:51:01', 1),
(58, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-04-22 07:53:21', 1),
(59, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-04-22 08:20:08', 1),
(60, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-04-22 08:34:30', 1),
(61, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-04-22 08:42:21', 1),
(62, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-04-22 08:57:16', 1),
(63, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-04-22 09:20:54', 1),
(64, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-04-22 09:42:05', 1),
(65, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-04-22 10:50:48', 1),
(66, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-04-22 11:00:56', 1),
(67, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-04-22 11:08:47', 1),
(68, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-04-22 11:15:03', 1),
(69, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-04-22 11:21:15', 1),
(70, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-04-22 11:26:24', 1),
(71, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-04-22 11:38:44', 1),
(72, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-04-22 11:51:23', 1),
(73, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-04-22 11:58:39', 1),
(74, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-04-22 12:44:45', 1),
(75, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-04-22 13:07:55', 1),
(76, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-04-23 06:08:00', 1),
(77, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-04-23 06:15:52', 1),
(78, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-04-23 08:05:12', 1),
(79, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-04-23 08:08:07', 1),
(80, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-04-23 08:21:25', 1),
(81, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-04-23 09:06:39', 1),
(82, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-04-23 09:13:44', 1),
(83, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-04-23 09:27:19', 1),
(84, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-04-23 09:41:05', 1),
(85, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-04-23 09:58:56', 1),
(86, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-04-23 10:14:24', 1),
(87, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-04-23 10:31:30', 1),
(88, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-04-23 10:37:16', 1),
(89, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-04-23 10:42:33', 1),
(90, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-04-23 11:09:41', 1),
(91, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-04-23 11:24:30', 1),
(92, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-04-23 12:12:39', 1),
(93, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-04-23 13:50:52', 1),
(94, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-04-23 14:01:01', 1),
(95, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-04-23 14:13:08', 1),
(96, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-04-23 14:18:43', 1),
(97, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-04-24 02:36:53', 1),
(98, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-04-24 02:45:31', 1),
(99, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-04-24 02:54:42', 1),
(100, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-04-24 05:27:53', 1),
(101, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-04-24 05:40:30', 1),
(102, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-04-24 12:31:27', 1),
(103, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-04-25 08:51:48', 1),
(104, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-04-25 09:03:05', 1),
(105, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-04-25 09:23:16', 1),
(106, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-04-25 09:57:34', 1),
(107, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-04-26 01:52:54', 1),
(108, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-04-26 02:01:08', 1),
(109, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-04-26 02:12:00', 1),
(110, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-04-26 02:12:54', 1);
INSERT INTO `auth_logins` (`id`, `ip_address`, `user_agent`, `id_type`, `identifier`, `user_id`, `date`, `success`) VALUES
(111, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-04-26 02:32:23', 1),
(112, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-04-26 02:41:28', 1),
(113, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-04-26 03:18:10', 1),
(114, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-04-26 03:33:37', 1),
(115, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-04-26 03:49:05', 1),
(116, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-04-26 04:14:46', 1),
(117, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-04-26 05:11:03', 1),
(118, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-04-26 05:16:38', 1),
(119, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-04-26 05:39:22', 1),
(120, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-04-26 06:18:03', 1),
(121, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-04-26 06:28:58', 1),
(122, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-04-26 07:35:23', 1),
(123, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-04-26 08:36:56', 1),
(124, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-05-24 02:25:23', 1),
(125, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-05-24 09:45:47', 1),
(126, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-05-24 10:13:16', 1),
(127, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-05-24 10:30:32', 1),
(128, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-05-24 10:44:44', 1),
(129, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-05-24 10:58:17', 1),
(130, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-05-24 11:10:54', 1),
(131, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-05-24 11:34:59', 1),
(132, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-05-24 11:54:42', 1),
(133, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-05-24 12:11:11', 1),
(134, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-05-24 12:16:21', 1),
(135, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-05-24 12:18:28', 1),
(136, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-05-24 12:34:36', 1),
(137, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-05-24 12:52:05', 1),
(138, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-05-24 13:08:15', 1),
(139, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-05-24 13:22:58', 1),
(140, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-05-24 13:53:03', 1),
(141, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-05-24 14:45:22', 1),
(142, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-05-24 14:51:59', 1),
(143, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-05-24 15:31:43', 1),
(144, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-05-24 15:39:55', 1),
(145, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-05-24 15:48:30', 1),
(146, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-05-24 16:19:26', 1),
(147, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-05-24 16:39:58', 1),
(148, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-05-24 17:39:21', 1),
(149, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-05-24 17:45:51', 1),
(150, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-05-24 18:12:34', 1),
(151, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-05-24 18:18:55', 1),
(152, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-05-24 19:04:58', 1),
(153, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-05-24 19:29:39', 1),
(154, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-05-24 19:52:19', 1),
(155, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-05-24 20:11:58', 1),
(156, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-05-24 20:34:12', 1),
(157, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-05-26 19:31:27', 1),
(158, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-05-26 19:51:21', 1),
(159, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-06-09 18:03:18', 1),
(160, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-06-10 18:28:11', 1),
(161, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-06-16 22:59:05', 1),
(162, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-06-16 23:08:04', 1),
(163, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-06-19 19:37:13', 1),
(164, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmai.com', NULL, '2026-07-04 13:48:22', 0),
(165, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmai.com', NULL, '2026-07-04 13:48:32', 0),
(166, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-07-04 13:48:41', 1),
(167, '114.10.151.70', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-07-04 14:25:35', 1),
(168, '182.2.72.73', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-07-04 16:51:31', 1),
(169, '182.2.72.73', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-07-04 17:02:58', 1),
(170, '182.2.72.73', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-07-04 17:14:16', 1),
(171, '182.2.72.73', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-07-04 17:15:22', 1),
(172, '182.2.72.73', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-07-04 17:30:37', 1),
(173, '182.8.225.235', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-07-04 20:06:50', 1),
(174, '157.20.244.47', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-07-05 18:43:05', 1),
(175, '157.20.244.47', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-07-06 10:18:52', 1),
(176, '157.20.244.47', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-07-07 20:00:12', 1),
(177, '157.20.244.47', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-07-07 20:25:13', 1),
(178, '157.20.244.47', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-07-14 18:41:09', 1),
(179, '182.2.79.68', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-07-22 08:20:12', 1),
(180, '157.20.244.47', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-08-20 09:00:24', 1),
(181, '157.20.244.47', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-08-20 09:02:33', 1),
(182, '157.20.244.47', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-08-21 09:29:59', 1),
(183, '182.4.103.111', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-08-22 14:08:22', 1),
(184, '103.46.186.192', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-08-22 18:25:20', 1),
(185, '103.46.186.192', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-08-22 18:47:53', 1),
(186, '103.46.186.192', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-08-22 18:54:39', 1),
(187, '103.46.186.192', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-08-22 19:01:16', 1),
(188, '103.46.186.192', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-08-22 19:17:12', 1),
(189, '103.46.186.192', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-08-22 19:23:58', 1),
(190, '182.4.100.211', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-08-25 22:50:35', 1),
(191, '182.5.200.23', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-08-25 22:52:42', 1),
(192, '140.213.1.150', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-08-25 22:55:04', 1),
(193, '157.20.244.47', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-08-25 22:56:54', 1),
(194, '157.20.244.47', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'email_password', 'feyfeypor03@gmail.com', 2, '2026-08-26 05:44:26', 1),
(195, '182.8.249.150', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-08-26 14:22:24', 1),
(196, '182.8.249.150', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-08-26 14:37:38', 1),
(197, '182.8.249.150', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-08-26 16:53:31', 1),
(198, '157.20.244.47', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-08-27 05:47:07', 1),
(199, '182.4.102.57', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-08-27 07:11:13', 1),
(200, '157.20.244.47', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-08-28 07:51:01', 1),
(201, '157.20.244.47', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-08-28 08:19:17', 1),
(202, '157.20.244.47', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-08-28 09:06:50', 1),
(203, '182.8.226.254', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-08-28 14:08:30', 1),
(204, '182.8.226.254', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-08-28 14:23:16', 1),
(205, '182.8.226.254', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-08-28 14:31:45', 1),
(206, '182.8.226.254', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-08-28 14:55:12', 1),
(207, '182.8.226.254', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-08-28 14:57:36', 1);
INSERT INTO `auth_logins` (`id`, `ip_address`, `user_agent`, `id_type`, `identifier`, `user_id`, `date`, `success`) VALUES
(208, '182.8.226.254', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-08-28 15:21:33', 1),
(209, '182.8.226.254', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-08-28 15:36:39', 1),
(210, '182.8.226.254', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-08-28 15:39:57', 1),
(211, '182.8.226.254', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-08-28 15:45:22', 1),
(212, '182.8.226.254', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-08-28 15:46:54', 1),
(213, '182.8.226.254', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-08-28 17:05:00', 1),
(214, '182.8.226.254', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-08-28 17:10:52', 1),
(215, '182.8.226.254', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-08-28 17:12:51', 1),
(216, '182.8.226.254', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-08-28 17:19:38', 1),
(217, '182.8.226.254', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-08-28 17:24:02', 1),
(218, '182.8.226.254', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-08-28 17:24:24', 1),
(219, '182.8.226.254', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-08-28 17:24:52', 1),
(220, '182.8.226.254', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-08-28 17:25:19', 1),
(221, '182.8.226.254', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-08-28 17:32:25', 1),
(222, '182.8.226.254', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-08-28 17:34:25', 1),
(223, '182.8.226.254', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-08-28 17:37:11', 1),
(224, '182.8.226.254', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-08-28 17:42:40', 1),
(225, '182.8.226.254', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-08-28 17:46:56', 1),
(226, '182.8.226.254', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-08-28 17:49:38', 1),
(227, '182.8.226.254', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-08-28 17:52:30', 1),
(228, '182.8.226.254', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-08-28 17:55:21', 1),
(229, '182.8.226.254', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-08-28 17:55:28', 1),
(230, '182.8.226.254', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-08-28 17:55:33', 1),
(231, '182.8.226.254', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-08-28 17:55:39', 1),
(232, '182.8.226.254', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-08-28 17:59:44', 1),
(233, '182.8.226.254', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-08-28 17:59:52', 1),
(234, '182.8.226.254', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-08-28 18:07:00', 1),
(235, '182.8.226.254', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-08-28 18:20:30', 1),
(236, '182.8.226.200', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-08-28 19:43:37', 1),
(237, '157.20.244.47', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-08-29 08:12:14', 1),
(238, '157.20.244.47', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-08-29 08:22:00', 1),
(239, '157.20.244.47', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-08-29 08:33:02', 1),
(240, '157.20.244.47', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-08-29 08:35:17', 1),
(241, '157.20.244.47', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-08-29 08:46:33', 1),
(242, '140.213.139.187', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) SamsungBrowser/30.0 Chrome/143.0.0.0 Mobile Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-08-29 08:51:47', 1),
(243, '140.213.141.148', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) SamsungBrowser/30.0 Chrome/143.0.0.0 Mobile Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-08-29 08:52:24', 1),
(244, '182.4.102.125', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-08-29 08:52:56', 1),
(245, '157.20.244.47', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-08-29 10:21:43', 1),
(246, '157.20.244.47', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-08-29 11:32:19', 1),
(247, '157.20.244.47', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-08-29 11:36:36', 1),
(248, '157.20.244.47', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-08-29 11:46:51', 1),
(249, '157.20.244.47', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-08-29 11:58:52', 1),
(250, '157.20.244.47', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-08-29 12:04:16', 1),
(251, '157.20.244.47', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-08-29 12:38:49', 1),
(252, '157.20.244.47', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-08-29 13:31:09', 1),
(253, '157.20.244.47', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-08-29 13:41:05', 1),
(254, '157.20.244.47', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-08-29 14:25:00', 1),
(255, '157.20.244.47', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-08-29 15:56:08', 1),
(256, '157.20.244.47', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-08-29 17:28:47', 1),
(257, '157.20.244.47', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-08-29 18:12:58', 1),
(258, '157.20.244.47', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-08-29 18:14:28', 1),
(259, '157.20.244.47', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-08-29 21:12:17', 1),
(260, '182.4.100.4', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-08-30 02:18:09', 1),
(261, '182.8.227.127', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-08-30 02:20:25', 1),
(262, '182.8.227.127', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36 Edg/152.0.0.0', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-08-30 02:31:16', 1),
(263, '182.8.227.127', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-08-30 02:32:31', 1),
(264, '182.8.227.127', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36 Edg/152.0.0.0', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-08-30 02:38:33', 1),
(265, '182.4.100.4', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-08-30 02:57:56', 1),
(266, '182.4.100.4', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-08-30 03:10:44', 1),
(267, '182.4.100.4', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-08-30 03:22:29', 1),
(268, '182.8.250.28', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-08-30 10:06:41', 1),
(269, '182.8.250.28', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-08-30 10:51:29', 1),
(270, '182.8.250.28', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-08-30 11:13:48', 1),
(271, '182.8.250.28', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-08-30 11:30:52', 1),
(272, '182.8.250.28', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-08-30 12:04:35', 1),
(273, '182.8.250.28', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-08-30 12:17:54', 1),
(274, '182.8.250.28', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-08-30 13:27:31', 1),
(275, '114.10.150.78', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-08-30 15:07:05', 1),
(276, '114.10.150.78', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-08-30 15:26:01', 1),
(277, '182.8.250.28', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-08-30 15:33:38', 1),
(278, '182.8.250.28', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-08-30 15:43:57', 1),
(279, '182.8.250.28', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-08-30 15:55:24', 1),
(280, '114.10.150.78', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-08-30 15:55:52', 1),
(281, '114.10.150.78', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-08-30 16:41:44', 1),
(282, '114.10.150.78', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-08-30 17:02:27', 1),
(283, '182.8.250.28', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-08-30 17:24:53', 1),
(284, '182.8.250.28', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-08-30 17:39:33', 1),
(285, '182.8.250.28', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-08-30 17:45:08', 1),
(286, '182.8.250.28', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-08-30 18:15:03', 1),
(287, '157.20.244.47', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-09-01 07:33:58', 1),
(288, '157.20.244.47', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-09-01 08:11:27', 1),
(289, '157.20.244.47', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-09-01 16:39:56', 1),
(290, '182.8.227.243', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-09-01 18:28:55', 1),
(291, '182.8.227.243', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-09-01 18:34:42', 1),
(292, '157.20.244.47', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-09-01 23:15:18', 1),
(293, '157.20.244.47', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-09-02 08:53:45', 1),
(294, '157.20.244.47', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-09-02 09:11:42', 1),
(295, '157.20.244.47', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-09-02 09:18:05', 1),
(296, '157.20.244.47', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-09-02 09:27:22', 1),
(297, '157.20.244.47', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-09-02 09:29:11', 1),
(298, '157.20.100.53', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) SamsungBrowser/30.0 Chrome/143.0.0.0 Mobile Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-09-02 09:30:00', 1),
(299, '157.20.244.47', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-09-02 09:35:31', 1),
(300, '157.20.244.47', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-09-02 09:48:21', 1),
(301, '157.20.244.47', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-09-02 09:57:29', 1),
(302, '157.20.244.47', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-09-02 10:06:27', 1);
INSERT INTO `auth_logins` (`id`, `ip_address`, `user_agent`, `id_type`, `identifier`, `user_id`, `date`, `success`) VALUES
(303, '157.20.244.47', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-09-02 10:52:22', 1),
(304, '157.20.244.47', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-09-02 10:57:10', 1),
(305, '157.20.244.47', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-09-02 12:52:03', 1),
(306, '157.20.244.47', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-09-02 13:03:40', 1),
(307, '157.20.244.47', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-09-02 13:12:34', 1),
(308, '157.20.244.47', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-09-02 13:19:08', 1),
(309, '157.20.244.47', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-09-02 23:32:51', 1),
(310, '157.20.244.47', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-09-03 08:23:46', 1),
(311, '157.20.244.47', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-09-03 08:34:37', 1),
(312, '157.20.244.47', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-09-03 09:09:20', 1),
(313, '157.20.244.47', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-09-03 09:38:49', 1),
(314, '157.20.244.47', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-09-03 09:46:01', 1),
(315, '157.20.244.47', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-09-03 11:28:25', 1),
(316, '114.10.153.100', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-09-03 18:39:34', 1),
(317, '182.8.249.156', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-09-03 18:58:11', 1),
(318, '182.8.249.156', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-09-03 19:40:07', 1),
(319, '182.8.249.156', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-09-03 21:20:17', 1),
(320, '182.8.249.156', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-09-03 21:24:38', 1),
(321, '157.20.244.47', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-09-04 05:24:53', 1),
(322, '157.20.244.47', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-09-04 05:34:44', 1),
(323, '157.20.244.47', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-09-04 05:44:49', 1),
(324, '157.20.244.47', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-09-04 06:33:48', 1),
(325, '157.20.244.47', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-09-04 06:55:28', 1),
(326, '157.20.244.47', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-09-04 07:07:22', 1),
(327, '157.20.244.47', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-09-04 07:50:50', 1),
(328, '157.20.244.47', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-09-04 08:22:39', 1),
(329, '157.20.244.47', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-09-04 08:38:11', 1),
(330, '157.20.244.47', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-09-04 08:51:45', 1),
(331, '157.20.244.47', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-09-04 09:19:40', 1),
(332, '157.20.244.47', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-09-04 09:28:58', 1),
(333, '157.20.244.47', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-09-04 09:45:45', 1),
(334, '157.20.244.47', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-09-04 10:23:08', 1),
(335, '157.20.244.47', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-09-04 12:34:56', 1),
(336, '157.20.244.47', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-09-04 12:56:02', 1),
(337, '157.20.244.47', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-09-04 13:04:50', 1),
(338, '125.163.154.127', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-09-04 13:07:57', 1),
(339, '157.20.244.47', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-09-04 13:10:26', 1),
(340, '157.20.100.53', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) SamsungBrowser/30.0 Chrome/143.0.0.0 Mobile Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-09-04 13:18:52', 1),
(341, '157.20.244.47', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-09-04 13:19:12', 1),
(342, '125.163.154.127', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-09-04 13:20:29', 1),
(343, '157.20.100.53', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) SamsungBrowser/30.0 Chrome/143.0.0.0 Mobile Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-09-04 13:37:12', 1),
(344, '157.20.244.47', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-09-04 13:38:02', 1),
(345, '157.20.244.47', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-09-04 13:38:09', 1),
(346, '157.20.244.47', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-09-04 13:42:29', 1),
(347, '157.20.244.47', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-09-04 13:49:23', 1),
(348, '125.163.154.127', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-09-04 13:57:28', 1),
(349, '157.20.244.47', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-09-04 14:12:35', 1),
(350, '125.163.154.127', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-09-04 14:15:13', 1),
(351, '157.20.244.47', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-09-04 14:32:22', 1),
(352, '157.20.244.47', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-09-04 14:48:26', 1),
(353, '157.20.244.47', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-09-04 17:31:22', 1),
(354, '157.20.244.47', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-09-04 17:58:56', 1),
(355, '157.20.244.47', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-09-04 18:11:34', 1),
(356, '157.20.244.47', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-09-04 20:59:02', 1),
(357, '114.10.152.168', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-09-04 22:53:26', 1),
(358, '118.99.91.161', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-09-05 09:48:25', 1),
(359, '118.99.91.161', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-09-05 12:34:32', 1),
(360, '118.99.91.161', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-09-05 12:40:26', 1),
(361, '118.99.91.161', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-09-05 12:48:24', 1),
(362, '118.99.91.161', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-09-05 12:54:57', 1),
(363, '118.99.91.161', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-09-05 13:18:49', 1),
(364, '118.99.91.161', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-09-05 13:32:50', 1),
(365, '118.99.91.161', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-09-05 14:37:37', 1),
(366, '118.99.91.161', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-09-05 16:00:58', 1),
(367, '118.99.91.161', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-09-05 16:20:46', 1),
(368, '118.99.91.161', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-09-05 16:31:22', 1),
(369, '118.99.91.161', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-09-05 17:32:34', 1),
(370, '118.99.91.161', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-09-05 17:40:02', 1),
(371, '118.99.91.161', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-09-05 17:58:02', 1),
(372, '118.99.91.161', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-09-05 18:17:52', 1),
(373, '157.20.244.47', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-09-06 01:47:10', 1),
(374, '182.4.102.27', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-09-06 11:13:12', 1),
(375, '182.4.102.27', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-09-06 11:32:47', 1),
(376, '182.253.106.18', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36 Edg/152.0.0.0', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-09-06 11:33:18', 1),
(377, '182.253.8.162', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36 Edg/152.0.0.0', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-09-06 11:33:33', 1),
(378, '182.253.106.18', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36 Edg/152.0.0.0', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-09-06 11:36:37', 1),
(379, '182.253.8.162', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36 Edg/152.0.0.0', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-09-06 11:36:45', 1),
(380, '157.20.244.47', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-09-21 20:38:13', 1),
(381, '157.20.244.47', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-11-03 09:05:56', 1),
(382, '157.20.244.47', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-11-03 09:13:22', 1),
(383, '157.20.244.47', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-11-03 10:26:52', 1),
(384, '182.4.101.162', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', 'email_password', 'feyfeypor02@gmail.com', 1, '2026-11-07 11:57:11', 1);

-- --------------------------------------------------------

--
-- Table structure for table `auth_permissions_users`
--

CREATE TABLE `auth_permissions_users` (
  `id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `permission` varchar(255) NOT NULL,
  `created_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `auth_remember_tokens`
--

CREATE TABLE `auth_remember_tokens` (
  `id` int(10) UNSIGNED NOT NULL,
  `selector` varchar(255) NOT NULL,
  `hashedValidator` varchar(255) NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `expires` datetime NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `auth_token_logins`
--

CREATE TABLE `auth_token_logins` (
  `id` int(10) UNSIGNED NOT NULL,
  `ip_address` varchar(255) NOT NULL,
  `user_agent` varchar(255) DEFAULT NULL,
  `id_type` varchar(255) NOT NULL,
  `identifier` varchar(255) NOT NULL,
  `user_id` int(10) UNSIGNED DEFAULT NULL,
  `date` datetime NOT NULL,
  `success` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `migrations`
--

CREATE TABLE `migrations` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `version` varchar(255) NOT NULL,
  `class` varchar(255) NOT NULL,
  `group` varchar(255) NOT NULL,
  `namespace` varchar(255) NOT NULL,
  `time` int(11) NOT NULL,
  `batch` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `migrations`
--

INSERT INTO `migrations` (`id`, `version`, `class`, `group`, `namespace`, `time`, `batch`) VALUES
(1, '2020-12-28-223112', 'CodeIgniter\\Shield\\Database\\Migrations\\CreateAuthTables', 'default', 'CodeIgniter\\Shield', 1776582249, 1),
(2, '2021-07-04-041948', 'CodeIgniter\\Settings\\Database\\Migrations\\CreateSettingsTable', 'default', 'CodeIgniter\\Settings', 1776582249, 1),
(3, '2021-11-14-143905', 'CodeIgniter\\Settings\\Database\\Migrations\\AddContextColumn', 'default', 'CodeIgniter\\Settings', 1776582249, 1),
(4, '2026-04-19-090700', 'App\\Database\\Migrations\\CreateTournamentsTable', 'default', 'App', 1776582249, 1),
(5, '2026-04-19-090710', 'App\\Database\\Migrations\\CreatePotsTable', 'default', 'App', 1776582249, 1),
(6, '2026-04-19-090720', 'App\\Database\\Migrations\\CreateTeamsTable', 'default', 'App', 1776582249, 1),
(7, '2026-04-19-090730', 'App\\Database\\Migrations\\CreateScoresTable', 'default', 'App', 1776582249, 1),
(8, '2026-04-19-090740', 'App\\Database\\Migrations\\CreateRegistrationsTable', 'default', 'App', 1776582249, 1),
(9, '2026-04-19-090750', 'App\\Database\\Migrations\\CreatePlayersTable', 'default', 'App', 1776582249, 1),
(10, '2026-04-19-150000', 'App\\Database\\Migrations\\AddStatusToTournamentsTable', 'default', 'App', 1776595568, 2),
(11, '2026-04-19-160000', 'App\\Database\\Migrations\\CreateTeamMembersTable', 'default', 'App', 1776596975, 3),
(12, '2026-04-19-170000', 'App\\Database\\Migrations\\AddReferenceImagesToPotsTable', 'default', 'App', 1776605419, 4),
(13, '2026-04-22-020000', 'App\\Database\\Migrations\\AllowTeamsWithoutPot', 'default', 'App', 1776817173, 5),
(14, '2026-04-22-090000', 'App\\Database\\Migrations\\RemoveRegistrationArtifacts', 'default', 'App', 1776849389, 6);

-- --------------------------------------------------------

--
-- Table structure for table `players`
--

CREATE TABLE `players` (
  `id` char(36) NOT NULL,
  `in_game_name` varchar(150) NOT NULL,
  `user_id` int(10) UNSIGNED DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `deleted_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `players`
--

INSERT INTO `players` (`id`, `in_game_name`, `user_id`, `created_at`, `updated_at`, `deleted_at`) VALUES
('33ba435a-71cd-11f1-8112-9c5c8e5256af', 'aymod sekeng', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33ba4a74-71cd-11f1-8112-9c5c8e5256af', 'Mon', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33ba4c70-71cd-11f1-8112-9c5c8e5256af', 'flyveâ€™z', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33ba4d27-71cd-11f1-8112-9c5c8e5256af', 'jeâ€™reyzenn', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33ba4dcb-71cd-11f1-8112-9c5c8e5256af', 'XIOã…¤SmurFã…¤76', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33ba4f1b-71cd-11f1-8112-9c5c8e5256af', 'MIENG29 BOOD', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33ba4fbb-71cd-11f1-8112-9c5c8e5256af', 'DIYZ BOOD', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33ba5061-71cd-11f1-8112-9c5c8e5256af', 'Zoroâ„¢.ãƒ¡.BTN', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33ba5105-71cd-11f1-8112-9c5c8e5256af', 'BRIZZ BOOD', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33ba51f3-71cd-11f1-8112-9c5c8e5256af', 'k3piN BOOD', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33ba529d-71cd-11f1-8112-9c5c8e5256af', 'Doni Sulistyo', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33ba5339-71cd-11f1-8112-9c5c8e5256af', 'ahmad faiz', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33ba53d9-71cd-11f1-8112-9c5c8e5256af', 'muhammad rangga syahputra', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33ba546f-71cd-11f1-8112-9c5c8e5256af', 'Donny Setiawan', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33ba5515-71cd-11f1-8112-9c5c8e5256af', 'Tidak ada', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33ba55ae-71cd-11f1-8112-9c5c8e5256af', '17don', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33ba564e-71cd-11f1-8112-9c5c8e5256af', 'A31ã…¤Dã…¤SINI', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33ba56fb-71cd-11f1-8112-9c5c8e5256af', 'Rdit\'skibidi', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33ba579b-71cd-11f1-8112-9c5c8e5256af', 'firza.s.pel.', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33ba5839-71cd-11f1-8112-9c5c8e5256af', 'RVAã…¤Dã…¤SINI', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33ba58da-71cd-11f1-8112-9c5c8e5256af', 'Dms D sini', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33ba5976-71cd-11f1-8112-9c5c8e5256af', 'Igr1z', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33ba5a11-71cd-11f1-8112-9c5c8e5256af', 'Jo Yu-ri<3', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33ba5abf-71cd-11f1-8112-9c5c8e5256af', 'KewekTzy', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33ba5b6d-71cd-11f1-8112-9c5c8e5256af', 'â˜…Nexusâ˜…', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33ba5c27-71cd-11f1-8112-9c5c8e5256af', 'Himawan', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33ba5cc4-71cd-11f1-8112-9c5c8e5256af', 'Luka HanÄiÄ‡', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33ba5d60-71cd-11f1-8112-9c5c8e5256af', 'Iruhabusie', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33ba5e02-71cd-11f1-8112-9c5c8e5256af', 'Raditya Putra Pratama', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33ba5eab-71cd-11f1-8112-9c5c8e5256af', 'Rass Tier S', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33ba5f52-71cd-11f1-8112-9c5c8e5256af', 'Luka Hancic', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33ba5ff7-71cd-11f1-8112-9c5c8e5256af', 'Minivel', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33ba609b-71cd-11f1-8112-9c5c8e5256af', 'bÃ mzÃ¡cmÃ©dlv', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33ba614c-71cd-11f1-8112-9c5c8e5256af', 'seraaxcy', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33ba61f8-71cd-11f1-8112-9c5c8e5256af', 'JaXcKeizy', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33ba629d-71cd-11f1-8112-9c5c8e5256af', 'Minivel(bayu)', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33ba6347-71cd-11f1-8112-9c5c8e5256af', 'Jembrawokkk', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33ba63e9-71cd-11f1-8112-9c5c8e5256af', 'diqaa', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33ba6488-71cd-11f1-8112-9c5c8e5256af', 'saos\'s', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33ba656f-71cd-11f1-8112-9c5c8e5256af', '99.Rockeess', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33ba6627-71cd-11f1-8112-9c5c8e5256af', 'BELUM ADA', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33ba66c9-71cd-11f1-8112-9c5c8e5256af', 'your\'e.okay?', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33ba6766-71cd-11f1-8112-9c5c8e5256af', 'GHANIZZ STR', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33ba680b-71cd-11f1-8112-9c5c8e5256af', 'â‰ Satzy2k11', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33ba68b0-71cd-11f1-8112-9c5c8e5256af', 'sentralcg.id', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33ba6953-71cd-11f1-8112-9c5c8e5256af', 'LEN D SINI??', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33ba6a20-71cd-11f1-8112-9c5c8e5256af', 'HC JEKK10!', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33ba6b14-71cd-11f1-8112-9c5c8e5256af', 'HA???ã…¤ã…¤RAUF', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33ba91da-71cd-11f1-8112-9c5c8e5256af', 'panzmalesMVP', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33ba9507-71cd-11f1-8112-9c5c8e5256af', 'jupartyz', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33ba95e6-71cd-11f1-8112-9c5c8e5256af', 'AB.V1NZ!', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33ba969f-71cd-11f1-8112-9c5c8e5256af', '-princeLarry', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33ba9772-71cd-11f1-8112-9c5c8e5256af', 'SAMTEK+OLES', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33ba9830-71cd-11f1-8112-9c5c8e5256af', 'atap dis', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33ba98d4-71cd-11f1-8112-9c5c8e5256af', 'Adonis Belva Nur Cahyono (MVL JESTER)', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33ba997c-71cd-11f1-8112-9c5c8e5256af', 'SnoopyÂ¡', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33ba9a23-71cd-11f1-8112-9c5c8e5256af', 'Manz Gacor?', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33ba9ac4-71cd-11f1-8112-9c5c8e5256af', '_Mass_kall', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33ba9b66-71cd-11f1-8112-9c5c8e5256af', 'royy bott', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33ba9c0a-71cd-11f1-8112-9c5c8e5256af', 'anomalies', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33ba9cb1-71cd-11f1-8112-9c5c8e5256af', 'BRD THOOK', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33ba9d52-71cd-11f1-8112-9c5c8e5256af', 'silit_kenari', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33ba9df1-71cd-11f1-8112-9c5c8e5256af', 'toblut_134', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33ba9e93-71cd-11f1-8112-9c5c8e5256af', 'â™¡MEYâ™¡â€¢', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33ba9f6b-71cd-11f1-8112-9c5c8e5256af', '@aastgallvy`', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33baa022-71cd-11f1-8112-9c5c8e5256af', 'â“‹IPSKãƒ»PUTRA', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33baa0ef-71cd-11f1-8112-9c5c8e5256af', 'Yanz`PRIME', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33baa19d-71cd-11f1-8112-9c5c8e5256af', 'ê§@AdÍ¥itÍ£yÍ«à¸ªà¿', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33baa24f-71cd-11f1-8112-9c5c8e5256af', 'JAWAMOKEEL', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33baa2f4-71cd-11f1-8112-9c5c8e5256af', 'Danzz', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33baa39c-71cd-11f1-8112-9c5c8e5256af', 'EVOS.Ekscuyy', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33baa441-71cd-11f1-8112-9c5c8e5256af', 'EVOS.Rambatt', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33baa4f0-71cd-11f1-8112-9c5c8e5256af', 'EVOS.Basryy', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33baa598-71cd-11f1-8112-9c5c8e5256af', 'EVOS.Hï£¿Paaa', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33baa63e-71cd-11f1-8112-9c5c8e5256af', 'EVOS.Apenggg', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33baa6ee-71cd-11f1-8112-9c5c8e5256af', 'VinZz|LG', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33baa799-71cd-11f1-8112-9c5c8e5256af', 'rulzzzz++â€¡', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33baa83c-71cd-11f1-8112-9c5c8e5256af', '4everyoungÂ°', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33baa8dc-71cd-11f1-8112-9c5c8e5256af', 'Dojun...', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33baaa25-71cd-11f1-8112-9c5c8e5256af', 'LORD $|ÎœÎ¡Î Î™', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33baaac7-71cd-11f1-8112-9c5c8e5256af', 'Penn X PgSoft', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33baab63-71cd-11f1-8112-9c5c8e5256af', '4ndxa-', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33baabff-71cd-11f1-8112-9c5c8e5256af', 'Aura Ozzy', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33baac9a-71cd-11f1-8112-9c5c8e5256af', 'vinzyyy.ï£¿', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33baad3a-71cd-11f1-8112-9c5c8e5256af', 'JMD.Bbek', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33baadd5-71cd-11f1-8112-9c5c8e5256af', 'NB.Ghost', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33baae71-71cd-11f1-8112-9c5c8e5256af', 'demm\'', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33baaf07-71cd-11f1-8112-9c5c8e5256af', 'GHATHFAN35', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33baaf9f-71cd-11f1-8112-9c5c8e5256af', 'Lynxx azza', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bab03a-71cd-11f1-8112-9c5c8e5256af', 'GHERALDY NINO GHELVIANO', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bab0d0-71cd-11f1-8112-9c5c8e5256af', 'el azar rifa abdillah', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bab165-71cd-11f1-8112-9c5c8e5256af', 'RADITYA FIKRI SULISTYAWAN', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bab219-71cd-11f1-8112-9c5c8e5256af', 'supri', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bab2b2-71cd-11f1-8112-9c5c8e5256af', 'PIONSSS', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bab347-71cd-11f1-8112-9c5c8e5256af', 'this is nino', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bab3da-71cd-11f1-8112-9c5c8e5256af', 'Ãlz!ã…¤ã…¤ã…¤ã…¤ã…¤', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bab470-71cd-11f1-8112-9c5c8e5256af', 'Barnaclesz!â˜…', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bab506-71cd-11f1-8112-9c5c8e5256af', 'Apocalypseà¥¯', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bab5a9-71cd-11f1-8112-9c5c8e5256af', 'Å•Åºã…¤xÓ³ã…¤ÅºÃ¡Ã¡.', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bab644-71cd-11f1-8112-9c5c8e5256af', 'tidak ada player cadangan', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bab6dc-71cd-11f1-8112-9c5c8e5256af', 'â€”C4LLMEED4N', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bab76e-71cd-11f1-8112-9c5c8e5256af', 'TEH ã…¤ã…¤MUANI-S', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bab800-71cd-11f1-8112-9c5c8e5256af', 'Zá´€á´€á´€âš¡', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bab892-71cd-11f1-8112-9c5c8e5256af', 'RVã…¤â€¢ã…¤ï¼²ï½…ï½šï½ï½Žæ§˜', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bab928-71cd-11f1-8112-9c5c8e5256af', 'SEKETTER|88', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bab9d0-71cd-11f1-8112-9c5c8e5256af', '$\'á”hyã…¤á´˜á´€É´Ñ•\'$', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33baba67-71cd-11f1-8112-9c5c8e5256af', 'ONIC--Ryzenn', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33babaf8-71cd-11f1-8112-9c5c8e5256af', '@Almaaaaa', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33babb8f-71cd-11f1-8112-9c5c8e5256af', 'Duhã€Pippp.', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33babc21-71cd-11f1-8112-9c5c8e5256af', 'PRESIDEN EXE', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33babcb2-71cd-11f1-8112-9c5c8e5256af', 'TFOSãƒ»zÎ±Ðº`ã€…', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33babd49-71cd-11f1-8112-9c5c8e5256af', 'PCC!!????', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33babddf-71cd-11f1-8112-9c5c8e5256af', 'AWANN NJIR', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33babe73-71cd-11f1-8112-9c5c8e5256af', 'Kenshuusah', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33babf04-71cd-11f1-8112-9c5c8e5256af', 'K1O Franz', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33babf95-71cd-11f1-8112-9c5c8e5256af', 'K1O Vineiei', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bac029-71cd-11f1-8112-9c5c8e5256af', 'K1O Hanzz', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bac0c0-71cd-11f1-8112-9c5c8e5256af', 'RVG YANZ', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bac151-71cd-11f1-8112-9c5c8e5256af', 'Shavinsxsx', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bac1e4-71cd-11f1-8112-9c5c8e5256af', 'aldeny', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bac278-71cd-11f1-8112-9c5c8e5256af', 'nada', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bac309-71cd-11f1-8112-9c5c8e5256af', 'jeppa ange', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bac39b-71cd-11f1-8112-9c5c8e5256af', 'evos syamm', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bac42d-71cd-11f1-8112-9c5c8e5256af', 'axecell', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bac4cc-71cd-11f1-8112-9c5c8e5256af', 'Zeuss', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bac561-71cd-11f1-8112-9c5c8e5256af', 'GRX Cuteboy', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bac5f4-71cd-11f1-8112-9c5c8e5256af', 'Mel4ver', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bac6b0-71cd-11f1-8112-9c5c8e5256af', 'KAMENFEDER', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bac748-71cd-11f1-8112-9c5c8e5256af', '-callistaaa', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bac866-71cd-11f1-8112-9c5c8e5256af', 'ZEUS', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bac919-71cd-11f1-8112-9c5c8e5256af', 'Ndap+++', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bac9b0-71cd-11f1-8112-9c5c8e5256af', 'ZaaaMadaa !!', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33baca47-71cd-11f1-8112-9c5c8e5256af', 'Radzpaker', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bacadd-71cd-11f1-8112-9c5c8e5256af', 'El.Venuzz', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bacb6e-71cd-11f1-8112-9c5c8e5256af', 'Franxxzzzz', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bacc01-71cd-11f1-8112-9c5c8e5256af', 'Ndapp+++', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bacc98-71cd-11f1-8112-9c5c8e5256af', 'å‹ALMOD', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bacd2a-71cd-11f1-8112-9c5c8e5256af', '-ndÃ©nã…¤ndÂ¡nã…¤', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bacdbe-71cd-11f1-8112-9c5c8e5256af', 'DIARAAAAA\'s', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bacf10-71cd-11f1-8112-9c5c8e5256af', 'kakk?cpongin', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bad062-71cd-11f1-8112-9c5c8e5256af', '1onlyone.', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bad101-71cd-11f1-8112-9c5c8e5256af', 'STAR8 AHMAD', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bad19a-71cd-11f1-8112-9c5c8e5256af', '-ThrNepthys', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bad246-71cd-11f1-8112-9c5c8e5256af', 'kimbotwtâ´', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bad2eb-71cd-11f1-8112-9c5c8e5256af', 'FX.Razor\'', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bad38f-71cd-11f1-8112-9c5c8e5256af', 'MBR.SKYBIN', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bad42b-71cd-11f1-8112-9c5c8e5256af', 'BRU.Rapyz', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bad4c3-71cd-11f1-8112-9c5c8e5256af', 'NOc78 toblut', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bad55c-71cd-11f1-8112-9c5c8e5256af', 'preman sg', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bad5f4-71cd-11f1-8112-9c5c8e5256af', 'preman bkp', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bad6ba-71cd-11f1-8112-9c5c8e5256af', 'preman ft', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bad760-71cd-11f1-8112-9c5c8e5256af', 'no527fa73be9', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bad802-71cd-11f1-8112-9c5c8e5256af', 'preman st', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bad90b-71cd-11f1-8112-9c5c8e5256af', 'DITHIGH', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bad9b5-71cd-11f1-8112-9c5c8e5256af', 'SadlySukaMik', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bada55-71cd-11f1-8112-9c5c8e5256af', 'ENDOXZ_2137', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33badaf1-71cd-11f1-8112-9c5c8e5256af', 'N2D\' PETRUKà¸™6', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33badb8c-71cd-11f1-8112-9c5c8e5256af', 'Raafzz4u', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33badc24-71cd-11f1-8112-9c5c8e5256af', 'Allsttret!!', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33badcb8-71cd-11f1-8112-9c5c8e5256af', 'Allstvan', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33badd50-71cd-11f1-8112-9c5c8e5256af', 'Allszen', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bade90-71cd-11f1-8112-9c5c8e5256af', 'Allszee...', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33badf2d-71cd-11f1-8112-9c5c8e5256af', 'TIDAK ADA PEMAIN CADANGAN.', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33badfcf-71cd-11f1-8112-9c5c8e5256af', 'Novan', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bae072-71cd-11f1-8112-9c5c8e5256af', 'Lekkã…¤Supri\'', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bae113-71cd-11f1-8112-9c5c8e5256af', 'Thruffle.', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bae1b0-71cd-11f1-8112-9c5c8e5256af', 'llael french', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bae24f-71cd-11f1-8112-9c5c8e5256af', 'Kaavyz', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bae2f7-71cd-11f1-8112-9c5c8e5256af', 'nntav4', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bae3b4-71cd-11f1-8112-9c5c8e5256af', 'BsKâ€¢CR7âˆšâ„¢Â©Â®*', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bae460-71cd-11f1-8112-9c5c8e5256af', 'RavennnnTzy', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bae4fc-71cd-11f1-8112-9c5c8e5256af', 'NalaElittã‰¨', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bae596-71cd-11f1-8112-9c5c8e5256af', 'HendyElitt', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bae633-71cd-11f1-8112-9c5c8e5256af', 'ManUrafBoy75', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bae6c9-71cd-11f1-8112-9c5c8e5256af', '@vanilaarawr', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL);
INSERT INTO `players` (`id`, `in_game_name`, `user_id`, `created_at`, `updated_at`, `deleted_at`) VALUES
('33bae769-71cd-11f1-8112-9c5c8e5256af', 'Ritz embege`', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bae801-71cd-11f1-8112-9c5c8e5256af', 'Yth.Tejieh\'', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bae962-71cd-11f1-8112-9c5c8e5256af', 'vara karamoy', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33baeadd-71cd-11f1-8112-9c5c8e5256af', 'epos safa', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33baeb80-71cd-11f1-8112-9c5c8e5256af', '@vanillaarawr', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33baec2f-71cd-11f1-8112-9c5c8e5256af', 'LAê‹ŠA', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33baecd1-71cd-11f1-8112-9c5c8e5256af', 'SKN1SA.Grizz', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33baedcf-71cd-11f1-8112-9c5c8e5256af', 'SKN1SA.W1zaN', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33baee7a-71cd-11f1-8112-9c5c8e5256af', 'kael', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33baef1c-71cd-11f1-8112-9c5c8e5256af', 'JogjaNathan', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33baefbc-71cd-11f1-8112-9c5c8e5256af', 'chococupss', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33baf162-71cd-11f1-8112-9c5c8e5256af', 'AhliGiziMBG', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33baf2b0-71cd-11f1-8112-9c5c8e5256af', 'Yahahayann', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33baf352-71cd-11f1-8112-9c5c8e5256af', 'Santanaeiei', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33baf401-71cd-11f1-8112-9c5c8e5256af', 'atsalhigh!?', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bb30be-71cd-11f1-8112-9c5c8e5256af', 'Feit44NNeiei', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bb32e4-71cd-11f1-8112-9c5c8e5256af', 'Bagindapzz', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bb353e-71cd-11f1-8112-9c5c8e5256af', 'nanuyâ€™s', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bb36a2-71cd-11f1-8112-9c5c8e5256af', 'amy karmis', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bb37fc-71cd-11f1-8112-9c5c8e5256af', 'BTRxJO15Nyr', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bb38bd-71cd-11f1-8112-9c5c8e5256af', 'KZ.Joshua', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bb3962-71cd-11f1-8112-9c5c8e5256af', 'heavenly.', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bb3a01-71cd-11f1-8112-9c5c8e5256af', '2012960851 (y)', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bb3a9f-71cd-11f1-8112-9c5c8e5256af', '1666400670', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bb3c1f-71cd-11f1-8112-9c5c8e5256af', 'ZICOSTECUU', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bb3e35-71cd-11f1-8112-9c5c8e5256af', 'Just Time', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bb3f8c-71cd-11f1-8112-9c5c8e5256af', 'Majin Buu', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bb419a-71cd-11f1-8112-9c5c8e5256af', 'KINGSS', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bb4380-71cd-11f1-8112-9c5c8e5256af', 'dit vinesty', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bb4426-71cd-11f1-8112-9c5c8e5256af', 'SenzraÃ—', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bb44bc-71cd-11f1-8112-9c5c8e5256af', 'navlftan2nd', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bb454d-71cd-11f1-8112-9c5c8e5256af', '151 PIU', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bb45e0-71cd-11f1-8112-9c5c8e5256af', 'riifkii969!', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bb4672-71cd-11f1-8112-9c5c8e5256af', 'Yuud VGS', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bb4702-71cd-11f1-8112-9c5c8e5256af', 'DLxPIZZ', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bb47a9-71cd-11f1-8112-9c5c8e5256af', 'DLxIkaLL', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bb4840-71cd-11f1-8112-9c5c8e5256af', 'DLxFoxyy', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bb48d5-71cd-11f1-8112-9c5c8e5256af', 'DLx4ffndi27`', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bb4969-71cd-11f1-8112-9c5c8e5256af', 'PRO iHamm', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bb4a00-71cd-11f1-8112-9c5c8e5256af', 'iham16', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bb4a92-71cd-11f1-8112-9c5c8e5256af', 'L A T I F', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bb4b22-71cd-11f1-8112-9c5c8e5256af', 'cunkpret21', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bb4bb5-71cd-11f1-8112-9c5c8e5256af', 'AllStar', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bb4c48-71cd-11f1-8112-9c5c8e5256af', 'W', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bb4cda-71cd-11f1-8112-9c5c8e5256af', 'CINDO!!', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bb4d6c-71cd-11f1-8112-9c5c8e5256af', 'putz the lucio', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bb4dfd-71cd-11f1-8112-9c5c8e5256af', 'raup konblut', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bb4e8e-71cd-11f1-8112-9c5c8e5256af', 'VGSxTheFlash', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bb4f2a-71cd-11f1-8112-9c5c8e5256af', 'RissXasu', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bb4fbb-71cd-11f1-8112-9c5c8e5256af', '[[DGX]] Sambo', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bb504e-71cd-11f1-8112-9c5c8e5256af', 'ilmuHytam!!!', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bb50de-71cd-11f1-8112-9c5c8e5256af', 'Porsche3', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bb516f-71cd-11f1-8112-9c5c8e5256af', 'Supreme', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bb5201-71cd-11f1-8112-9c5c8e5256af', 'HamzEinstein', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bb5295-71cd-11f1-8112-9c5c8e5256af', 'user51471125', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bb5338-71cd-11f1-8112-9c5c8e5256af', 'namzahahahaa', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bb53c9-71cd-11f1-8112-9c5c8e5256af', 'welly hebat', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bb545c-71cd-11f1-8112-9c5c8e5256af', 'Octavian Aidil Nugraha - Williee', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bb54eb-71cd-11f1-8112-9c5c8e5256af', 'julemylovely', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bb557b-71cd-11f1-8112-9c5c8e5256af', 'cyyraaaaaa.', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bb5609-71cd-11f1-8112-9c5c8e5256af', 'NOET.Xora', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bb5699-71cd-11f1-8112-9c5c8e5256af', 'gopudexpres', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bb5729-71cd-11f1-8112-9c5c8e5256af', 'GOGROK STYLE', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bb57bf-71cd-11f1-8112-9c5c8e5256af', 'Alzzcangcut', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bb584f-71cd-11f1-8112-9c5c8e5256af', 'iHam\'16', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bb58de-71cd-11f1-8112-9c5c8e5256af', 'LATIF', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bb5972-71cd-11f1-8112-9c5c8e5256af', 'kpd yth 4rta', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bb5a01-71cd-11f1-8112-9c5c8e5256af', 'Almanz OLF', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bb5a9e-71cd-11f1-8112-9c5c8e5256af', 'Renok3recet\'', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bb5b31-71cd-11f1-8112-9c5c8e5256af', 'VarXx', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bb5bcc-71cd-11f1-8112-9c5c8e5256af', 'Negr0Sigma', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bb5d59-71cd-11f1-8112-9c5c8e5256af', '\"SukiLiar\"', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bb5dfa-71cd-11f1-8112-9c5c8e5256af', 'lyncia', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bb5fe8-71cd-11f1-8112-9c5c8e5256af', 'mÃ¡chÃ¡lattÃ©??', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bb61ff-71cd-11f1-8112-9c5c8e5256af', '??PRI?NCE??!', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bb62a1-71cd-11f1-8112-9c5c8e5256af', 'REX?Void-', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bb64cc-71cd-11f1-8112-9c5c8e5256af', 'CELIDHO???', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bb656f-71cd-11f1-8112-9c5c8e5256af', 'Khanz 1M?', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bb66e1-71cd-11f1-8112-9c5c8e5256af', '?ONE LIGHT?', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bb6824-71cd-11f1-8112-9c5c8e5256af', 'BRU.4STREUSS', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bb6966-71cd-11f1-8112-9c5c8e5256af', 'emoyourfav', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bb6a01-71cd-11f1-8112-9c5c8e5256af', 'THEON1C.SZA\'', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bb6de8-71cd-11f1-8112-9c5c8e5256af', 'yareuuu', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bb6f9c-71cd-11f1-8112-9c5c8e5256af', 'qero120fps', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bb703f-71cd-11f1-8112-9c5c8e5256af', 'JGLemjeee', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bb70d7-71cd-11f1-8112-9c5c8e5256af', 'JGLNouzen', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bb716b-71cd-11f1-8112-9c5c8e5256af', 'GEEF.iRoeebb', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bb7208-71cd-11f1-8112-9c5c8e5256af', 'REDSVETRAA7', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bb7304-71cd-11f1-8112-9c5c8e5256af', 'STARS Linzy', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bb73ab-71cd-11f1-8112-9c5c8e5256af', 'STARS Yupii', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bb743e-71cd-11f1-8112-9c5c8e5256af', 'TPxVtrick', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bb74d1-71cd-11f1-8112-9c5c8e5256af', 'SANNZA GVS', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bb7562-71cd-11f1-8112-9c5c8e5256af', '??????Yao?', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bb7609-71cd-11f1-8112-9c5c8e5256af', 'F-R-N-D-z-z', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bb769d-71cd-11f1-8112-9c5c8e5256af', 'marloung12', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bb7730-71cd-11f1-8112-9c5c8e5256af', '256bianndraa', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bb77c1-71cd-11f1-8112-9c5c8e5256af', '.YONZZZ.', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bb7853-71cd-11f1-8112-9c5c8e5256af', 'LUX?ZILL??', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bb78e6-71cd-11f1-8112-9c5c8e5256af', '~soxrrwikz_~', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bb7978-71cd-11f1-8112-9c5c8e5256af', 'arda??yes?bb', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bb7a08-71cd-11f1-8112-9c5c8e5256af', 'Ertwod.', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bb7a9a-71cd-11f1-8112-9c5c8e5256af', 'Huemhahahahahahaha', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bb7b30-71cd-11f1-8112-9c5c8e5256af', 'Clamrinee', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bb7bc1-71cd-11f1-8112-9c5c8e5256af', 'idc\'715', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bb7c5b-71cd-11f1-8112-9c5c8e5256af', 'nabilfreynto', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bb7cf1-71cd-11f1-8112-9c5c8e5256af', 'dapaamostdie', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bb7d87-71cd-11f1-8112-9c5c8e5256af', 'Ruzzr', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bb7e1a-71cd-11f1-8112-9c5c8e5256af', 'Vinolonely', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bb7eab-71cd-11f1-8112-9c5c8e5256af', 'Ayame', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bb7f3d-71cd-11f1-8112-9c5c8e5256af', 'Aruzze', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bb7fcc-71cd-11f1-8112-9c5c8e5256af', 'hannnxs', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bb805d-71cd-11f1-8112-9c5c8e5256af', 'knuuu', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bbb270-71cd-11f1-8112-9c5c8e5256af', 'reys loser', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bbb419-71cd-11f1-8112-9c5c8e5256af', 'mingyanjamsut', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bbb4be-71cd-11f1-8112-9c5c8e5256af', 'chillgod', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bbb559-71cd-11f1-8112-9c5c8e5256af', '-pan', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bbb5f0-71cd-11f1-8112-9c5c8e5256af', 'Donor_Kouta', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bbb685-71cd-11f1-8112-9c5c8e5256af', '~MAYA~1~', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bbb719-71cd-11f1-8112-9c5c8e5256af', 'KadalPapua', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bbb7af-71cd-11f1-8112-9c5c8e5256af', '-Miloo19', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bbb844-71cd-11f1-8112-9c5c8e5256af', 'DLxCrown', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bbb8d6-71cd-11f1-8112-9c5c8e5256af', 'BTR.Zekkay', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bbb975-71cd-11f1-8112-9c5c8e5256af', 'Allszee', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bbba0d-71cd-11f1-8112-9c5c8e5256af', '-Obyybee', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bbbaa0-71cd-11f1-8112-9c5c8e5256af', 'gak adaa', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bbbb32-71cd-11f1-8112-9c5c8e5256af', '-RÃ¨nnyuw', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bbbbc3-71cd-11f1-8112-9c5c8e5256af', '?ell??', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bbbd00-71cd-11f1-8112-9c5c8e5256af', 'userr345677', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bbbd96-71cd-11f1-8112-9c5c8e5256af', 'VESSEL', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bbbe2e-71cd-11f1-8112-9c5c8e5256af', 'yukirrr', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bbbef1-71cd-11f1-8112-9c5c8e5256af', 'NANTAGANTENK', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bbbfda-71cd-11f1-8112-9c5c8e5256af', 'JustNap\'', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bbc189-71cd-11f1-8112-9c5c8e5256af', 'kak? ciyummm', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bbc2dc-71cd-11f1-8112-9c5c8e5256af', 'kak? susu', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bbc378-71cd-11f1-8112-9c5c8e5256af', 'ATH X - NIGHT', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bbc413-71cd-11f1-8112-9c5c8e5256af', 'Â¥udh?Ti2417A', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bbc4b0-71cd-11f1-8112-9c5c8e5256af', 'V7-TOGA', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bbc550-71cd-11f1-8112-9c5c8e5256af', 'WhoMadeDark', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bbc5ee-71cd-11f1-8112-9c5c8e5256af', 'NIGHT ELITE', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bbc738-71cd-11f1-8112-9c5c8e5256af', '?ALMOD', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bbc898-71cd-11f1-8112-9c5c8e5256af', '-ndÃ©n?ndÂ¡n?', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bbc93c-71cd-11f1-8112-9c5c8e5256af', 'AR.Lhang', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bbc9dc-71cd-11f1-8112-9c5c8e5256af', 'PB MALBORO', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bbcb2c-71cd-11f1-8112-9c5c8e5256af', 'PB APPEL76', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bbcbcb-71cd-11f1-8112-9c5c8e5256af', 'PB DIPLOMAT', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bbcc6b-71cd-11f1-8112-9c5c8e5256af', 'RriidOoo', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bbcdb1-71cd-11f1-8112-9c5c8e5256af', 'tidak memakai cadangan', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bbce4b-71cd-11f1-8112-9c5c8e5256af', 'Kaizen', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bbcf9c-71cd-11f1-8112-9c5c8e5256af', 'allsukaturu', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bbd03d-71cd-11f1-8112-9c5c8e5256af', 'Jookulbet', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bbd1bd-71cd-11f1-8112-9c5c8e5256af', 'sr kpt', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bbd26f-71cd-11f1-8112-9c5c8e5256af', 'Sky / roonns', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bbd31d-71cd-11f1-8112-9c5c8e5256af', 'Lahin', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bbd3c2-71cd-11f1-8112-9c5c8e5256af', 'Anjar', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bbd468-71cd-11f1-8112-9c5c8e5256af', 'Javas', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bbd50c-71cd-11f1-8112-9c5c8e5256af', 'Kosong', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bbd63b-71cd-11f1-8112-9c5c8e5256af', 'Marlboro?~', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bbd6e5-71cd-11f1-8112-9c5c8e5256af', 'i\'m?Rahmw', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bbd787-71cd-11f1-8112-9c5c8e5256af', 'nihhhsam', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bbd82a-71cd-11f1-8112-9c5c8e5256af', 'GaniasyaÂ’ba', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bbd8cb-71cd-11f1-8112-9c5c8e5256af', 'supersholl', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bbd971-71cd-11f1-8112-9c5c8e5256af', 'IVS Aryatzy', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bbda1c-71cd-11f1-8112-9c5c8e5256af', 'SUPER Nayeon', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bbdac4-71cd-11f1-8112-9c5c8e5256af', '~c h a s p e r', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bbdb68-71cd-11f1-8112-9c5c8e5256af', 'lz.Neverlus', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bbdc12-71cd-11f1-8112-9c5c8e5256af', 'whiz del rey', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bbdcbb-71cd-11f1-8112-9c5c8e5256af', 'IQ150', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bbdd65-71cd-11f1-8112-9c5c8e5256af', 'rulzzzz++', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bbde03-71cd-11f1-8112-9c5c8e5256af', 'SRGxmukz', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bbdeac-71cd-11f1-8112-9c5c8e5256af', '@senooke_', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bbdf50-71cd-11f1-8112-9c5c8e5256af', 'kim junggot', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bbdff8-71cd-11f1-8112-9c5c8e5256af', 'BRU.Eclipse', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bbe09e-71cd-11f1-8112-9c5c8e5256af', 'BRU.Megadeth', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bbe14b-71cd-11f1-8112-9c5c8e5256af', 'BRU.ZAIBUZAI', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bbe1ed-71cd-11f1-8112-9c5c8e5256af', 'Ryzo05', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bbe292-71cd-11f1-8112-9c5c8e5256af', 'A f 1', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bbe341-71cd-11f1-8112-9c5c8e5256af', 'ROSIDMEN.', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL);
INSERT INTO `players` (`id`, `in_game_name`, `user_id`, `created_at`, `updated_at`, `deleted_at`) VALUES
('33bbe3e7-71cd-11f1-8112-9c5c8e5256af', 'Razzorr.Ja', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bbe589-71cd-11f1-8112-9c5c8e5256af', '`CaesarÂ®', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bbe661-71cd-11f1-8112-9c5c8e5256af', 'N2B?Danzzz', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bbe70b-71cd-11f1-8112-9c5c8e5256af', 'STAYZÂ’Stecu', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bbe7b7-71cd-11f1-8112-9c5c8e5256af', 'apocaalypse.', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bbe85c-71cd-11f1-8112-9c5c8e5256af', 'zaa15years', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bbe8fa-71cd-11f1-8112-9c5c8e5256af', 'who', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bbe996-71cd-11f1-8112-9c5c8e5256af', 's?stecu?', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bbea31-71cd-11f1-8112-9c5c8e5256af', 'vnehsa', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bbeb71-71cd-11f1-8112-9c5c8e5256af', 'liu mey', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bbecd8-71cd-11f1-8112-9c5c8e5256af', 'viberly', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bbed7d-71cd-11f1-8112-9c5c8e5256af', 'gabriela', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bbee28-71cd-11f1-8112-9c5c8e5256af', 'Atapat', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bbef7d-71cd-11f1-8112-9c5c8e5256af', 'cyraaaa', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bbf030-71cd-11f1-8112-9c5c8e5256af', 'DLxLEYWINExyz', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bbf0df-71cd-11f1-8112-9c5c8e5256af', 'MohJakii', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bbf182-71cd-11f1-8112-9c5c8e5256af', 'GzlYhuNicy27', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bbf224-71cd-11f1-8112-9c5c8e5256af', 'CARHARTT.WIP', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bbf2c6-71cd-11f1-8112-9c5c8e5256af', 'vitodelouise', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bbf36a-71cd-11f1-8112-9c5c8e5256af', 'VRTC.Fann21', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bbf40d-71cd-11f1-8112-9c5c8e5256af', 'BABONÂ™88', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bbf557-71cd-11f1-8112-9c5c8e5256af', 'NEWCSTL.RITZ', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bc69c2-71cd-11f1-8112-9c5c8e5256af', 'NEWCSTL.PRAM', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bc6b3a-71cd-11f1-8112-9c5c8e5256af', 'BerTÃ¸T~', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bc6bfb-71cd-11f1-8112-9c5c8e5256af', 'FTBULEJAWA', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bc6ca9-71cd-11f1-8112-9c5c8e5256af', 'zoro x BTN', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bc6d57-71cd-11f1-8112-9c5c8e5256af', 'K3pin Ã— brn', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bc6dfd-71cd-11f1-8112-9c5c8e5256af', 'DIYN BOOD', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bc6eb3-71cd-11f1-8112-9c5c8e5256af', 'Lord\'Oboy', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bc6f55-71cd-11f1-8112-9c5c8e5256af', 'Fanzz44ever!', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bc6ff5-71cd-11f1-8112-9c5c8e5256af', 'm1e4yam77', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bc7091-71cd-11f1-8112-9c5c8e5256af', 'bndar inex', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bc712b-71cd-11f1-8112-9c5c8e5256af', 'hexymer 2mg', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bc71c4-71cd-11f1-8112-9c5c8e5256af', 'WIZARDDD!', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bc725f-71cd-11f1-8112-9c5c8e5256af', 'PUKKIS.BOY', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bc72f8-71cd-11f1-8112-9c5c8e5256af', '@senookee-', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bc7392-71cd-11f1-8112-9c5c8e5256af', 'nash!yna', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bc743b-71cd-11f1-8112-9c5c8e5256af', 'nabilfrynto_', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bc74d8-71cd-11f1-8112-9c5c8e5256af', '_adok', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bc7571-71cd-11f1-8112-9c5c8e5256af', '?T??????_?', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bc760c-71cd-11f1-8112-9c5c8e5256af', '76?Miloow', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bc76a3-71cd-11f1-8112-9c5c8e5256af', '???Xzzy', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bc773e-71cd-11f1-8112-9c5c8e5256af', 'cawettpink><', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bc77d9-71cd-11f1-8112-9c5c8e5256af', 'USPETKLEPET', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bc7871-71cd-11f1-8112-9c5c8e5256af', 'SAMIWW15', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bc790e-71cd-11f1-8112-9c5c8e5256af', '--lyonelhpyzy', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bc79a7-71cd-11f1-8112-9c5c8e5256af', 'h56', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bc7a4e-71cd-11f1-8112-9c5c8e5256af', 'dagingbakar', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bc7b54-71cd-11f1-8112-9c5c8e5256af', 'Ardh|Noay', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bc7c04-71cd-11f1-8112-9c5c8e5256af', 'Lempis Enak', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bc7ca2-71cd-11f1-8112-9c5c8e5256af', 'Gf.Nuts', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bc7d3e-71cd-11f1-8112-9c5c8e5256af', 'Cha YeonWoo', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bc7dd5-71cd-11f1-8112-9c5c8e5256af', 'Gf.Ilus', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bc7e6d-71cd-11f1-8112-9c5c8e5256af', 'HixeeGOD', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bc7f06-71cd-11f1-8112-9c5c8e5256af', 'EkxeGOD', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bc7f9c-71cd-11f1-8112-9c5c8e5256af', 'Dpiii', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bc805a-71cd-11f1-8112-9c5c8e5256af', 'WANNTZY', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bc80f5-71cd-11f1-8112-9c5c8e5256af', 'Ptraaaa', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bc818f-71cd-11f1-8112-9c5c8e5256af', 'itsbaraw id :9001431879', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bc8229-71cd-11f1-8112-9c5c8e5256af', 'jir?Ã¢dÃ¢?rÃ³y id :9255428176', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bc82c2-71cd-11f1-8112-9c5c8e5256af', 'damn daniel id:4046185711', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bc835a-71cd-11f1-8112-9c5c8e5256af', 'Alien `|NVY id:2127485831', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bc83f2-71cd-11f1-8112-9c5c8e5256af', 'gaada', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bc848e-71cd-11f1-8112-9c5c8e5256af', 'BELVA', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bc852e-71cd-11f1-8112-9c5c8e5256af', 'wtf!!L?', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bc85cc-71cd-11f1-8112-9c5c8e5256af', 'knp nyak?', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bc8679-71cd-11f1-8112-9c5c8e5256af', 'mrzaalw-', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bc8716-71cd-11f1-8112-9c5c8e5256af', 'i4MZAACK', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bc87af-71cd-11f1-8112-9c5c8e5256af', 'BRU.Rapzy', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bc8846-71cd-11f1-8112-9c5c8e5256af', 'FX.Razor', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bc88e2-71cd-11f1-8112-9c5c8e5256af', '-BLÂ•Lx11.JT!', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bc897a-71cd-11f1-8112-9c5c8e5256af', 'JRNxRizky', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bc8a13-71cd-11f1-8112-9c5c8e5256af', 'rodibabi24', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bc8aad-71cd-11f1-8112-9c5c8e5256af', 'ES.MATCHAAA', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bc8c28-71cd-11f1-8112-9c5c8e5256af', 'MieJebewLv99', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bc8cd0-71cd-11f1-8112-9c5c8e5256af', 'zee4youuu!!', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bc8d6a-71cd-11f1-8112-9c5c8e5256af', '~MANN~', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL),
('33bc8e03-71cd-11f1-8112-9c5c8e5256af', 'N2D\' PETRUK?6', NULL, '2026-06-27 09:09:17', '2026-06-27 09:09:17', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `point_systems`
--

CREATE TABLE `point_systems` (
  `id` int(10) UNSIGNED NOT NULL,
  `rank_no` tinyint(3) UNSIGNED NOT NULL,
  `placement_point` tinyint(3) UNSIGNED NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `point_systems`
--

INSERT INTO `point_systems` (`id`, `rank_no`, `placement_point`, `active`) VALUES
(1, 1, 12, 1),
(2, 2, 9, 1),
(3, 3, 8, 1),
(4, 4, 7, 1),
(5, 5, 6, 1),
(6, 6, 5, 1),
(7, 7, 4, 1),
(8, 8, 3, 1),
(9, 9, 2, 1),
(10, 10, 1, 1),
(11, 11, 0, 1),
(12, 12, 0, 1);

-- --------------------------------------------------------

--
-- Table structure for table `pots`
--

CREATE TABLE `pots` (
  `id` int(10) UNSIGNED NOT NULL,
  `tournament_id` int(10) UNSIGNED NOT NULL,
  `stage` enum('kualifikasi','semifinal','grandfinal') NOT NULL DEFAULT 'kualifikasi',
  `name` varchar(100) NOT NULL,
  `game_count` int(11) NOT NULL DEFAULT 5,
  `max_teams` int(11) NOT NULL DEFAULT 12,
  `sort_order` int(11) NOT NULL DEFAULT 1,
  `reference_image_1` varchar(255) DEFAULT NULL,
  `reference_image_2` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `pots`
--

INSERT INTO `pots` (`id`, `tournament_id`, `stage`, `name`, `game_count`, `max_teams`, `sort_order`, `reference_image_1`, `reference_image_2`, `created_at`, `updated_at`) VALUES
(12, 2, 'kualifikasi', 'GRUP A SEMIFINAL', 5, 12, 6, NULL, NULL, '2026-04-22 01:17:30', '2026-04-26 07:04:22'),
(15, 2, 'kualifikasi', 'GRUP B', 5, 12, 5, NULL, NULL, '2026-04-23 11:25:09', '2026-04-26 07:04:22'),
(16, 2, 'kualifikasi', 'GRUP C', 5, 12, 3, NULL, NULL, '2026-04-23 11:25:21', '2026-04-26 07:04:22'),
(17, 2, 'kualifikasi', 'GRUP D', 5, 12, 4, NULL, NULL, '2026-04-23 11:25:29', '2026-04-26 07:04:22'),
(19, 2, 'kualifikasi', 'GRUP B SEMIFINAL', 5, 12, 2, NULL, NULL, '2026-04-26 05:16:40', '2026-04-26 07:04:22'),
(23, 2, 'kualifikasi', 'GRUP A SEMIFINAL GAME 1', 5, 12, 1, NULL, NULL, '2026-04-26 05:40:13', '2026-04-26 07:04:22'),
(25, 4, 'kualifikasi', 'FINAL GAME 1', 5, 12, 1, NULL, NULL, '2026-04-26 07:10:56', '2026-07-04 17:15:30'),
(27, 5, 'kualifikasi', 'POT 1 MATCH 2', 5, 12, 1, NULL, NULL, '2026-05-24 10:33:24', '2026-05-26 19:37:22'),
(28, 5, 'kualifikasi', 'POT 2', 5, 12, 2, NULL, NULL, '2026-05-24 11:59:44', '2026-05-26 19:37:22'),
(29, 5, 'kualifikasi', 'POT 3', 5, 12, 3, NULL, NULL, '2026-05-24 12:22:39', '2026-05-26 19:37:22'),
(30, 5, 'kualifikasi', 'POT 4', 5, 12, 4, 'uploads/pot-references/pot_30_reference_image_1_1779604037_61cf2770.jpeg', NULL, '2026-05-24 12:39:09', '2026-05-26 19:37:22'),
(31, 5, 'kualifikasi', 'POT A Semi', 5, 12, 5, NULL, NULL, '2026-05-24 14:52:09', '2026-05-26 19:37:22'),
(32, 6, 'kualifikasi', 'POT 1', 5, 12, 1, NULL, NULL, '2026-07-04 13:48:57', '2026-07-04 13:48:57'),
(34, 4, 'kualifikasi', 'POT 2', 5, 12, 2, NULL, NULL, '2026-07-04 17:15:30', '2026-07-04 17:15:30'),
(35, 8, 'kualifikasi', 'POT 1', 5, 12, 1, NULL, NULL, '2026-08-20 09:01:40', '2026-08-30 16:08:24'),
(36, 8, 'kualifikasi', 'POT 2', 5, 12, 2, NULL, NULL, '2026-08-30 02:41:13', '2026-08-30 16:08:24'),
(38, 8, 'kualifikasi', 'POT 3', 5, 12, 3, NULL, NULL, '2026-08-30 12:28:00', '2026-08-30 16:08:24'),
(48, 12, 'kualifikasi', 'POT 1', 3, 12, 1, NULL, NULL, '2026-09-05 14:37:42', '2026-09-05 18:21:39'),
(49, 12, 'kualifikasi', 'POT 2', 3, 12, 2, NULL, NULL, '2026-09-05 18:18:08', '2026-09-05 18:21:39'),
(50, 12, 'kualifikasi', 'POT 3', 3, 12, 3, NULL, NULL, '2026-09-05 18:18:16', '2026-09-05 18:21:39'),
(51, 12, 'kualifikasi', 'POT 4', 3, 12, 4, NULL, NULL, '2026-09-05 18:18:29', '2026-09-05 18:21:39'),
(52, 12, 'kualifikasi', 'POT 5', 3, 12, 5, NULL, NULL, '2026-09-05 18:19:07', '2026-09-05 18:21:39'),
(53, 12, 'kualifikasi', 'POT 6', 3, 12, 6, NULL, NULL, '2026-09-05 18:19:13', '2026-09-05 18:21:39'),
(54, 12, 'semifinal', 'POT 1', 3, 12, 7, NULL, NULL, '2026-09-05 18:19:26', '2026-09-05 18:21:39');

-- --------------------------------------------------------

--
-- Table structure for table `scores`
--

CREATE TABLE `scores` (
  `id` int(10) UNSIGNED NOT NULL,
  `pot_id` int(10) UNSIGNED NOT NULL,
  `team_id` int(10) UNSIGNED NOT NULL,
  `game_no` int(11) NOT NULL,
  `rank_no` int(11) NOT NULL DEFAULT 0,
  `kill_point` int(11) NOT NULL DEFAULT 0,
  `placement_point` int(11) NOT NULL DEFAULT 0,
  `total_point` int(11) NOT NULL DEFAULT 0,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ;

--
-- Dumping data for table `scores`
--

INSERT INTO `scores` (`id`, `pot_id`, `team_id`, `game_no`, `rank_no`, `kill_point`, `placement_point`, `total_point`, `created_at`, `updated_at`) VALUES
(2615, 25, 77, 1, 4, 4, 7, 11, '2026-04-26 08:42:27', '2026-04-26 08:42:27'),
(2616, 25, 77, 2, 1, 21, 12, 33, '2026-04-26 08:42:27', '2026-04-26 08:42:27'),
(2617, 25, 77, 3, 6, 14, 5, 19, '2026-04-26 08:42:27', '2026-04-26 08:42:27'),
(2618, 25, 73, 1, 1, 16, 12, 28, '2026-04-26 08:42:27', '2026-04-26 08:42:27'),
(2619, 25, 73, 2, 3, 5, 8, 13, '2026-04-26 08:42:27', '2026-04-26 08:42:27'),
(2620, 25, 73, 3, 5, 1, 6, 7, '2026-04-26 08:42:27', '2026-04-26 08:42:27'),
(2621, 25, 92, 1, 8, 1, 3, 4, '2026-04-26 08:42:27', '2026-04-26 08:42:27'),
(2622, 25, 92, 2, 10, 6, 1, 7, '2026-04-26 08:42:27', '2026-04-26 08:42:27'),
(2623, 25, 92, 3, 1, 21, 12, 33, '2026-04-26 08:42:27', '2026-04-26 08:42:27'),
(2624, 25, 51, 1, 3, 15, 8, 23, '2026-04-26 08:42:27', '2026-04-26 08:42:27'),
(2625, 25, 51, 2, 8, 4, 3, 7, '2026-04-26 08:42:27', '2026-04-26 08:42:27'),
(2626, 25, 51, 3, 2, 5, 9, 14, '2026-04-26 08:42:27', '2026-04-26 08:42:27'),
(2627, 25, 56, 1, 2, 5, 9, 14, '2026-04-26 08:42:27', '2026-04-26 08:42:27'),
(2628, 25, 56, 2, 2, 4, 9, 13, '2026-04-26 08:42:27', '2026-04-26 08:42:27'),
(2629, 25, 56, 3, 8, 1, 3, 4, '2026-04-26 08:42:27', '2026-04-26 08:42:27'),
(2630, 25, 48, 1, 5, 3, 6, 9, '2026-04-26 08:42:27', '2026-04-26 08:42:27'),
(2631, 25, 48, 2, 11, 4, 0, 4, '2026-04-26 08:42:27', '2026-04-26 08:42:27'),
(2632, 25, 48, 3, 3, 10, 8, 18, '2026-04-26 08:42:27', '2026-04-26 08:42:27'),
(2633, 25, 59, 1, 12, 2, 0, 2, '2026-04-26 08:42:27', '2026-04-26 08:42:27'),
(2634, 25, 59, 2, 4, 8, 7, 15, '2026-04-26 08:42:27', '2026-04-26 08:42:27'),
(2635, 25, 59, 3, 7, 2, 4, 6, '2026-04-26 08:42:27', '2026-04-26 08:42:27'),
(2636, 25, 65, 1, 9, 1, 2, 3, '2026-04-26 08:42:27', '2026-04-26 08:42:27'),
(2637, 25, 65, 2, 5, 9, 6, 15, '2026-04-26 08:42:27', '2026-04-26 08:42:27'),
(2638, 25, 65, 3, 9, 1, 2, 3, '2026-04-26 08:42:27', '2026-04-26 08:42:27'),
(2639, 25, 82, 1, 11, 3, 0, 3, '2026-04-26 08:42:27', '2026-04-26 08:42:27'),
(2640, 25, 82, 2, 6, 1, 5, 6, '2026-04-26 08:42:27', '2026-04-26 08:42:27'),
(2641, 25, 82, 3, 4, 3, 7, 10, '2026-04-26 08:42:27', '2026-04-26 08:42:27'),
(2642, 25, 54, 1, 6, 0, 5, 5, '2026-04-26 08:42:27', '2026-04-26 08:42:27'),
(2643, 25, 54, 2, 7, 1, 4, 5, '2026-04-26 08:42:27', '2026-04-26 08:42:27'),
(2644, 25, 54, 3, 12, 2, 0, 2, '2026-04-26 08:42:27', '2026-04-26 08:42:27'),
(2645, 25, 72, 1, 7, 5, 4, 9, '2026-04-26 08:42:27', '2026-04-26 08:42:27'),
(2646, 25, 72, 2, 12, 0, 0, 0, '2026-04-26 08:42:27', '2026-04-26 08:42:27'),
(2647, 25, 72, 3, 10, 0, 1, 1, '2026-04-26 08:42:27', '2026-04-26 08:42:27'),
(2648, 25, 64, 1, 10, 0, 1, 1, '2026-04-26 08:42:27', '2026-04-26 08:42:27'),
(2649, 25, 64, 2, 9, 1, 2, 3, '2026-04-26 08:42:27', '2026-04-26 08:42:27'),
(2650, 25, 64, 3, 11, 1, 0, 1, '2026-04-26 08:42:27', '2026-04-26 08:42:27'),
(2807, 27, 110, 1, 1, 1, 12, 13, '2026-07-05 18:44:26', '2026-07-05 18:44:26'),
(2808, 27, 110, 2, 11, 1, 0, 1, '2026-07-05 18:44:26', '2026-07-05 18:44:26'),
(2809, 27, 114, 1, 2, 1, 9, 10, '2026-07-05 18:44:26', '2026-07-05 18:44:26'),
(2810, 27, 114, 2, 10, 1, 1, 2, '2026-07-05 18:44:26', '2026-07-05 18:44:26'),
(2811, 27, 118, 1, 3, 1, 8, 9, '2026-07-05 18:44:26', '2026-07-05 18:44:26'),
(2812, 27, 118, 2, 9, 1, 2, 3, '2026-07-05 18:44:26', '2026-07-05 18:44:26'),
(2813, 27, 122, 1, 4, 1, 7, 8, '2026-07-05 18:44:26', '2026-07-05 18:44:26'),
(2814, 27, 122, 2, 8, 1, 3, 4, '2026-07-05 18:44:26', '2026-07-05 18:44:26'),
(2815, 27, 126, 1, 5, 1, 6, 7, '2026-07-05 18:44:26', '2026-07-05 18:44:26'),
(2816, 27, 126, 2, 7, 1, 4, 5, '2026-07-05 18:44:26', '2026-07-05 18:44:26'),
(2817, 27, 130, 1, 6, 1, 5, 6, '2026-07-05 18:44:26', '2026-07-05 18:44:26'),
(2818, 27, 130, 2, 6, 1, 5, 6, '2026-07-05 18:44:26', '2026-07-05 18:44:26'),
(2819, 27, 134, 1, 7, 1, 4, 5, '2026-07-05 18:44:26', '2026-07-05 18:44:26'),
(2820, 27, 134, 2, 5, 1, 6, 7, '2026-07-05 18:44:26', '2026-07-05 18:44:26'),
(2821, 27, 138, 1, 8, 1, 3, 4, '2026-07-05 18:44:26', '2026-07-05 18:44:26'),
(2822, 27, 138, 2, 4, 1, 7, 8, '2026-07-05 18:44:26', '2026-07-05 18:44:26'),
(2823, 27, 146, 1, 9, 1, 2, 3, '2026-07-05 18:44:26', '2026-07-05 18:44:26'),
(2824, 27, 146, 2, 3, 1, 8, 9, '2026-07-05 18:44:26', '2026-07-05 18:44:26'),
(2825, 27, 150, 1, 10, 1, 1, 2, '2026-07-05 18:44:26', '2026-07-05 18:44:26'),
(2826, 27, 150, 2, 2, 1, 9, 10, '2026-07-05 18:44:26', '2026-07-05 18:44:26'),
(2827, 27, 153, 1, 11, 1, 0, 1, '2026-07-05 18:44:26', '2026-07-05 18:44:26'),
(2828, 27, 153, 2, 1, 1, 12, 13, '2026-07-05 18:44:26', '2026-07-05 18:44:26'),
(2859, 19, 50, 1, 1, 1, 12, 13, '2026-08-26 14:40:09', '2026-08-26 14:40:09'),
(2860, 19, 50, 2, 3, 3, 8, 11, '2026-08-26 14:40:09', '2026-08-26 14:40:09'),
(6058, 36, 176, 1, 1, 19, 12, 31, '2026-08-30 16:07:36', '2026-08-30 16:07:36'),
(6059, 36, 176, 2, 10, 6, 1, 7, '2026-08-30 16:07:36', '2026-08-30 16:07:36'),
(6060, 36, 176, 3, 5, 0, 6, 6, '2026-08-30 16:07:36', '2026-08-30 16:07:36'),
(6061, 36, 191, 1, 3, 21, 8, 29, '2026-08-30 16:07:36', '2026-08-30 16:07:36'),
(6062, 36, 191, 2, 11, 1, 0, 1, '2026-08-30 16:07:36', '2026-08-30 16:07:36'),
(6063, 36, 191, 3, 6, 13, 5, 18, '2026-08-30 16:07:36', '2026-08-30 16:07:36'),
(6064, 36, 185, 1, 8, 0, 3, 3, '2026-08-30 16:07:36', '2026-08-30 16:07:36'),
(6065, 36, 185, 2, 1, 13, 12, 25, '2026-08-30 16:07:36', '2026-08-30 16:07:36'),
(6066, 36, 185, 3, 8, 4, 3, 7, '2026-08-30 16:07:36', '2026-08-30 16:07:36'),
(6067, 36, 188, 1, 2, 7, 9, 16, '2026-08-30 16:07:36', '2026-08-30 16:07:36'),
(6068, 36, 188, 2, 6, 7, 5, 12, '2026-08-30 16:07:36', '2026-08-30 16:07:36'),
(6069, 36, 188, 3, 7, 10, 4, 14, '2026-08-30 16:07:36', '2026-08-30 16:07:36'),
(6070, 36, 177, 1, 4, 7, 7, 14, '2026-08-30 16:07:36', '2026-08-30 16:07:36'),
(6071, 36, 177, 2, 7, 4, 4, 8, '2026-08-30 16:07:36', '2026-08-30 16:07:36'),
(6072, 36, 177, 3, 11, 3, 0, 3, '2026-08-30 16:07:36', '2026-08-30 16:07:36'),
(6073, 36, 178, 1, 6, 1, 5, 6, '2026-08-30 16:07:36', '2026-08-30 16:07:36'),
(6074, 36, 178, 2, 2, 6, 9, 15, '2026-08-30 16:07:36', '2026-08-30 16:07:36'),
(6075, 36, 178, 3, 3, 1, 8, 9, '2026-08-30 16:07:36', '2026-08-30 16:07:36'),
(6076, 36, 190, 1, 5, 6, 6, 12, '2026-08-30 16:07:36', '2026-08-30 16:07:36'),
(6077, 36, 190, 2, 5, 2, 6, 8, '2026-08-30 16:07:36', '2026-08-30 16:07:36'),
(6078, 36, 190, 3, 9, 2, 2, 4, '2026-08-30 16:07:36', '2026-08-30 16:07:36'),
(6079, 36, 181, 2, 4, 8, 7, 15, '2026-08-30 16:07:36', '2026-08-30 16:07:36'),
(6080, 36, 181, 3, 1, 20, 12, 32, '2026-08-30 16:07:36', '2026-08-30 16:07:36'),
(6081, 36, 217, 1, 10, 0, 1, 1, '2026-08-30 16:07:36', '2026-08-30 16:07:36'),
(6082, 36, 217, 2, 3, 4, 8, 12, '2026-08-30 16:07:36', '2026-08-30 16:07:36'),
(6083, 36, 217, 3, 10, 3, 1, 4, '2026-08-30 16:07:36', '2026-08-30 16:07:36'),
(6084, 36, 179, 1, 7, 0, 4, 4, '2026-08-30 16:07:36', '2026-08-30 16:07:36'),
(6085, 36, 179, 2, 9, 4, 2, 6, '2026-08-30 16:07:36', '2026-08-30 16:07:36'),
(6086, 36, 179, 3, 4, 3, 7, 10, '2026-08-30 16:07:36', '2026-08-30 16:07:36'),
(6087, 36, 182, 1, 9, 0, 2, 2, '2026-08-30 16:07:36', '2026-08-30 16:07:36'),
(6088, 36, 182, 2, 8, 0, 3, 3, '2026-08-30 16:07:36', '2026-08-30 16:07:36'),
(6089, 36, 182, 3, 2, 17, 9, 26, '2026-08-30 16:07:36', '2026-08-30 16:07:36'),
(6442, 35, 180, 1, 1, 33, 12, 45, '2026-08-30 16:09:29', '2026-08-30 16:09:29'),
(6443, 35, 180, 2, 1, 22, 12, 34, '2026-08-30 16:09:29', '2026-08-30 16:09:29'),
(6444, 35, 180, 3, 1, 26, 12, 38, '2026-08-30 16:09:29', '2026-08-30 16:09:29'),
(6445, 35, 189, 1, 3, 4, 8, 12, '2026-08-30 16:09:29', '2026-08-30 16:09:29'),
(6446, 35, 189, 2, 9, 2, 2, 4, '2026-08-30 16:09:29', '2026-08-30 16:09:29'),
(6447, 35, 189, 3, 11, 0, 0, 0, '2026-08-30 16:09:29', '2026-08-30 16:09:29'),
(6448, 35, 192, 1, 2, 8, 9, 17, '2026-08-30 16:09:29', '2026-08-30 16:09:29'),
(6449, 35, 192, 2, 2, 2, 9, 11, '2026-08-30 16:09:29', '2026-08-30 16:09:29'),
(6450, 35, 192, 3, 6, 2, 5, 7, '2026-08-30 16:09:29', '2026-08-30 16:09:29'),
(6451, 35, 184, 1, 6, 1, 5, 6, '2026-08-30 16:09:29', '2026-08-30 16:09:29'),
(6452, 35, 184, 2, 3, 7, 8, 15, '2026-08-30 16:09:29', '2026-08-30 16:09:29'),
(6453, 35, 184, 3, 5, 4, 6, 10, '2026-08-30 16:09:29', '2026-08-30 16:09:29'),
(6454, 35, 196, 1, 7, 8, 4, 12, '2026-08-30 16:09:29', '2026-08-30 16:09:29'),
(6455, 35, 196, 2, 8, 4, 3, 7, '2026-08-30 16:09:29', '2026-08-30 16:09:29'),
(6456, 35, 196, 3, 4, 5, 7, 12, '2026-08-30 16:09:29', '2026-08-30 16:09:29'),
(6457, 35, 194, 1, 9, 6, 2, 8, '2026-08-30 16:09:29', '2026-08-30 16:09:29'),
(6458, 35, 194, 2, 4, 2, 7, 9, '2026-08-30 16:09:29', '2026-08-30 16:09:29'),
(6459, 35, 194, 3, 7, 3, 4, 7, '2026-08-30 16:09:29', '2026-08-30 16:09:29'),
(6460, 35, 186, 2, 6, 2, 5, 7, '2026-08-30 16:09:29', '2026-08-30 16:09:29'),
(6461, 35, 186, 3, 3, 7, 8, 15, '2026-08-30 16:09:29', '2026-08-30 16:09:29'),
(6462, 35, 183, 1, 8, 1, 3, 4, '2026-08-30 16:09:29', '2026-08-30 16:09:29'),
(6463, 35, 183, 2, 5, 8, 6, 14, '2026-08-30 16:09:29', '2026-08-30 16:09:29'),
(6464, 35, 183, 3, 8, 0, 3, 3, '2026-08-30 16:09:29', '2026-08-30 16:09:29'),
(6465, 35, 193, 1, 5, 6, 6, 12, '2026-08-30 16:09:29', '2026-08-30 16:09:29'),
(6466, 35, 193, 2, 7, 3, 4, 7, '2026-08-30 16:09:29', '2026-08-30 16:09:29'),
(6467, 35, 193, 3, 10, 0, 1, 1, '2026-08-30 16:09:29', '2026-08-30 16:09:29'),
(6468, 35, 218, 1, 4, 9, 7, 16, '2026-08-30 16:09:29', '2026-08-30 16:09:29'),
(6469, 35, 218, 2, 11, 0, 0, 0, '2026-08-30 16:09:29', '2026-08-30 16:09:29'),
(6470, 35, 218, 3, 2, 17, 9, 26, '2026-08-30 16:09:29', '2026-08-30 16:09:29'),
(6471, 35, 195, 1, 10, 0, 1, 1, '2026-08-30 16:09:29', '2026-08-30 16:09:29'),
(6472, 35, 195, 2, 10, 1, 1, 2, '2026-08-30 16:09:29', '2026-08-30 16:09:29'),
(6473, 35, 195, 3, 9, 1, 2, 3, '2026-08-30 16:09:29', '2026-08-30 16:09:29'),
(10047, 48, 479, 1, 9, 2, 2, 4, '2026-09-06 11:33:40', '2026-09-06 11:33:40'),
(10048, 48, 449, 1, 10, 0, 1, 1, '2026-09-06 11:33:40', '2026-09-06 11:33:40'),
(10049, 48, 448, 1, 8, 3, 3, 6, '2026-09-06 11:33:40', '2026-09-06 11:33:40');

-- --------------------------------------------------------

--
-- Table structure for table `settings`
--

CREATE TABLE `settings` (
  `id` int(11) NOT NULL,
  `class` varchar(255) NOT NULL,
  `key` varchar(255) NOT NULL,
  `value` text DEFAULT NULL,
  `type` varchar(31) NOT NULL DEFAULT 'string',
  `context` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `teams`
--

CREATE TABLE `teams` (
  `id` int(10) UNSIGNED NOT NULL,
  `tournament_id` int(10) UNSIGNED DEFAULT NULL,
  `pot_id` int(10) UNSIGNED DEFAULT NULL,
  `name` varchar(150) NOT NULL,
  `sort_order` int(11) NOT NULL DEFAULT 1,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `teams`
--

INSERT INTO `teams` (`id`, `tournament_id`, `pot_id`, `name`, `sort_order`, `created_at`, `updated_at`) VALUES
(46, 2, 23, 'Monkiller', 2, '2026-04-22 09:21:23', '2026-04-26 06:59:13'),
(47, 2, 15, 'sekeng', 2, '2026-04-22 09:21:23', '2026-04-23 13:51:25'),
(48, 4, 25, 'JOWO SURVIVOR', 3, '2026-04-22 09:21:23', '2026-04-26 07:13:43'),
(49, 2, 19, 'Jateng Pride', 4, '2026-04-22 09:21:23', '2026-04-26 06:50:52'),
(50, 2, 19, 'SNAKE PANTS', 5, '2026-04-22 09:21:23', '2026-04-26 06:47:40'),
(51, 4, 25, 'CASOS', 6, '2026-04-22 09:21:23', '2026-04-26 07:11:54'),
(52, 2, 19, 'MS TEAM', 7, '2026-04-22 09:21:23', '2026-04-26 06:46:42'),
(53, 2, 23, 'AYAM MBG', 8, '2026-04-22 09:21:23', '2026-04-26 06:40:22'),
(54, 4, 25, 'P3D', 9, '2026-04-22 09:21:23', '2026-04-26 07:14:06'),
(55, 2, NULL, 'THE BLACK STALION', 6, '2026-04-22 09:21:23', '2026-07-04 17:16:15'),
(56, 4, 25, 'grajaa imuy', 3, '2026-04-22 09:21:23', '2026-04-26 07:12:12'),
(57, 2, 15, 'san andreaks', 12, '2026-04-22 09:21:23', '2026-04-23 14:13:53'),
(58, 2, 19, 'preman kota', 13, '2026-04-22 09:21:23', '2026-04-26 06:48:59'),
(59, 4, 25, 'Saran Nama Team', 14, '2026-04-22 09:21:23', '2026-04-26 07:13:49'),
(60, 2, 19, 'Clan All', 15, '2026-04-22 09:21:23', '2026-04-26 06:52:18'),
(61, 2, NULL, 'AIM BOOD', 5, '2026-04-22 09:21:23', '2026-04-26 05:17:01'),
(62, 2, 15, 'Anti Wacana', 46, '2026-04-22 09:21:23', '2026-04-23 14:14:00'),
(63, 2, 16, 'KECRET BOTAM', 18, '2026-04-22 09:21:23', '2026-04-23 14:15:23'),
(64, 4, 25, 'CEMPLIK OSAKASIK', 19, '2026-04-22 09:21:23', '2026-04-26 07:12:01'),
(65, 4, 25, 'SEPELE', 20, '2026-04-22 09:21:23', '2026-04-26 07:14:15'),
(66, 2, 17, 'Team Tubruk', 21, '2026-04-22 09:21:23', '2026-04-23 14:16:21'),
(67, 2, NULL, 'KAPO', 4, '2026-04-22 09:21:23', '2026-04-26 05:17:01'),
(68, 2, 15, 'MADURA24JAM', 23, '2026-04-22 09:21:23', '2026-04-23 14:14:07'),
(69, 2, 12, 'BLACKERS', 5, '2026-04-22 09:21:23', '2026-04-26 05:17:01'),
(70, 2, 16, 'CMD • Boys', 25, '2026-04-22 09:21:23', '2026-04-23 14:15:34'),
(71, 2, 17, 'MR. MPRUY', 26, '2026-04-22 09:21:23', '2026-04-23 14:17:45'),
(72, 4, 25, 'GARED STYLE X', 27, '2026-04-22 09:21:23', '2026-04-26 07:14:25'),
(73, 4, 25, 'EVOS MAGELANG', 1, '2026-04-22 09:21:23', '2026-04-26 07:11:44'),
(74, 2, 15, 'MVL TEAM', 29, '2026-04-22 09:21:23', '2026-04-23 14:14:20'),
(75, 2, 16, 'gokiL', 30, '2026-04-22 09:21:23', '2026-04-23 14:15:43'),
(76, 2, 12, 'suka mbg', 1, '2026-04-22 09:21:23', '2026-04-26 05:17:01'),
(77, 4, 25, 'BUDI DKK', 32, '2026-04-22 09:21:23', '2026-04-26 07:11:24'),
(78, 2, 19, 'Mobuyyy', 33, '2026-04-22 09:21:23', '2026-04-26 06:54:40'),
(79, 2, 17, 'Cempene Paiman', 34, '2026-04-22 09:21:23', '2026-04-23 14:19:40'),
(80, 2, 12, 'TMPK GRUB', 2, '2026-04-22 09:21:23', '2026-04-26 05:17:01'),
(81, 2, 15, 'kakacung', 36, '2026-04-22 09:21:23', '2026-04-23 14:14:39'),
(82, 4, 25, 'Sing Santun', 37, '2026-04-22 09:21:23', '2026-04-26 07:13:55'),
(83, 2, 17, 'Norics Team', 38, '2026-04-22 09:21:23', '2026-04-23 14:19:44'),
(84, 2, 12, 'KEWEK', 3, '2026-04-22 09:21:23', '2026-04-26 05:17:01'),
(85, 2, 23, 'IPIN BERSATU', 40, '2026-04-22 09:21:23', '2026-04-26 06:39:27'),
(86, 2, 16, 'res area', 41, '2026-04-22 09:21:23', '2026-04-23 14:19:03'),
(87, 2, 15, 'NEXX4', 42, '2026-04-22 09:21:23', '2026-04-23 14:20:02'),
(88, 2, 16, 'XEVENTRUZ¹', 43, '2026-04-22 09:21:23', '2026-04-23 14:19:11'),
(89, 2, 17, 'BOCIL KEMATIAN', 44, '2026-04-22 09:21:23', '2026-04-23 14:20:06'),
(90, 2, 16, 'PNDG KROCO', 45, '2026-04-22 09:21:23', '2026-04-23 14:19:19'),
(91, 2, 12, 'Mister X', 4, '2026-04-22 09:21:24', '2026-04-26 05:17:01'),
(92, 4, 25, 'MBG TEAM', 47, '2026-04-22 09:21:24', '2026-04-26 07:11:36'),
(93, 2, 23, 'Newcaste Melon', 6, '2026-04-22 09:21:24', '2026-04-26 07:03:09'),
(97, 2, NULL, 'MS', 8, '2026-04-26 05:29:17', '2026-04-26 06:32:26'),
(98, 2, NULL, 'EVo', 5, '2026-04-26 05:40:31', '2026-04-26 06:55:33'),
(99, 2, NULL, 'sepe', 6, '2026-04-26 06:45:04', '2026-04-26 06:55:41'),
(100, 2, 23, 'mbg', 41, '2026-04-26 06:58:06', '2026-04-26 06:58:12'),
(101, 2, 23, 'mb', 42, '2026-04-26 06:58:08', '2026-04-26 06:58:08'),
(102, 2, 19, 'JOWO SURVIVOR', 34, '2026-04-26 07:16:30', '2026-04-26 07:16:30'),
(103, 2, 19, 'P3D', 35, '2026-04-26 07:16:30', '2026-04-26 07:16:30'),
(104, 2, 19, 'Saran Nama Team', 36, '2026-04-26 07:16:30', '2026-04-26 07:16:30'),
(105, 2, 19, 'SEPELE', 37, '2026-04-26 07:16:30', '2026-04-26 07:16:30'),
(106, 2, 19, 'GARED STYLE X', 38, '2026-04-26 07:16:30', '2026-04-26 07:16:30'),
(107, 2, 19, 'Sing Santun', 39, '2026-04-26 07:16:30', '2026-04-26 07:16:30'),
(110, 5, 27, 'Saran Nama Team', 6, '2026-05-24 11:42:29', '2026-05-24 11:57:21'),
(111, 5, 28, 'UNEKKENU', 7, '2026-05-24 11:42:29', '2026-05-24 12:00:06'),
(112, 5, 29, 'Reconnect', 8, '2026-05-24 11:42:29', '2026-05-24 12:35:39'),
(113, 5, 30, 'BULEJAWA', 9, '2026-05-24 11:42:29', '2026-05-24 12:39:54'),
(114, 5, 27, 'TIKI TIKI', 10, '2026-05-24 11:42:29', '2026-05-24 11:57:42'),
(115, 5, 28, 'Sekawan limo', 11, '2026-05-24 11:42:29', '2026-05-24 12:00:20'),
(116, 5, 29, 'EL YAPEX', 12, '2026-05-24 11:42:29', '2026-05-24 12:35:48'),
(117, 5, 30, 'RAGNAROK', 13, '2026-05-24 11:42:29', '2026-05-24 12:40:04'),
(118, 5, 27, 'Cookies', 14, '2026-05-24 11:42:29', '2026-05-24 11:57:49'),
(119, 5, 28, 'JOWO SURVIVOR', 15, '2026-05-24 11:42:29', '2026-05-24 12:00:42'),
(120, 5, 29, 'YOTEI SIX', 16, '2026-05-24 11:42:29', '2026-05-24 12:35:59'),
(121, 5, 30, 'ONTA BALAP', 17, '2026-05-24 11:42:29', '2026-05-24 12:40:10'),
(122, 5, 27, 'Carbon Monoxide', 18, '2026-05-24 11:42:29', '2026-05-24 11:57:57'),
(123, 5, 28, 'BIGETRON ASTRA', 19, '2026-05-24 11:42:29', '2026-05-24 12:00:51'),
(124, 5, 29, 'MBG TEAM', 20, '2026-05-24 11:42:29', '2026-05-24 12:36:08'),
(125, 5, 30, 'nomnomanbaix', 21, '2026-05-24 11:42:29', '2026-05-24 12:40:15'),
(126, 5, 27, 'CERIA', 22, '2026-05-24 11:42:29', '2026-05-24 11:58:04'),
(127, 5, 28, 'HAMBA EDI', 23, '2026-05-24 11:42:29', '2026-05-24 12:19:21'),
(128, 5, 29, 'Mopp junggot', 24, '2026-05-24 11:42:29', '2026-05-24 12:36:15'),
(129, 5, 30, 'EX-SITI', 25, '2026-05-24 11:42:29', '2026-05-24 12:40:21'),
(130, 5, 27, 'Super Gokil', 26, '2026-05-24 11:42:29', '2026-05-24 11:58:31'),
(131, 5, 28, 'NASPAD PADANG', 27, '2026-05-24 11:42:29', '2026-05-24 12:19:41'),
(132, 5, 29, 'nomnomantaex', 28, '2026-05-24 11:42:29', '2026-05-24 12:36:28'),
(133, 5, 30, 'UDI WONOSOBO', 29, '2026-05-24 11:42:29', '2026-05-24 12:40:38'),
(134, 5, 27, 'RSTARS 2ROCK', 30, '2026-05-24 11:42:29', '2026-05-24 11:58:44'),
(135, 5, 28, 'X NIGHT EMPIRE', 31, '2026-05-24 11:42:29', '2026-05-24 12:20:12'),
(136, 5, 29, 'nyakruk', 32, '2026-05-24 11:42:29', '2026-05-24 12:36:37'),
(137, 5, 30, 'JENDRAL AGENG', 33, '2026-05-24 11:42:29', '2026-05-24 12:40:50'),
(138, 5, 27, 'TEMPE BENGOK', 34, '2026-05-24 11:42:29', '2026-05-24 11:58:52'),
(139, 5, 28, 'DAPUR MBG', 35, '2026-05-24 11:42:29', '2026-05-24 12:20:43'),
(140, 5, 29, 'WOY GONDRONG', 36, '2026-05-24 11:42:29', '2026-05-24 12:37:42'),
(141, 5, 30, 'NEVERYOU', 37, '2026-05-24 11:42:29', '2026-05-24 12:41:02'),
(142, 5, 29, 'Jateng Pride', 38, '2026-05-24 11:42:29', '2026-05-24 13:26:57'),
(143, 5, 28, 'PRIA BERASAP', 39, '2026-05-24 11:42:29', '2026-05-24 12:20:53'),
(144, 5, 29, 'GARED STYLEX', 40, '2026-05-24 11:42:29', '2026-05-24 12:38:07'),
(145, 5, 30, 'BUDI DKK', 41, '2026-05-24 11:42:29', '2026-05-24 12:41:09'),
(146, 5, 27, 'PEMBANTAI KACUNK', 42, '2026-05-24 11:42:29', '2026-05-24 11:59:09'),
(147, 5, 28, 'Sak Karepe Dewe | SKD', 43, '2026-05-24 11:42:29', '2026-05-24 12:21:03'),
(148, 5, 29, 'VORTEC', 44, '2026-05-24 11:42:29', '2026-05-24 12:38:31'),
(149, 5, 30, 'Gedel Lums', 45, '2026-05-24 11:42:29', '2026-05-24 12:41:24'),
(150, 5, 27, 'Nomor 2 beban', 46, '2026-05-24 11:42:29', '2026-05-24 11:59:16'),
(151, 5, 28, 'Salyer', 47, '2026-05-24 11:42:29', '2026-05-24 12:21:12'),
(152, 5, 29, 'Newcastle', 48, '2026-05-24 11:42:29', '2026-05-24 12:38:50'),
(153, 5, 27, 'Mafia Bendrong Crew', 49, '2026-05-24 11:42:29', '2026-05-24 11:59:24'),
(154, 5, 30, 'MERAH PUTIH', 6, '2026-05-24 12:43:01', '2026-05-24 12:43:14'),
(157, 4, 34, 'Te', 1, '2026-07-04 17:15:41', '2026-07-04 17:15:52'),
(158, 4, 34, 'Team 2', 2, '2026-07-04 17:15:41', '2026-07-04 17:15:41'),
(159, 2, 12, 'bl', 8, '2026-07-04 17:16:23', '2026-07-04 17:16:32'),
(160, 2, 12, 'Team 9', 9, '2026-07-04 17:16:24', '2026-07-04 17:16:24'),
(161, 5, 31, 'Team 1', 1, '2026-07-04 17:31:13', '2026-07-04 17:31:13'),
(162, 5, 31, 'Team 2', 2, '2026-07-04 17:31:14', '2026-07-04 17:31:14'),
(163, 5, 31, 'Team 3', 3, '2026-07-04 17:33:24', '2026-07-04 17:33:24'),
(164, 5, 31, 'Team 4', 4, '2026-07-04 17:33:25', '2026-07-04 17:33:25'),
(176, 8, 36, 'GARED NGOPAG', 7, '2026-08-21 09:33:01', '2026-08-30 12:20:30'),
(177, 8, 36, 'KAMUDANG', 8, '2026-08-22 18:59:25', '2026-08-30 02:43:32'),
(178, 8, 36, 'VAPI CHEN', 9, '2026-08-22 19:01:37', '2026-08-30 02:44:14'),
(179, 8, 36, 'S4', 10, '2026-08-22 19:03:04', '2026-08-30 02:51:17'),
(180, 8, 35, 'ASAL MAIN', 11, '2026-08-22 19:04:12', '2026-08-29 21:22:07'),
(181, 8, 36, 'dreamlight back', 12, '2026-08-22 19:05:20', '2026-08-30 12:20:30'),
(182, 8, 36, 'BOOMERANG', 13, '2026-08-22 19:11:24', '2026-08-30 13:28:35'),
(183, 8, 35, 'PRIA AFK ITU LAGI', 14, '2026-08-22 19:25:16', '2026-08-30 11:23:19'),
(184, 8, 35, 'KAJI SOHER', 15, '2026-08-22 19:27:46', '2026-08-30 11:32:18'),
(185, 8, 36, 'LIGHTINING', 16, '2026-08-26 16:56:11', '2026-08-30 02:44:27'),
(186, 8, 35, 'FT CITRO', 17, '2026-08-26 16:57:26', '2026-08-30 02:36:58'),
(188, 8, 36, 'GOKIL', 19, '2026-08-26 16:59:33', '2026-08-30 11:22:35'),
(189, 8, 35, 'BOMBERRSZZ', 20, '2026-08-26 17:00:48', '2026-08-30 12:26:16'),
(190, 8, 36, 'GUD BOYS', 21, '2026-08-26 17:01:39', '2026-08-30 02:48:52'),
(191, 8, 36, 'SILENT STEPS', 22, '2026-08-26 17:02:35', '2026-08-30 02:44:39'),
(192, 8, 35, 'Yanto pecel', 23, '2026-08-28 18:22:16', '2026-08-30 02:40:06'),
(193, 8, 35, 'Hamba jenggot', 24, '2026-08-28 18:25:00', '2026-08-30 02:37:11'),
(194, 8, 35, 'MANTOLET', 25, '2026-08-28 18:27:02', '2026-08-30 02:36:35'),
(195, 8, 35, 'SPEIDAUS', 26, '2026-08-29 08:47:50', '2026-08-30 02:36:48'),
(196, 8, 35, 'nomnoman', 26, '2026-08-29 17:30:05', '2026-08-30 02:36:13'),
(217, 8, 36, 'nomnomanbaix', 10, '2026-08-30 02:50:31', '2026-08-30 02:50:45'),
(218, 8, 35, 'Baru terbit', 9, '2026-08-30 12:06:15', '2026-08-30 12:19:12'),
(219, 8, 38, 'dummy team pot 3', 7, '2026-08-30 12:27:11', '2026-08-30 12:28:10'),
(426, 12, 48, 'Sembarang', 7, '2026-09-05 13:36:41', '2026-09-06 01:48:24'),
(427, 12, 49, 'MANTOLET', 8, '2026-09-05 13:36:41', '2026-09-06 01:49:27'),
(428, 12, 50, 'MEPETZ', 9, '2026-09-05 13:36:41', '2026-09-06 01:49:06'),
(429, 12, 51, 'KRYPTON', 10, '2026-09-05 13:36:41', '2026-09-06 01:49:38'),
(430, 12, NULL, 'team santuy', 11, '2026-09-05 13:36:41', '2026-09-06 11:26:26'),
(431, 12, NULL, 'Dreamlight Magelang', 12, '2026-09-05 13:36:41', '2026-09-06 11:26:26'),
(432, 12, NULL, 'MAN 1 KOTA MAGELANG A', 13, '2026-09-05 13:36:41', '2026-09-06 11:26:26'),
(433, 12, NULL, 'marga mpruyy', 14, '2026-09-05 13:36:41', '2026-09-06 11:26:26'),
(434, 12, 48, '#NEWERAA', 15, '2026-09-05 13:36:41', '2026-09-06 01:50:08'),
(435, 12, NULL, 'Yess e-sport', 16, '2026-09-05 13:36:41', '2026-09-06 11:26:26'),
(436, 12, NULL, 'SMAELS', 17, '2026-09-05 13:36:41', '2026-09-06 11:26:26'),
(437, 12, NULL, 'Nocheeterna', 18, '2026-09-05 13:36:41', '2026-09-06 11:26:26'),
(438, 12, NULL, 'PAULI TEAM', 19, '2026-09-05 13:36:41', '2026-09-06 11:26:26'),
(439, 12, 48, 'SARNO OSAK ASIK', 20, '2026-09-05 13:36:41', '2026-09-06 01:50:22'),
(440, 12, NULL, 'SQUAD KECAP', 21, '2026-09-05 13:36:41', '2026-09-06 11:26:26'),
(441, 12, NULL, 'LGC', 22, '2026-09-05 13:36:41', '2026-09-06 11:26:26'),
(442, 12, 48, 'GONE FF', 23, '2026-09-05 13:36:41', '2026-09-06 01:49:59'),
(443, 12, NULL, 'MAN 1 KOTA MAGELANG B', 24, '2026-09-05 13:36:41', '2026-09-06 11:26:26'),
(444, 12, NULL, 'Buly esport', 25, '2026-09-05 13:36:41', '2026-09-06 11:26:26'),
(445, 12, NULL, 'MENGKLEK', 26, '2026-09-05 13:36:41', '2026-09-06 11:26:26'),
(446, 12, NULL, 'Hilang Arah', 27, '2026-09-05 13:36:41', '2026-09-06 11:26:26'),
(447, 12, NULL, 'tukang jagal', 28, '2026-09-05 13:36:41', '2026-09-06 11:26:26'),
(448, 12, 48, 'PECEL LELE', 29, '2026-09-05 13:36:41', '2026-09-06 11:33:17'),
(449, 12, 48, 'BOTAKERAS', 30, '2026-09-05 13:36:41', '2026-09-06 11:13:57'),
(450, 12, NULL, 'SANTO PETRUS', 31, '2026-09-05 13:36:41', '2026-09-06 11:26:26'),
(451, 12, NULL, 'PSSJ TC', 32, '2026-09-05 13:36:41', '2026-09-06 11:26:26'),
(452, 12, NULL, 'YANTO Pecel', 33, '2026-09-05 13:36:41', '2026-09-06 11:26:26'),
(453, 12, NULL, 'MOEHA2YK', 34, '2026-09-05 13:36:41', '2026-09-06 11:26:26'),
(454, 12, NULL, 'DENJAKA', 35, '2026-09-05 13:36:41', '2026-09-06 11:26:26'),
(455, 12, NULL, 'Moonlight Mirage', 36, '2026-09-05 13:36:41', '2026-09-06 11:26:26'),
(456, 12, NULL, 'TULUSCUNG', 37, '2026-09-05 13:36:41', '2026-09-06 11:26:26'),
(457, 12, NULL, 'RKS 19', 38, '2026-09-05 13:36:41', '2026-09-06 11:26:26'),
(458, 12, NULL, 'TEAM CHAOS', 39, '2026-09-05 13:36:41', '2026-09-06 11:26:26'),
(459, 12, NULL, 'AIM PETOT', 40, '2026-09-05 13:36:41', '2026-09-06 11:26:26'),
(460, 12, NULL, 'mulesss', 41, '2026-09-05 13:36:41', '2026-09-06 11:26:26'),
(461, 12, NULL, 'Pesona Mas have fun', 42, '2026-09-05 13:36:41', '2026-09-06 11:26:26'),
(462, 12, NULL, 'DeathWhisper', 43, '2026-09-05 13:36:41', '2026-09-06 11:26:26'),
(463, 12, NULL, 'TB', 44, '2026-09-05 13:36:41', '2026-09-06 11:26:26'),
(464, 12, NULL, '4 BOCAH NEKAT', 45, '2026-09-05 13:36:41', '2026-09-06 11:26:26'),
(465, 12, NULL, 'TANJAKAN IBLIS', 46, '2026-09-05 13:36:41', '2026-09-06 11:26:26'),
(466, 12, NULL, 'AYAM PETOK', 47, '2026-09-05 13:36:41', '2026-09-06 11:26:26'),
(467, 12, NULL, '^JEMBAT^', 48, '2026-09-05 13:36:41', '2026-09-06 11:26:26'),
(468, 12, NULL, 'Revenge', 49, '2026-09-05 13:36:41', '2026-09-06 11:26:26'),
(469, 12, NULL, '1.DREAMLIGHT JR & 2.ASAL ASALAN', 50, '2026-09-05 13:36:41', '2026-09-06 11:26:26'),
(470, 12, NULL, 'BOCAHMW', 51, '2026-09-05 13:36:41', '2026-09-06 11:26:26'),
(471, 12, NULL, 'TIMNAS DIY', 52, '2026-09-05 13:36:41', '2026-09-06 11:26:26'),
(472, 12, NULL, 'ACADEMY DIY', 53, '2026-09-05 13:36:41', '2026-09-06 11:26:26'),
(473, 12, NULL, 'JMK 48!!', 54, '2026-09-05 13:36:41', '2026-09-06 11:26:26'),
(474, 12, NULL, 'BOCAH SLMN', 55, '2026-09-05 13:36:41', '2026-09-06 11:26:26'),
(475, 12, NULL, 'believent', 56, '2026-09-05 13:36:41', '2026-09-06 11:26:26'),
(476, 12, NULL, 'Wowo wiwi', 57, '2026-09-05 13:36:41', '2026-09-06 11:26:26'),
(477, 12, NULL, 'TAEX', 58, '2026-09-05 13:36:41', '2026-09-06 11:26:26'),
(478, 12, NULL, 'hamba jenggot', 59, '2026-09-05 13:36:41', '2026-09-06 11:26:26'),
(479, 12, 48, 'ego tim', 60, '2026-09-05 13:36:41', '2026-09-06 11:21:13'),
(480, 12, NULL, 'Iwak Tempe', 61, '2026-09-05 13:36:41', '2026-09-06 11:26:26'),
(481, 12, NULL, 'ATOZZ', 62, '2026-09-05 13:36:41', '2026-09-06 11:26:26'),
(482, 12, NULL, 'TOP AKHIR', 63, '2026-09-05 13:36:41', '2026-09-06 11:26:26'),
(483, 12, NULL, 'Doa ibu', 64, '2026-09-05 13:36:41', '2026-09-06 11:26:26'),
(484, 12, NULL, 'KORBAN NINJA', 65, '2026-09-05 13:36:41', '2026-09-06 11:26:26'),
(485, 12, NULL, 'SILENT STEPS', 66, '2026-09-05 13:36:41', '2026-09-06 11:26:26'),
(486, 12, NULL, 'BUDI DKK', 67, '2026-09-05 13:36:41', '2026-09-06 11:26:26'),
(487, 12, NULL, 'Sembarang', 59, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(488, 12, NULL, 'MANTOLET', 60, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(489, 12, NULL, 'MEPETZ', 61, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(490, 12, NULL, 'KRYPTON', 62, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(491, 12, NULL, '#NEWERAA', 63, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(492, 12, NULL, 'SARNO OSAK ASIK', 64, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(493, 12, NULL, 'GONE FF', 65, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(494, 12, NULL, 'BOTAKERAS', 66, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(495, 12, NULL, 'ego tim', 67, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(496, 12, 49, 'Team 9', 9, '2026-09-06 11:35:44', '2026-09-06 11:35:44'),
(497, 12, 49, 'Team 10', 10, '2026-09-06 11:35:44', '2026-09-06 11:35:44'),
(498, 12, 49, 'Team 11', 11, '2026-09-06 11:35:44', '2026-09-06 11:35:44');

-- --------------------------------------------------------

--
-- Table structure for table `team_members`
--

CREATE TABLE `team_members` (
  `id` int(10) UNSIGNED NOT NULL,
  `team_id` int(10) UNSIGNED NOT NULL,
  `player_name` varchar(150) NOT NULL,
  `player_role` varchar(100) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `team_members`
--

INSERT INTO `team_members` (`id`, `team_id`, `player_name`, `player_role`, `created_at`, `updated_at`) VALUES
(1090, 47, 'aymod sekeng', NULL, '2026-04-23 13:51:25', '2026-04-23 13:51:25'),
(1091, 47, 'Mon', NULL, '2026-04-23 13:51:25', '2026-04-23 13:51:25'),
(1092, 47, 'flyve’z', NULL, '2026-04-23 13:51:25', '2026-04-23 13:51:25'),
(1093, 47, 'je’reyzenn', NULL, '2026-04-23 13:51:25', '2026-04-23 13:51:25'),
(1094, 47, 'XIOㅤSmurFㅤ76', NULL, '2026-04-23 13:51:25', '2026-04-23 13:51:25'),
(1105, 61, 'MIENG29 BOOD', NULL, '2026-04-23 13:52:03', '2026-04-23 13:52:03'),
(1106, 61, 'DIYZ BOOD', NULL, '2026-04-23 13:52:03', '2026-04-23 13:52:03'),
(1107, 61, 'Zoro™.メ.BTN', NULL, '2026-04-23 13:52:03', '2026-04-23 13:52:03'),
(1108, 61, 'BRIZZ BOOD', NULL, '2026-04-23 13:52:03', '2026-04-23 13:52:03'),
(1109, 61, 'k3piN BOOD', NULL, '2026-04-23 13:52:03', '2026-04-23 13:52:03'),
(1121, 76, 'Doni Sulistyo', NULL, '2026-04-23 13:52:40', '2026-04-23 13:52:40'),
(1122, 76, 'ahmad faiz', NULL, '2026-04-23 13:52:40', '2026-04-23 13:52:40'),
(1123, 76, 'muhammad rangga syahputra', NULL, '2026-04-23 13:52:40', '2026-04-23 13:52:40'),
(1124, 76, 'Donny Setiawan', NULL, '2026-04-23 13:52:40', '2026-04-23 13:52:40'),
(1125, 76, 'Tidak ada', NULL, '2026-04-23 13:52:40', '2026-04-23 13:52:40'),
(1126, 76, '17don', NULL, '2026-04-23 13:52:40', '2026-04-23 13:52:40'),
(1127, 80, 'A31ㅤDㅤSINI', NULL, '2026-04-23 13:52:50', '2026-04-23 13:52:50'),
(1128, 80, 'Rdit\'skibidi', NULL, '2026-04-23 13:52:50', '2026-04-23 13:52:50'),
(1129, 80, 'firza.s.pel.', NULL, '2026-04-23 13:52:50', '2026-04-23 13:52:50'),
(1130, 80, 'RVAㅤDㅤSINI', NULL, '2026-04-23 13:52:50', '2026-04-23 13:52:50'),
(1131, 80, 'Dms D sini', NULL, '2026-04-23 13:52:50', '2026-04-23 13:52:50'),
(1132, 84, 'Igr1z', NULL, '2026-04-23 13:52:57', '2026-04-23 13:52:57'),
(1133, 84, 'Jo Yu-ri<3', NULL, '2026-04-23 13:52:57', '2026-04-23 13:52:57'),
(1134, 84, 'KewekTzy', NULL, '2026-04-23 13:52:57', '2026-04-23 13:52:57'),
(1135, 84, '★Nexus★', NULL, '2026-04-23 13:52:57', '2026-04-23 13:52:57'),
(1136, 84, 'Himawan', NULL, '2026-04-23 13:52:57', '2026-04-23 13:52:57'),
(1137, 91, 'Luka Hančić', NULL, '2026-04-23 13:53:47', '2026-04-23 13:53:47'),
(1138, 91, 'Iruhabusie', NULL, '2026-04-23 13:53:47', '2026-04-23 13:53:47'),
(1139, 91, 'Raditya Putra Pratama', NULL, '2026-04-23 13:53:47', '2026-04-23 13:53:47'),
(1140, 91, 'Rass Tier S', NULL, '2026-04-23 13:53:47', '2026-04-23 13:53:47'),
(1141, 91, 'Luka Hancic', NULL, '2026-04-23 13:53:47', '2026-04-23 13:53:47'),
(1148, 69, 'Minivel', NULL, '2026-04-23 13:54:03', '2026-04-23 13:54:03'),
(1149, 69, 'bàmzácmédlv', NULL, '2026-04-23 13:54:03', '2026-04-23 13:54:03'),
(1150, 69, 'seraaxcy', NULL, '2026-04-23 13:54:03', '2026-04-23 13:54:03'),
(1151, 69, 'JaXcKeizy', NULL, '2026-04-23 13:54:03', '2026-04-23 13:54:03'),
(1152, 69, 'Minivel(bayu)', NULL, '2026-04-23 13:54:03', '2026-04-23 13:54:03'),
(1161, 57, 'Jembrawokkk', NULL, '2026-04-23 14:13:53', '2026-04-23 14:13:53'),
(1162, 57, 'diqaa', NULL, '2026-04-23 14:13:53', '2026-04-23 14:13:53'),
(1163, 57, 'saos\'s', NULL, '2026-04-23 14:13:53', '2026-04-23 14:13:53'),
(1164, 57, '99.Rockeess', NULL, '2026-04-23 14:13:53', '2026-04-23 14:13:53'),
(1165, 57, 'BELUM ADA', NULL, '2026-04-23 14:13:53', '2026-04-23 14:13:53'),
(1166, 62, 'your\'e.okay?', NULL, '2026-04-23 14:14:00', '2026-04-23 14:14:00'),
(1167, 62, 'GHANIZZ STR', NULL, '2026-04-23 14:14:00', '2026-04-23 14:14:00'),
(1168, 62, '≠Satzy2k11', NULL, '2026-04-23 14:14:00', '2026-04-23 14:14:00'),
(1169, 62, 'sentralcg.id', NULL, '2026-04-23 14:14:00', '2026-04-23 14:14:00'),
(1170, 62, 'LEN D SINI??', NULL, '2026-04-23 14:14:00', '2026-04-23 14:14:00'),
(1171, 68, 'HC JEKK10!', NULL, '2026-04-23 14:14:07', '2026-04-23 14:14:07'),
(1172, 68, 'HA???ㅤㅤRAUF', NULL, '2026-04-23 14:14:07', '2026-04-23 14:14:07'),
(1173, 68, 'panzmalesMVP', NULL, '2026-04-23 14:14:07', '2026-04-23 14:14:07'),
(1174, 68, 'jupartyz', NULL, '2026-04-23 14:14:07', '2026-04-23 14:14:07'),
(1175, 74, 'AB.V1NZ!', NULL, '2026-04-23 14:14:20', '2026-04-23 14:14:20'),
(1176, 74, '-princeLarry', NULL, '2026-04-23 14:14:20', '2026-04-23 14:14:20'),
(1177, 74, 'SAMTEK+OLES', NULL, '2026-04-23 14:14:20', '2026-04-23 14:14:20'),
(1178, 74, 'atap dis', NULL, '2026-04-23 14:14:20', '2026-04-23 14:14:20'),
(1179, 74, 'Adonis Belva Nur Cahyono (MVL JESTER)', NULL, '2026-04-23 14:14:20', '2026-04-23 14:14:20'),
(1185, 81, 'Snoopy¡', NULL, '2026-04-23 14:14:39', '2026-04-23 14:14:39'),
(1186, 81, 'Manz Gacor?', NULL, '2026-04-23 14:14:39', '2026-04-23 14:14:39'),
(1187, 81, '_Mass_kall', NULL, '2026-04-23 14:14:39', '2026-04-23 14:14:39'),
(1188, 81, 'royy bott', NULL, '2026-04-23 14:14:39', '2026-04-23 14:14:39'),
(1189, 81, 'anomalies', NULL, '2026-04-23 14:14:39', '2026-04-23 14:14:39'),
(1215, 63, 'BRD THOOK', NULL, '2026-04-23 14:15:23', '2026-04-23 14:15:23'),
(1216, 63, 'silit_kenari', NULL, '2026-04-23 14:15:23', '2026-04-23 14:15:23'),
(1217, 63, 'toblut_134', NULL, '2026-04-23 14:15:23', '2026-04-23 14:15:23'),
(1218, 63, '♡MEY♡•', NULL, '2026-04-23 14:15:23', '2026-04-23 14:15:23'),
(1219, 63, '@aastgallvy`', NULL, '2026-04-23 14:15:23', '2026-04-23 14:15:23'),
(1220, 70, 'ⓋIPSK・PUTRA', NULL, '2026-04-23 14:15:34', '2026-04-23 14:15:34'),
(1221, 70, 'Yanz`PRIME', NULL, '2026-04-23 14:15:34', '2026-04-23 14:15:34'),
(1222, 70, '꧁@Adͥitͣyͫส࿐', NULL, '2026-04-23 14:15:34', '2026-04-23 14:15:34'),
(1223, 70, 'JAWAMOKEEL', NULL, '2026-04-23 14:15:34', '2026-04-23 14:15:34'),
(1224, 70, 'Danzz', NULL, '2026-04-23 14:15:34', '2026-04-23 14:15:34'),
(1225, 75, 'EVOS.Ekscuyy', NULL, '2026-04-23 14:15:43', '2026-04-23 14:15:43'),
(1226, 75, 'EVOS.Rambatt', NULL, '2026-04-23 14:15:43', '2026-04-23 14:15:43'),
(1227, 75, 'EVOS.Basryy', NULL, '2026-04-23 14:15:43', '2026-04-23 14:15:43'),
(1228, 75, 'EVOS.HPaaa', NULL, '2026-04-23 14:15:43', '2026-04-23 14:15:43'),
(1229, 75, 'EVOS.Apenggg', NULL, '2026-04-23 14:15:43', '2026-04-23 14:15:43'),
(1240, 55, 'VinZz|LG', NULL, '2026-04-23 14:16:00', '2026-04-23 14:16:00'),
(1241, 55, 'rulzzzz++‡', NULL, '2026-04-23 14:16:00', '2026-04-23 14:16:00'),
(1242, 55, '4everyoung°', NULL, '2026-04-23 14:16:00', '2026-04-23 14:16:00'),
(1243, 55, 'Dojun...', NULL, '2026-04-23 14:16:00', '2026-04-23 14:16:00'),
(1244, 55, 'LORD $|ΜΡΠΙ', NULL, '2026-04-23 14:16:00', '2026-04-23 14:16:00'),
(1245, 66, 'Penn X PgSoft', NULL, '2026-04-23 14:16:21', '2026-04-23 14:16:21'),
(1246, 66, '4ndxa-', NULL, '2026-04-23 14:16:21', '2026-04-23 14:16:21'),
(1247, 66, 'Aura Ozzy', NULL, '2026-04-23 14:16:21', '2026-04-23 14:16:21'),
(1248, 66, 'vinzyyy.', NULL, '2026-04-23 14:16:21', '2026-04-23 14:16:21'),
(1249, 66, 'tidak ada', NULL, '2026-04-23 14:16:21', '2026-04-23 14:16:21'),
(1271, 71, 'JMD.Bbek', NULL, '2026-04-23 14:17:45', '2026-04-23 14:17:45'),
(1272, 71, 'NB.Ghost', NULL, '2026-04-23 14:17:45', '2026-04-23 14:17:45'),
(1273, 71, 'demm\'', NULL, '2026-04-23 14:17:45', '2026-04-23 14:17:45'),
(1274, 71, 'GHATHFAN35', NULL, '2026-04-23 14:17:45', '2026-04-23 14:17:45'),
(1275, 71, 'Lynxx azza', NULL, '2026-04-23 14:17:45', '2026-04-23 14:17:45'),
(1276, 86, 'GHERALDY NINO GHELVIANO', NULL, '2026-04-23 14:19:03', '2026-04-23 14:19:03'),
(1277, 86, 'el azar rifa abdillah', NULL, '2026-04-23 14:19:03', '2026-04-23 14:19:03'),
(1278, 86, 'RADITYA FIKRI SULISTYAWAN', NULL, '2026-04-23 14:19:03', '2026-04-23 14:19:03'),
(1279, 86, 'supri', NULL, '2026-04-23 14:19:03', '2026-04-23 14:19:03'),
(1280, 86, 'PIONSSS', NULL, '2026-04-23 14:19:03', '2026-04-23 14:19:03'),
(1281, 86, 'this is nino', NULL, '2026-04-23 14:19:03', '2026-04-23 14:19:03'),
(1282, 88, 'Álz!ㅤㅤㅤㅤㅤ', NULL, '2026-04-23 14:19:11', '2026-04-23 14:19:11'),
(1283, 88, 'Barnaclesz!★', NULL, '2026-04-23 14:19:11', '2026-04-23 14:19:11'),
(1284, 88, 'Apocalypse९', NULL, '2026-04-23 14:19:11', '2026-04-23 14:19:11'),
(1285, 88, 'ŕźㅤxӳㅤźáá.', NULL, '2026-04-23 14:19:11', '2026-04-23 14:19:11'),
(1286, 88, 'tidak ada player cadangan', NULL, '2026-04-23 14:19:11', '2026-04-23 14:19:11'),
(1287, 90, '—C4LLMEED4N', NULL, '2026-04-23 14:19:19', '2026-04-23 14:19:19'),
(1288, 90, 'TEH ㅤㅤMUANI-S', NULL, '2026-04-23 14:19:19', '2026-04-23 14:19:19'),
(1289, 90, 'Zᴀᴀᴀ⚡', NULL, '2026-04-23 14:19:19', '2026-04-23 14:19:19'),
(1290, 90, 'RVㅤ•ㅤＲｅｚｏｎ様', NULL, '2026-04-23 14:19:19', '2026-04-23 14:19:19'),
(1301, 79, 'SEKETTER|88', NULL, '2026-04-23 14:19:40', '2026-04-23 14:19:40'),
(1302, 79, '$\'Ꮤhyㅤᴘᴀɴѕ\'$', NULL, '2026-04-23 14:19:40', '2026-04-23 14:19:40'),
(1303, 79, 'ONIC--Ryzenn', NULL, '2026-04-23 14:19:40', '2026-04-23 14:19:40'),
(1304, 79, '@Almaaaaa', NULL, '2026-04-23 14:19:40', '2026-04-23 14:19:40'),
(1305, 79, 'Duh、Pippp.', NULL, '2026-04-23 14:19:40', '2026-04-23 14:19:40'),
(1306, 83, 'PRESIDEN EXE', NULL, '2026-04-23 14:19:44', '2026-04-23 14:19:44'),
(1307, 83, 'TFOS・zαк`々', NULL, '2026-04-23 14:19:44', '2026-04-23 14:19:44'),
(1308, 83, 'PCC!!????', NULL, '2026-04-23 14:19:44', '2026-04-23 14:19:44'),
(1309, 83, 'AWANN NJIR', NULL, '2026-04-23 14:19:44', '2026-04-23 14:19:44'),
(1310, 83, 'Kenshuusah', NULL, '2026-04-23 14:19:44', '2026-04-23 14:19:44'),
(1311, 87, 'K1O Franz', NULL, '2026-04-23 14:20:02', '2026-04-23 14:20:02'),
(1312, 87, 'K1O Vineiei', NULL, '2026-04-23 14:20:02', '2026-04-23 14:20:02'),
(1313, 87, 'K1O Hanzz', NULL, '2026-04-23 14:20:02', '2026-04-23 14:20:02'),
(1314, 87, 'RVG YANZ', NULL, '2026-04-23 14:20:02', '2026-04-23 14:20:02'),
(1315, 87, 'Shavinsxsx', NULL, '2026-04-23 14:20:02', '2026-04-23 14:20:02'),
(1316, 89, 'aldeny', NULL, '2026-04-23 14:20:06', '2026-04-23 14:20:06'),
(1317, 89, 'nada', NULL, '2026-04-23 14:20:06', '2026-04-23 14:20:06'),
(1318, 89, 'jeppa ange', NULL, '2026-04-23 14:20:06', '2026-04-23 14:20:06'),
(1319, 89, 'evos syamm', NULL, '2026-04-23 14:20:06', '2026-04-23 14:20:06'),
(1320, 89, 'axecell', NULL, '2026-04-23 14:20:06', '2026-04-23 14:20:06'),
(1340, 67, 'Zeuss', NULL, '2026-04-26 02:33:37', '2026-04-26 02:33:37'),
(1341, 67, 'GRX Cuteboy', NULL, '2026-04-26 02:33:37', '2026-04-26 02:33:37'),
(1342, 67, 'Mel4ver', NULL, '2026-04-26 02:33:37', '2026-04-26 02:33:37'),
(1343, 67, 'KAMENFEDER', NULL, '2026-04-26 02:33:37', '2026-04-26 02:33:37'),
(1344, 67, '-callistaaa', NULL, '2026-04-26 02:33:37', '2026-04-26 02:33:37'),
(1345, 67, 'ZEUS', NULL, '2026-04-26 02:33:37', '2026-04-26 02:33:37'),
(1366, 85, 'Ndap+++', NULL, '2026-04-26 06:39:27', '2026-04-26 06:39:27'),
(1367, 85, 'ZaaaMadaa !!', NULL, '2026-04-26 06:39:27', '2026-04-26 06:39:27'),
(1368, 85, 'Radzpaker', NULL, '2026-04-26 06:39:27', '2026-04-26 06:39:27'),
(1369, 85, 'El.Venuzz', NULL, '2026-04-26 06:39:27', '2026-04-26 06:39:27'),
(1370, 85, 'Franxxzzzz', NULL, '2026-04-26 06:39:27', '2026-04-26 06:39:27'),
(1371, 85, 'Ndapp+++', NULL, '2026-04-26 06:39:27', '2026-04-26 06:39:27'),
(1372, 53, '友ALMOD', NULL, '2026-04-26 06:40:22', '2026-04-26 06:40:22'),
(1373, 53, '-ndénㅤnd¡nㅤ', NULL, '2026-04-26 06:40:22', '2026-04-26 06:40:22'),
(1374, 53, 'DIARAAAAA\'s', NULL, '2026-04-26 06:40:22', '2026-04-26 06:40:22'),
(1375, 53, 'Belum ada', NULL, '2026-04-26 06:40:22', '2026-04-26 06:40:22'),
(1391, 52, 'kakk?cpongin', NULL, '2026-04-26 06:46:42', '2026-04-26 06:46:42'),
(1392, 52, '1onlyone.', NULL, '2026-04-26 06:46:42', '2026-04-26 06:46:42'),
(1393, 52, 'STAR8 AHMAD', NULL, '2026-04-26 06:46:42', '2026-04-26 06:46:42'),
(1394, 52, '-ThrNepthys', NULL, '2026-04-26 06:46:42', '2026-04-26 06:46:42'),
(1400, 50, 'kimbotwt⁴', NULL, '2026-04-26 06:47:40', '2026-04-26 06:47:40'),
(1401, 50, 'FX.Razor\'', NULL, '2026-04-26 06:47:40', '2026-04-26 06:47:40'),
(1402, 50, 'MBR.SKYBIN', NULL, '2026-04-26 06:47:40', '2026-04-26 06:47:40'),
(1403, 50, 'BRU.Rapyz', NULL, '2026-04-26 06:47:40', '2026-04-26 06:47:40'),
(1404, 50, 'NOc78 toblut', NULL, '2026-04-26 06:47:40', '2026-04-26 06:47:40'),
(1415, 58, 'preman sg', NULL, '2026-04-26 06:48:59', '2026-04-26 06:48:59'),
(1416, 58, 'preman bkp', NULL, '2026-04-26 06:48:59', '2026-04-26 06:48:59'),
(1417, 58, 'preman ft', NULL, '2026-04-26 06:48:59', '2026-04-26 06:48:59'),
(1418, 58, 'no527fa73be9', NULL, '2026-04-26 06:48:59', '2026-04-26 06:48:59'),
(1419, 58, 'preman st', NULL, '2026-04-26 06:48:59', '2026-04-26 06:48:59'),
(1420, 49, 'DITHIGH', NULL, '2026-04-26 06:50:52', '2026-04-26 06:50:52'),
(1421, 49, 'SadlySukaMik', NULL, '2026-04-26 06:50:52', '2026-04-26 06:50:52'),
(1422, 49, 'ENDOXZ_2137', NULL, '2026-04-26 06:50:52', '2026-04-26 06:50:52'),
(1423, 49, 'N2D\' PETRUKน6', NULL, '2026-04-26 06:50:52', '2026-04-26 06:50:52'),
(1424, 49, 'Raafzz4u', NULL, '2026-04-26 06:50:52', '2026-04-26 06:50:52'),
(1425, 60, 'Allsttret!!', NULL, '2026-04-26 06:52:18', '2026-04-26 06:52:18'),
(1426, 60, 'Allstvan', NULL, '2026-04-26 06:52:18', '2026-04-26 06:52:18'),
(1427, 60, 'Allszen', NULL, '2026-04-26 06:52:18', '2026-04-26 06:52:18'),
(1428, 60, 'Allszee...', NULL, '2026-04-26 06:52:18', '2026-04-26 06:52:18'),
(1429, 60, 'TIDAK ADA PEMAIN CADANGAN.', NULL, '2026-04-26 06:52:18', '2026-04-26 06:52:18'),
(1430, 60, 'Novan', NULL, '2026-04-26 06:52:18', '2026-04-26 06:52:18'),
(1435, 78, 'LekkㅤSupri\'', NULL, '2026-04-26 06:54:40', '2026-04-26 06:54:40'),
(1436, 78, 'Thruffle.', NULL, '2026-04-26 06:54:40', '2026-04-26 06:54:40'),
(1437, 78, 'llael french', NULL, '2026-04-26 06:54:40', '2026-04-26 06:54:40'),
(1438, 78, 'Kaavyz', NULL, '2026-04-26 06:54:40', '2026-04-26 06:54:40'),
(1439, 78, 'nntav4', NULL, '2026-04-26 06:54:40', '2026-04-26 06:54:40'),
(1440, 46, 'BsK•CR7√™©®*', NULL, '2026-04-26 06:59:13', '2026-04-26 06:59:13'),
(1441, 46, 'RavennnnTzy', NULL, '2026-04-26 06:59:13', '2026-04-26 06:59:13'),
(1442, 46, 'NalaElitt㉨', NULL, '2026-04-26 06:59:13', '2026-04-26 06:59:13'),
(1443, 46, 'HendyElitt', NULL, '2026-04-26 06:59:13', '2026-04-26 06:59:13'),
(1444, 46, 'ManUrafBoy75', NULL, '2026-04-26 06:59:13', '2026-04-26 06:59:13'),
(1445, 93, '@vanilaarawr', NULL, '2026-04-26 07:03:09', '2026-04-26 07:03:09'),
(1446, 93, 'Ritz embege`', NULL, '2026-04-26 07:03:09', '2026-04-26 07:03:09'),
(1447, 93, 'Yth.Tejieh\'', NULL, '2026-04-26 07:03:09', '2026-04-26 07:03:09'),
(1448, 93, 'vara karamoy', NULL, '2026-04-26 07:03:09', '2026-04-26 07:03:09'),
(1449, 93, 'epos safa', NULL, '2026-04-26 07:03:09', '2026-04-26 07:03:09'),
(1450, 93, '@vanillaarawr', NULL, '2026-04-26 07:03:09', '2026-04-26 07:03:09'),
(1455, 77, 'LAꋊA', NULL, '2026-04-26 07:11:24', '2026-04-26 07:11:24'),
(1456, 77, 'SKN1SA.Grizz', NULL, '2026-04-26 07:11:24', '2026-04-26 07:11:24'),
(1457, 77, 'SKN1SA.W1zaN', NULL, '2026-04-26 07:11:24', '2026-04-26 07:11:24'),
(1458, 77, 'kael', NULL, '2026-04-26 07:11:24', '2026-04-26 07:11:24'),
(1459, 77, 'JogjaNathan', NULL, '2026-04-26 07:11:24', '2026-04-26 07:11:24'),
(1460, 92, 'chococupss', NULL, '2026-04-26 07:11:36', '2026-04-26 07:11:36'),
(1461, 92, 'AhliGiziMBG', NULL, '2026-04-26 07:11:36', '2026-04-26 07:11:36'),
(1462, 92, 'Yahahayann', NULL, '2026-04-26 07:11:36', '2026-04-26 07:11:36'),
(1463, 92, 'Santanaeiei', NULL, '2026-04-26 07:11:36', '2026-04-26 07:11:36'),
(1464, 73, 'atsalhigh!?', NULL, '2026-04-26 07:11:44', '2026-04-26 07:11:44'),
(1465, 73, 'Feit44NNeiei', NULL, '2026-04-26 07:11:44', '2026-04-26 07:11:44'),
(1466, 73, 'Bagindapzz', NULL, '2026-04-26 07:11:44', '2026-04-26 07:11:44'),
(1467, 73, 'nanuy’s', NULL, '2026-04-26 07:11:44', '2026-04-26 07:11:44'),
(1468, 73, 'amy karmis', NULL, '2026-04-26 07:11:44', '2026-04-26 07:11:44'),
(1469, 51, 'BTRxJO15Nyr', NULL, '2026-04-26 07:11:54', '2026-04-26 07:11:54'),
(1470, 51, 'KZ.Joshua', NULL, '2026-04-26 07:11:54', '2026-04-26 07:11:54'),
(1471, 51, 'heavenly.', NULL, '2026-04-26 07:11:54', '2026-04-26 07:11:54'),
(1472, 51, '2012960851 (y)', NULL, '2026-04-26 07:11:54', '2026-04-26 07:11:54'),
(1473, 51, '1666400670', NULL, '2026-04-26 07:11:54', '2026-04-26 07:11:54'),
(1474, 64, 'ZICOSTECUU', NULL, '2026-04-26 07:12:01', '2026-04-26 07:12:01'),
(1475, 64, 'Just Time', NULL, '2026-04-26 07:12:01', '2026-04-26 07:12:01'),
(1476, 64, 'Majin Buu', NULL, '2026-04-26 07:12:01', '2026-04-26 07:12:01'),
(1477, 64, 'KINGSS', NULL, '2026-04-26 07:12:01', '2026-04-26 07:12:01'),
(1478, 64, 'dit vinesty', NULL, '2026-04-26 07:12:01', '2026-04-26 07:12:01'),
(1479, 56, 'Senzra×', NULL, '2026-04-26 07:12:12', '2026-04-26 07:12:12'),
(1480, 56, 'navlftan2nd', NULL, '2026-04-26 07:12:12', '2026-04-26 07:12:12'),
(1481, 56, '151 PIU', NULL, '2026-04-26 07:12:12', '2026-04-26 07:12:12'),
(1482, 56, 'riifkii969!', NULL, '2026-04-26 07:12:12', '2026-04-26 07:12:12'),
(1483, 56, 'Yuud VGS', NULL, '2026-04-26 07:12:12', '2026-04-26 07:12:12'),
(1484, 48, 'DLxPIZZ', NULL, '2026-04-26 07:13:43', '2026-04-26 07:13:43'),
(1485, 48, 'DLxIkaLL', NULL, '2026-04-26 07:13:43', '2026-04-26 07:13:43'),
(1486, 48, 'DLxFoxyy', NULL, '2026-04-26 07:13:43', '2026-04-26 07:13:43'),
(1487, 48, 'DLx4ffndi27`', NULL, '2026-04-26 07:13:43', '2026-04-26 07:13:43'),
(1488, 59, 'PRO iHamm', NULL, '2026-04-26 07:13:49', '2026-04-26 07:13:49'),
(1489, 59, 'iham16', NULL, '2026-04-26 07:13:49', '2026-04-26 07:13:49'),
(1490, 59, 'L A T I F', NULL, '2026-04-26 07:13:49', '2026-04-26 07:13:49'),
(1491, 59, 'cunkpret21', NULL, '2026-04-26 07:13:49', '2026-04-26 07:13:49'),
(1492, 59, 'AllStar', NULL, '2026-04-26 07:13:49', '2026-04-26 07:13:49'),
(1493, 82, 'W', NULL, '2026-04-26 07:13:55', '2026-04-26 07:13:55'),
(1494, 82, 'CINDO!!', NULL, '2026-04-26 07:13:55', '2026-04-26 07:13:55'),
(1495, 82, 'putz the lucio', NULL, '2026-04-26 07:13:55', '2026-04-26 07:13:55'),
(1496, 82, 'raup konblut', NULL, '2026-04-26 07:13:55', '2026-04-26 07:13:55'),
(1497, 82, 'VGSxTheFlash', NULL, '2026-04-26 07:13:55', '2026-04-26 07:13:55'),
(1498, 54, 'RissXasu', NULL, '2026-04-26 07:14:06', '2026-04-26 07:14:06'),
(1499, 54, '[[DGX]] Sambo', NULL, '2026-04-26 07:14:06', '2026-04-26 07:14:06'),
(1500, 54, 'ilmuHytam!!!', NULL, '2026-04-26 07:14:06', '2026-04-26 07:14:06'),
(1501, 54, 'Porsche3', NULL, '2026-04-26 07:14:06', '2026-04-26 07:14:06'),
(1502, 54, 'Supreme', NULL, '2026-04-26 07:14:06', '2026-04-26 07:14:06'),
(1503, 65, 'HamzEinstein', NULL, '2026-04-26 07:14:15', '2026-04-26 07:14:15'),
(1504, 65, 'user51471125', NULL, '2026-04-26 07:14:15', '2026-04-26 07:14:15'),
(1505, 65, 'namzahahahaa', NULL, '2026-04-26 07:14:15', '2026-04-26 07:14:15'),
(1506, 65, 'welly hebat', NULL, '2026-04-26 07:14:15', '2026-04-26 07:14:15'),
(1507, 65, 'Octavian Aidil Nugraha - Williee', NULL, '2026-04-26 07:14:15', '2026-04-26 07:14:15'),
(1508, 72, 'julemylovely', NULL, '2026-04-26 07:14:25', '2026-04-26 07:14:25'),
(1509, 72, 'cyyraaaaaa.', NULL, '2026-04-26 07:14:25', '2026-04-26 07:14:25'),
(1510, 72, 'NOET.Xora', NULL, '2026-04-26 07:14:25', '2026-04-26 07:14:25'),
(1511, 72, 'gopudexpres', NULL, '2026-04-26 07:14:25', '2026-04-26 07:14:25'),
(1512, 72, 'GOGROK STYLE', NULL, '2026-04-26 07:14:25', '2026-04-26 07:14:25'),
(1723, 110, 'PRO iHamm', NULL, '2026-05-24 11:57:21', '2026-05-24 11:57:21'),
(1724, 110, 'Alzzcangcut', NULL, '2026-05-24 11:57:21', '2026-05-24 11:57:21'),
(1725, 110, 'iHam\'16', NULL, '2026-05-24 11:57:21', '2026-05-24 11:57:21'),
(1726, 110, 'LATIF', NULL, '2026-05-24 11:57:21', '2026-05-24 11:57:21'),
(1727, 114, 'kpd yth 4rta', NULL, '2026-05-24 11:57:42', '2026-05-24 11:57:42'),
(1728, 114, 'Almanz OLF', NULL, '2026-05-24 11:57:42', '2026-05-24 11:57:42'),
(1729, 114, 'Renok3recet\'', NULL, '2026-05-24 11:57:42', '2026-05-24 11:57:42'),
(1730, 114, 'VarXx', NULL, '2026-05-24 11:57:42', '2026-05-24 11:57:42'),
(1731, 114, 'Negr0Sigma', NULL, '2026-05-24 11:57:42', '2026-05-24 11:57:42'),
(1732, 118, '\"SukiLiar\"', NULL, '2026-05-24 11:57:49', '2026-05-24 11:57:49'),
(1733, 118, 'lyncia', NULL, '2026-05-24 11:57:49', '2026-05-24 11:57:49'),
(1734, 118, 'máchálatté??', NULL, '2026-05-24 11:57:49', '2026-05-24 11:57:49'),
(1735, 118, '??PRI?NCE??!', NULL, '2026-05-24 11:57:49', '2026-05-24 11:57:49'),
(1736, 122, 'REX?Void-', NULL, '2026-05-24 11:57:57', '2026-05-24 11:57:57'),
(1737, 122, 'CELIDHO???', NULL, '2026-05-24 11:57:57', '2026-05-24 11:57:57'),
(1738, 122, 'Khanz 1M?', NULL, '2026-05-24 11:57:57', '2026-05-24 11:57:57'),
(1739, 122, '?ONE LIGHT?', NULL, '2026-05-24 11:57:57', '2026-05-24 11:57:57'),
(1740, 126, 'BRU.4STREUSS', NULL, '2026-05-24 11:58:04', '2026-05-24 11:58:04'),
(1741, 126, 'emoyourfav', NULL, '2026-05-24 11:58:04', '2026-05-24 11:58:04'),
(1742, 126, 'THEON1C.SZA\'', NULL, '2026-05-24 11:58:04', '2026-05-24 11:58:04');
INSERT INTO `team_members` (`id`, `team_id`, `player_name`, `player_role`, `created_at`, `updated_at`) VALUES
(1743, 126, 'yareuuu', NULL, '2026-05-24 11:58:04', '2026-05-24 11:58:04'),
(1744, 126, 'qero120fps', NULL, '2026-05-24 11:58:04', '2026-05-24 11:58:04'),
(1745, 130, 'JGLemjeee', NULL, '2026-05-24 11:58:31', '2026-05-24 11:58:31'),
(1746, 130, 'JGLNouzen', NULL, '2026-05-24 11:58:31', '2026-05-24 11:58:31'),
(1747, 130, 'GEEF.iRoeebb', NULL, '2026-05-24 11:58:31', '2026-05-24 11:58:31'),
(1748, 130, 'Feit44NNeiei', NULL, '2026-05-24 11:58:31', '2026-05-24 11:58:31'),
(1749, 134, 'REDSVETRAA7', NULL, '2026-05-24 11:58:44', '2026-05-24 11:58:44'),
(1750, 134, 'STARS Linzy', NULL, '2026-05-24 11:58:44', '2026-05-24 11:58:44'),
(1751, 134, 'STARS Yupii', NULL, '2026-05-24 11:58:44', '2026-05-24 11:58:44'),
(1752, 134, 'TPxVtrick', NULL, '2026-05-24 11:58:44', '2026-05-24 11:58:44'),
(1753, 134, 'SANNZA GVS', NULL, '2026-05-24 11:58:44', '2026-05-24 11:58:44'),
(1754, 138, '??????Yao?', NULL, '2026-05-24 11:58:52', '2026-05-24 11:58:52'),
(1755, 138, 'F-R-N-D-z-z', NULL, '2026-05-24 11:58:52', '2026-05-24 11:58:52'),
(1756, 138, 'marloung12', NULL, '2026-05-24 11:58:52', '2026-05-24 11:58:52'),
(1757, 138, '256bianndraa', NULL, '2026-05-24 11:58:52', '2026-05-24 11:58:52'),
(1763, 146, '.YONZZZ.', NULL, '2026-05-24 11:59:09', '2026-05-24 11:59:09'),
(1764, 146, 'LUX?ZILL??', NULL, '2026-05-24 11:59:09', '2026-05-24 11:59:09'),
(1765, 146, '~soxrrwikz_~', NULL, '2026-05-24 11:59:09', '2026-05-24 11:59:09'),
(1766, 146, 'arda??yes?bb', NULL, '2026-05-24 11:59:09', '2026-05-24 11:59:09'),
(1767, 146, 'Ertwod.', NULL, '2026-05-24 11:59:09', '2026-05-24 11:59:09'),
(1768, 150, 'Huemhahahahahahaha', NULL, '2026-05-24 11:59:16', '2026-05-24 11:59:16'),
(1769, 150, 'Clamrinee', NULL, '2026-05-24 11:59:16', '2026-05-24 11:59:16'),
(1770, 150, 'idc\'715', NULL, '2026-05-24 11:59:16', '2026-05-24 11:59:16'),
(1771, 150, 'nabilfreynto', NULL, '2026-05-24 11:59:16', '2026-05-24 11:59:16'),
(1772, 150, 'dapaamostdie', NULL, '2026-05-24 11:59:16', '2026-05-24 11:59:16'),
(1773, 153, 'HendyElitt', NULL, '2026-05-24 11:59:24', '2026-05-24 11:59:24'),
(1774, 153, 'Ruzzr', NULL, '2026-05-24 11:59:24', '2026-05-24 11:59:24'),
(1775, 153, 'Vinolonely', NULL, '2026-05-24 11:59:24', '2026-05-24 11:59:24'),
(1776, 153, 'Ayame', NULL, '2026-05-24 11:59:24', '2026-05-24 11:59:24'),
(1777, 153, 'Aruzze', NULL, '2026-05-24 11:59:24', '2026-05-24 11:59:24'),
(1778, 111, 'hannnxs', NULL, '2026-05-24 12:00:06', '2026-05-24 12:00:06'),
(1779, 111, 'knuuu', NULL, '2026-05-24 12:00:06', '2026-05-24 12:00:06'),
(1780, 111, 'reys loser', NULL, '2026-05-24 12:00:06', '2026-05-24 12:00:06'),
(1781, 111, 'mingyanjamsut', NULL, '2026-05-24 12:00:06', '2026-05-24 12:00:06'),
(1782, 111, 'chillgod', NULL, '2026-05-24 12:00:06', '2026-05-24 12:00:06'),
(1783, 115, '-pan', NULL, '2026-05-24 12:00:20', '2026-05-24 12:00:20'),
(1784, 115, 'Donor_Kouta', NULL, '2026-05-24 12:00:20', '2026-05-24 12:00:20'),
(1785, 115, '~MAYA~1~', NULL, '2026-05-24 12:00:20', '2026-05-24 12:00:20'),
(1786, 115, 'KadalPapua', NULL, '2026-05-24 12:00:20', '2026-05-24 12:00:20'),
(1787, 119, '-Miloo19', NULL, '2026-05-24 12:00:42', '2026-05-24 12:00:42'),
(1788, 119, 'DLxPIZZ', NULL, '2026-05-24 12:00:42', '2026-05-24 12:00:42'),
(1789, 119, 'DLxFoxyy', NULL, '2026-05-24 12:00:42', '2026-05-24 12:00:42'),
(1790, 119, 'DLxIkaLL', NULL, '2026-05-24 12:00:42', '2026-05-24 12:00:42'),
(1791, 119, 'DLxCrown', NULL, '2026-05-24 12:00:42', '2026-05-24 12:00:42'),
(1792, 123, 'BTR.Zekkay', NULL, '2026-05-24 12:00:51', '2026-05-24 12:00:51'),
(1793, 123, 'Allstvan', NULL, '2026-05-24 12:00:51', '2026-05-24 12:00:51'),
(1794, 123, 'Allszee', NULL, '2026-05-24 12:00:51', '2026-05-24 12:00:51'),
(1795, 123, '-Obyybee', NULL, '2026-05-24 12:00:51', '2026-05-24 12:00:51'),
(1796, 123, 'gak adaa', NULL, '2026-05-24 12:00:51', '2026-05-24 12:00:51'),
(1797, 127, '-Rènnyuw', NULL, '2026-05-24 12:19:21', '2026-05-24 12:19:21'),
(1798, 127, '?ell??', NULL, '2026-05-24 12:19:21', '2026-05-24 12:19:21'),
(1799, 127, 'userr345677', NULL, '2026-05-24 12:19:21', '2026-05-24 12:19:21'),
(1800, 127, 'VESSEL', NULL, '2026-05-24 12:19:21', '2026-05-24 12:19:21'),
(1801, 127, 'yukirrr', NULL, '2026-05-24 12:19:21', '2026-05-24 12:19:21'),
(1802, 131, 'NANTAGANTENK', NULL, '2026-05-24 12:19:41', '2026-05-24 12:19:41'),
(1803, 131, 'JustNap\'', NULL, '2026-05-24 12:19:41', '2026-05-24 12:19:41'),
(1804, 131, 'kak? ciyummm', NULL, '2026-05-24 12:19:41', '2026-05-24 12:19:41'),
(1805, 131, 'kak? susu', NULL, '2026-05-24 12:19:41', '2026-05-24 12:19:41'),
(1806, 135, 'ATH X - NIGHT', NULL, '2026-05-24 12:20:12', '2026-05-24 12:20:12'),
(1807, 135, '¥udh?Ti2417A', NULL, '2026-05-24 12:20:12', '2026-05-24 12:20:12'),
(1808, 135, 'V7-TOGA', NULL, '2026-05-24 12:20:12', '2026-05-24 12:20:12'),
(1809, 135, 'WhoMadeDark', NULL, '2026-05-24 12:20:12', '2026-05-24 12:20:12'),
(1810, 135, 'NIGHT ELITE', NULL, '2026-05-24 12:20:12', '2026-05-24 12:20:12'),
(1811, 139, '?ALMOD', NULL, '2026-05-24 12:20:43', '2026-05-24 12:20:43'),
(1812, 139, '99.Rockeess', NULL, '2026-05-24 12:20:43', '2026-05-24 12:20:43'),
(1813, 139, 'Jembrawokkk', NULL, '2026-05-24 12:20:43', '2026-05-24 12:20:43'),
(1814, 139, '-ndén?nd¡n?', NULL, '2026-05-24 12:20:43', '2026-05-24 12:20:43'),
(1815, 139, 'AR.Lhang', NULL, '2026-05-24 12:20:43', '2026-05-24 12:20:43'),
(1816, 143, 'PB MALBORO', NULL, '2026-05-24 12:20:53', '2026-05-24 12:20:53'),
(1817, 143, 'PB APPEL76', NULL, '2026-05-24 12:20:53', '2026-05-24 12:20:53'),
(1818, 143, 'PB DIPLOMAT', NULL, '2026-05-24 12:20:53', '2026-05-24 12:20:53'),
(1819, 143, 'RriidOoo', NULL, '2026-05-24 12:20:53', '2026-05-24 12:20:53'),
(1820, 143, 'tidak memakai cadangan', NULL, '2026-05-24 12:20:53', '2026-05-24 12:20:53'),
(1821, 147, 'Kaizen', NULL, '2026-05-24 12:21:03', '2026-05-24 12:21:03'),
(1822, 147, 'allsukaturu', NULL, '2026-05-24 12:21:03', '2026-05-24 12:21:03'),
(1823, 147, 'Jookulbet', NULL, '2026-05-24 12:21:03', '2026-05-24 12:21:03'),
(1824, 147, 'sr kpt', NULL, '2026-05-24 12:21:03', '2026-05-24 12:21:03'),
(1825, 147, 'Sky / roonns', NULL, '2026-05-24 12:21:03', '2026-05-24 12:21:03'),
(1826, 151, 'Lahin', NULL, '2026-05-24 12:21:12', '2026-05-24 12:21:12'),
(1827, 151, 'Anjar', NULL, '2026-05-24 12:21:12', '2026-05-24 12:21:12'),
(1828, 151, 'Javas', NULL, '2026-05-24 12:21:12', '2026-05-24 12:21:12'),
(1829, 151, 'Kosong', NULL, '2026-05-24 12:21:12', '2026-05-24 12:21:12'),
(1830, 112, 'Marlboro?~', NULL, '2026-05-24 12:35:39', '2026-05-24 12:35:39'),
(1831, 112, 'i\'m?Rahmw', NULL, '2026-05-24 12:35:39', '2026-05-24 12:35:39'),
(1832, 112, 'nihhhsam', NULL, '2026-05-24 12:35:39', '2026-05-24 12:35:39'),
(1833, 112, 'Ganiasyaba', NULL, '2026-05-24 12:35:39', '2026-05-24 12:35:39'),
(1834, 112, 'supersholl', NULL, '2026-05-24 12:35:39', '2026-05-24 12:35:39'),
(1835, 116, 'IVS Aryatzy', NULL, '2026-05-24 12:35:48', '2026-05-24 12:35:48'),
(1836, 116, 'SUPER Nayeon', NULL, '2026-05-24 12:35:48', '2026-05-24 12:35:48'),
(1837, 116, '~c h a s p e r', NULL, '2026-05-24 12:35:48', '2026-05-24 12:35:48'),
(1838, 116, 'lz.Neverlus', NULL, '2026-05-24 12:35:48', '2026-05-24 12:35:48'),
(1839, 116, 'whiz del rey', NULL, '2026-05-24 12:35:48', '2026-05-24 12:35:48'),
(1840, 120, 'Dojun...', NULL, '2026-05-24 12:35:59', '2026-05-24 12:35:59'),
(1841, 120, 'VinZz|LG', NULL, '2026-05-24 12:35:59', '2026-05-24 12:35:59'),
(1842, 120, '4everyoung°', NULL, '2026-05-24 12:35:59', '2026-05-24 12:35:59'),
(1843, 120, 'IQ150', NULL, '2026-05-24 12:35:59', '2026-05-24 12:35:59'),
(1844, 120, 'rulzzzz++', NULL, '2026-05-24 12:35:59', '2026-05-24 12:35:59'),
(1845, 124, 'chococupss', NULL, '2026-05-24 12:36:08', '2026-05-24 12:36:08'),
(1846, 124, 'SRGxmukz', NULL, '2026-05-24 12:36:08', '2026-05-24 12:36:08'),
(1847, 124, 'Yahahayann', NULL, '2026-05-24 12:36:08', '2026-05-24 12:36:08'),
(1848, 124, 'santanaeiei', NULL, '2026-05-24 12:36:08', '2026-05-24 12:36:08'),
(1849, 124, '@senooke_', NULL, '2026-05-24 12:36:08', '2026-05-24 12:36:08'),
(1850, 128, 'kim junggot', NULL, '2026-05-24 12:36:15', '2026-05-24 12:36:15'),
(1851, 128, 'BRU.Eclipse', NULL, '2026-05-24 12:36:15', '2026-05-24 12:36:15'),
(1852, 128, 'BRU.Megadeth', NULL, '2026-05-24 12:36:15', '2026-05-24 12:36:15'),
(1853, 128, 'BRU.ZAIBUZAI', NULL, '2026-05-24 12:36:15', '2026-05-24 12:36:15'),
(1854, 128, 'Ryzo05', NULL, '2026-05-24 12:36:15', '2026-05-24 12:36:15'),
(1855, 132, 'A f 1', NULL, '2026-05-24 12:36:28', '2026-05-24 12:36:28'),
(1856, 132, 'ROSIDMEN.', NULL, '2026-05-24 12:36:28', '2026-05-24 12:36:28'),
(1857, 132, 'Razzorr.Ja', NULL, '2026-05-24 12:36:28', '2026-05-24 12:36:28'),
(1858, 132, '`Caesar®', NULL, '2026-05-24 12:36:28', '2026-05-24 12:36:28'),
(1859, 132, 'N2B?Danzzz', NULL, '2026-05-24 12:36:28', '2026-05-24 12:36:28'),
(1860, 136, 'STAYZStecu', NULL, '2026-05-24 12:36:37', '2026-05-24 12:36:37'),
(1861, 136, 'apocaalypse.', NULL, '2026-05-24 12:36:37', '2026-05-24 12:36:37'),
(1862, 136, 'zaa15years', NULL, '2026-05-24 12:36:37', '2026-05-24 12:36:37'),
(1863, 136, 'who', NULL, '2026-05-24 12:36:37', '2026-05-24 12:36:37'),
(1864, 136, 's?stecu?', NULL, '2026-05-24 12:36:37', '2026-05-24 12:36:37'),
(1865, 140, 'vnehsa', NULL, '2026-05-24 12:37:42', '2026-05-24 12:37:42'),
(1866, 140, 'liu mey', NULL, '2026-05-24 12:37:42', '2026-05-24 12:37:42'),
(1867, 140, 'viberly', NULL, '2026-05-24 12:37:42', '2026-05-24 12:37:42'),
(1868, 140, 'gabriela', NULL, '2026-05-24 12:37:42', '2026-05-24 12:37:42'),
(1869, 140, 'Atapat', NULL, '2026-05-24 12:37:42', '2026-05-24 12:37:42'),
(1870, 144, 'GOPUDEXPRES', NULL, '2026-05-24 12:38:07', '2026-05-24 12:38:07'),
(1871, 144, 'W', NULL, '2026-05-24 12:38:07', '2026-05-24 12:38:07'),
(1872, 144, 'cyraaaa', NULL, '2026-05-24 12:38:07', '2026-05-24 12:38:07'),
(1873, 144, 'DLxLEYWINExyz', NULL, '2026-05-24 12:38:07', '2026-05-24 12:38:07'),
(1874, 144, 'putz the lucio', NULL, '2026-05-24 12:38:07', '2026-05-24 12:38:07'),
(1875, 148, 'MohJakii', NULL, '2026-05-24 12:38:31', '2026-05-24 12:38:31'),
(1876, 148, 'GzlYhuNicy27', NULL, '2026-05-24 12:38:31', '2026-05-24 12:38:31'),
(1877, 148, 'CARHARTT.WIP', NULL, '2026-05-24 12:38:31', '2026-05-24 12:38:31'),
(1878, 148, 'vitodelouise', NULL, '2026-05-24 12:38:31', '2026-05-24 12:38:31'),
(1879, 148, 'VRTC.Fann21', NULL, '2026-05-24 12:38:31', '2026-05-24 12:38:31'),
(1880, 152, 'BABON88', NULL, '2026-05-24 12:38:50', '2026-05-24 12:38:50'),
(1881, 152, 'NEWCSTL.RITZ', NULL, '2026-05-24 12:38:50', '2026-05-24 12:38:50'),
(1882, 152, 'NEWCSTL.PRAM', NULL, '2026-05-24 12:38:50', '2026-05-24 12:38:50'),
(1883, 152, 'BerTøT~', NULL, '2026-05-24 12:38:50', '2026-05-24 12:38:50'),
(1884, 113, 'FTBULEJAWA', NULL, '2026-05-24 12:39:54', '2026-05-24 12:39:54'),
(1885, 113, 'MIENG29 BOOD', NULL, '2026-05-24 12:39:54', '2026-05-24 12:39:54'),
(1886, 113, 'zoro x BTN', NULL, '2026-05-24 12:39:54', '2026-05-24 12:39:54'),
(1887, 113, 'K3pin × brn', NULL, '2026-05-24 12:39:54', '2026-05-24 12:39:54'),
(1888, 113, 'DIYN BOOD', NULL, '2026-05-24 12:39:54', '2026-05-24 12:39:54'),
(1889, 117, 'Lord\'Oboy', NULL, '2026-05-24 12:40:04', '2026-05-24 12:40:04'),
(1890, 117, 'Fanzz44ever!', NULL, '2026-05-24 12:40:04', '2026-05-24 12:40:04'),
(1891, 117, 'm1e4yam77', NULL, '2026-05-24 12:40:04', '2026-05-24 12:40:04'),
(1892, 117, 'bndar inex', NULL, '2026-05-24 12:40:04', '2026-05-24 12:40:04'),
(1893, 117, 'hexymer 2mg', NULL, '2026-05-24 12:40:04', '2026-05-24 12:40:04'),
(1894, 121, 'WIZARDDD!', NULL, '2026-05-24 12:40:10', '2026-05-24 12:40:10'),
(1895, 121, 'PUKKIS.BOY', NULL, '2026-05-24 12:40:10', '2026-05-24 12:40:10'),
(1896, 121, '@senookee-', NULL, '2026-05-24 12:40:10', '2026-05-24 12:40:10'),
(1897, 121, 'nash!yna', NULL, '2026-05-24 12:40:10', '2026-05-24 12:40:10'),
(1898, 121, 'nabilfrynto_', NULL, '2026-05-24 12:40:10', '2026-05-24 12:40:10'),
(1899, 125, '_adok', NULL, '2026-05-24 12:40:15', '2026-05-24 12:40:15'),
(1900, 125, '?T??????_?', NULL, '2026-05-24 12:40:15', '2026-05-24 12:40:15'),
(1901, 125, '76?Miloow', NULL, '2026-05-24 12:40:15', '2026-05-24 12:40:15'),
(1902, 125, '???Xzzy', NULL, '2026-05-24 12:40:15', '2026-05-24 12:40:15'),
(1903, 125, 'cawettpink><', NULL, '2026-05-24 12:40:15', '2026-05-24 12:40:15'),
(1904, 129, 'USPETKLEPET', NULL, '2026-05-24 12:40:21', '2026-05-24 12:40:21'),
(1905, 129, 'SAMIWW15', NULL, '2026-05-24 12:40:21', '2026-05-24 12:40:21'),
(1906, 129, '--lyonelhpyzy', NULL, '2026-05-24 12:40:21', '2026-05-24 12:40:21'),
(1907, 129, 'h56', NULL, '2026-05-24 12:40:21', '2026-05-24 12:40:21'),
(1908, 129, 'dagingbakar', NULL, '2026-05-24 12:40:21', '2026-05-24 12:40:21'),
(1909, 133, 'Ardh|Noay', NULL, '2026-05-24 12:40:38', '2026-05-24 12:40:38'),
(1910, 133, 'Lempis Enak', NULL, '2026-05-24 12:40:38', '2026-05-24 12:40:38'),
(1911, 133, 'Gf.Nuts', NULL, '2026-05-24 12:40:38', '2026-05-24 12:40:38'),
(1912, 133, 'Cha YeonWoo', NULL, '2026-05-24 12:40:38', '2026-05-24 12:40:38'),
(1913, 133, 'Gf.Ilus', NULL, '2026-05-24 12:40:38', '2026-05-24 12:40:38'),
(1914, 137, 'HixeeGOD', NULL, '2026-05-24 12:40:50', '2026-05-24 12:40:50'),
(1915, 137, 'EkxeGOD', NULL, '2026-05-24 12:40:50', '2026-05-24 12:40:50'),
(1916, 137, 'Dpiii', NULL, '2026-05-24 12:40:50', '2026-05-24 12:40:50'),
(1917, 137, 'WANNTZY', NULL, '2026-05-24 12:40:50', '2026-05-24 12:40:50'),
(1918, 137, 'Ptraaaa', NULL, '2026-05-24 12:40:50', '2026-05-24 12:40:50'),
(1919, 141, 'itsbaraw id :9001431879', NULL, '2026-05-24 12:41:02', '2026-05-24 12:41:02'),
(1920, 141, 'jir?âdâ?róy id :9255428176', NULL, '2026-05-24 12:41:02', '2026-05-24 12:41:02'),
(1921, 141, 'damn daniel id:4046185711', NULL, '2026-05-24 12:41:02', '2026-05-24 12:41:02'),
(1922, 141, 'Alien `|NVY id:2127485831', NULL, '2026-05-24 12:41:02', '2026-05-24 12:41:02'),
(1923, 141, 'gaada', NULL, '2026-05-24 12:41:02', '2026-05-24 12:41:02'),
(1924, 145, 'BELVA', NULL, '2026-05-24 12:41:09', '2026-05-24 12:41:09'),
(1925, 145, 'wtf!!L?', NULL, '2026-05-24 12:41:09', '2026-05-24 12:41:09'),
(1926, 145, 'kael', NULL, '2026-05-24 12:41:09', '2026-05-24 12:41:09'),
(1927, 145, 'knp nyak?', NULL, '2026-05-24 12:41:09', '2026-05-24 12:41:09'),
(1928, 145, 'mrzaalw-', NULL, '2026-05-24 12:41:09', '2026-05-24 12:41:09'),
(1929, 149, 'i4MZAACK', NULL, '2026-05-24 12:41:24', '2026-05-24 12:41:24'),
(1930, 149, 'BRU.Rapzy', NULL, '2026-05-24 12:41:24', '2026-05-24 12:41:24'),
(1931, 149, 'MBR.SKYBIN', NULL, '2026-05-24 12:41:24', '2026-05-24 12:41:24'),
(1932, 149, 'FX.Razor', NULL, '2026-05-24 12:41:24', '2026-05-24 12:41:24'),
(1933, 149, '-BLLx11.JT!', NULL, '2026-05-24 12:41:24', '2026-05-24 12:41:24'),
(1939, 154, 'JRNxRizky', NULL, '2026-05-24 12:43:14', '2026-05-24 12:43:14'),
(1940, 154, 'rodibabi24', NULL, '2026-05-24 12:43:14', '2026-05-24 12:43:14'),
(1941, 154, 'ES.MATCHAAA', NULL, '2026-05-24 12:43:14', '2026-05-24 12:43:14'),
(1942, 154, 'MieJebewLv99', NULL, '2026-05-24 12:43:14', '2026-05-24 12:43:14'),
(1943, 154, 'zee4youuu!!', NULL, '2026-05-24 12:43:14', '2026-05-24 12:43:14'),
(1944, 142, 'DITHIGH', NULL, '2026-05-24 13:26:57', '2026-05-24 13:26:57'),
(1945, 142, 'SadlySukaMik', NULL, '2026-05-24 13:26:57', '2026-05-24 13:26:57'),
(1946, 142, 'Raafzz4u', NULL, '2026-05-24 13:26:57', '2026-05-24 13:26:57'),
(1947, 142, '~MANN~', NULL, '2026-05-24 13:26:57', '2026-05-24 13:26:57'),
(1948, 142, 'N2D\' PETRUK?6', NULL, '2026-05-24 13:26:57', '2026-05-24 13:26:57'),
(2053, 180, 'TENXI-EFEF', NULL, '2026-08-29 21:22:07', '2026-08-29 21:22:07'),
(2054, 180, '1DAYORDAY1?', NULL, '2026-08-29 21:22:07', '2026-08-29 21:22:07'),
(2055, 180, 'arvegoist', NULL, '2026-08-29 21:22:07', '2026-08-29 21:22:07'),
(2056, 180, 'Jean Greyy.', NULL, '2026-08-29 21:22:07', '2026-08-29 21:22:07'),
(2067, 196, 'iduL', NULL, '2026-08-30 02:36:13', '2026-08-30 02:36:13'),
(2068, 196, 'Clear Abi', NULL, '2026-08-30 02:36:13', '2026-08-30 02:36:13'),
(2069, 196, 'A F 1', NULL, '2026-08-30 02:36:13', '2026-08-30 02:36:13'),
(2070, 196, 'v7f', NULL, '2026-08-30 02:36:13', '2026-08-30 02:36:13'),
(2075, 194, 'シャンディ々', NULL, '2026-08-30 02:36:35', '2026-08-30 02:36:35'),
(2076, 194, 'Zeusss\'', NULL, '2026-08-30 02:36:35', '2026-08-30 02:36:35'),
(2077, 194, 'อีดเก็บเกี่', NULL, '2026-08-30 02:36:35', '2026-08-30 02:36:35'),
(2078, 194, 'luvv_naa>.<', NULL, '2026-08-30 02:36:35', '2026-08-30 02:36:35'),
(2079, 194, 'チนในฐ ᵇᵏᵖ', NULL, '2026-08-30 02:36:35', '2026-08-30 02:36:35'),
(2080, 194, 'RAJA°•B0KEP', NULL, '2026-08-30 02:36:35', '2026-08-30 02:36:35'),
(2081, 195, 'Zieel\'sㅤ969', NULL, '2026-08-30 02:36:48', '2026-08-30 02:36:48'),
(2082, 195, '丂卂爪ㄩ尺卂丨♠匚丂', NULL, '2026-08-30 02:36:48', '2026-08-30 02:36:48'),
(2083, 195, '15VENT! SE', NULL, '2026-08-30 02:36:48', '2026-08-30 02:36:48'),
(2084, 195, 'ㅤㅤpen\'njago', NULL, '2026-08-30 02:36:48', '2026-08-30 02:36:48'),
(2085, 195, 'ZARK«LWW+_+', NULL, '2026-08-30 02:36:48', '2026-08-30 02:36:48'),
(2086, 186, 'someone.s', NULL, '2026-08-30 02:36:58', '2026-08-30 02:36:58'),
(2087, 186, '17casper', NULL, '2026-08-30 02:36:58', '2026-08-30 02:36:58'),
(2088, 186, 'naa ayle', NULL, '2026-08-30 02:36:58', '2026-08-30 02:36:58'),
(2089, 186, 'anayyluvv', NULL, '2026-08-30 02:36:58', '2026-08-30 02:36:58'),
(2090, 186, 'faisal lolot', NULL, '2026-08-30 02:36:58', '2026-08-30 02:36:58'),
(2091, 193, 'BRU.Ryzo05', NULL, '2026-08-30 02:37:11', '2026-08-30 02:37:11'),
(2092, 193, 'ᏃᎬᏢᎻᎽᏒ亗', NULL, '2026-08-30 02:37:11', '2026-08-30 02:37:11'),
(2093, 193, 'kim junggot', NULL, '2026-08-30 02:37:11', '2026-08-30 02:37:11'),
(2094, 193, 'BRU.Megadeth', NULL, '2026-08-30 02:37:11', '2026-08-30 02:37:11'),
(2095, 193, 'fdw ⁴⅝kiler', NULL, '2026-08-30 02:37:11', '2026-08-30 02:37:11'),
(2096, 193, 'BRU.ZAIBUZAI', NULL, '2026-08-30 02:37:11', '2026-08-30 02:37:11'),
(2097, 192, '♡who\'sㅤFal?♡', NULL, '2026-08-30 02:40:06', '2026-08-30 02:40:06'),
(2098, 192, 'finn del rey', NULL, '2026-08-30 02:40:06', '2026-08-30 02:40:06'),
(2099, 192, 'USERNAMEZIZ', NULL, '2026-08-30 02:40:06', '2026-08-30 02:40:06'),
(2100, 192, 'CAPPUNG.', NULL, '2026-08-30 02:40:06', '2026-08-30 02:40:06'),
(2101, 177, 'ETER.cexra', NULL, '2026-08-30 02:43:32', '2026-08-30 02:43:32'),
(2102, 177, 'VLK.rfkyy999', NULL, '2026-08-30 02:43:32', '2026-08-30 02:43:32'),
(2103, 177, 'VLK.Arya7', NULL, '2026-08-30 02:43:32', '2026-08-30 02:43:32'),
(2104, 177, 'VLK.Endong65☆', NULL, '2026-08-30 02:43:32', '2026-08-30 02:43:32'),
(2105, 178, 'huruf arab', NULL, '2026-08-30 02:44:14', '2026-08-30 02:44:14'),
(2106, 178, 'hotarou', NULL, '2026-08-30 02:44:14', '2026-08-30 02:44:14'),
(2107, 178, 'chenmulin', NULL, '2026-08-30 02:44:14', '2026-08-30 02:44:14'),
(2108, 178, 'sylphiee', NULL, '2026-08-30 02:44:14', '2026-08-30 02:44:14'),
(2109, 185, 'k3tem', NULL, '2026-08-30 02:44:27', '2026-08-30 02:44:27'),
(2110, 185, '0ot7', NULL, '2026-08-30 02:44:27', '2026-08-30 02:44:27'),
(2111, 185, 'n02j3nk1e53z', NULL, '2026-08-30 02:44:27', '2026-08-30 02:44:27'),
(2112, 185, 'LGHT\'Arvn', NULL, '2026-08-30 02:44:27', '2026-08-30 02:44:27'),
(2113, 185, 'THE YOLLA', NULL, '2026-08-30 02:44:27', '2026-08-30 02:44:27'),
(2114, 191, 'RRQ VALKYRIE', NULL, '2026-08-30 02:44:39', '2026-08-30 02:44:39'),
(2115, 191, 'ไทย┇yunas亗', NULL, '2026-08-30 02:44:39', '2026-08-30 02:44:39'),
(2116, 191, 'PSSJ CAVELZ', NULL, '2026-08-30 02:44:39', '2026-08-30 02:44:39'),
(2117, 191, 'SCF THANNZZZZZ', NULL, '2026-08-30 02:44:39', '2026-08-30 02:44:39'),
(2118, 191, 'AWAMODEGOOD', NULL, '2026-08-30 02:44:39', '2026-08-30 02:44:39'),
(2127, 190, 'LAYLA•STORE', NULL, '2026-08-30 02:48:52', '2026-08-30 02:48:52'),
(2128, 190, 'CodotzWWE+', NULL, '2026-08-30 02:48:52', '2026-08-30 02:48:52'),
(2129, 190, 'JMK JRIL', NULL, '2026-08-30 02:48:52', '2026-08-30 02:48:52'),
(2130, 190, 'STP2K-GOGOWN', NULL, '2026-08-30 02:48:52', '2026-08-30 02:48:52'),
(2136, 217, '–Mazźvy6z★.', NULL, '2026-08-30 02:50:45', '2026-08-30 02:50:45'),
(2137, 217, '-18dittrzkys', NULL, '2026-08-30 02:50:45', '2026-08-30 02:50:45'),
(2138, 217, '\"777', NULL, '2026-08-30 02:50:45', '2026-08-30 02:50:45'),
(2139, 217, 'ㅤTʜᴇㅤɢᴏᴅ_★', NULL, '2026-08-30 02:50:45', '2026-08-30 02:50:45'),
(2140, 217, '-irsa', NULL, '2026-08-30 02:50:45', '2026-08-30 02:50:45'),
(2151, 179, 'SMAR.Assya', NULL, '2026-08-30 02:51:17', '2026-08-30 02:51:17'),
(2152, 179, 'S4', NULL, '2026-08-30 02:51:17', '2026-08-30 02:51:17');
INSERT INTO `team_members` (`id`, `team_id`, `player_name`, `player_role`, `created_at`, `updated_at`) VALUES
(2153, 179, 'S4 | WATEVR★', NULL, '2026-08-30 02:51:17', '2026-08-30 02:51:17'),
(2154, 179, 'S4 | WINTER', NULL, '2026-08-30 02:51:17', '2026-08-30 02:51:17'),
(2155, 179, 'MTSN1.YAREL\'', NULL, '2026-08-30 02:51:17', '2026-08-30 02:51:17'),
(2172, 188, 'GKL.Ekscuyy', NULL, '2026-08-30 11:22:35', '2026-08-30 11:22:35'),
(2173, 188, 'EVOS.Basryy', NULL, '2026-08-30 11:22:35', '2026-08-30 11:22:35'),
(2174, 188, 'EVOS.Apenggg', NULL, '2026-08-30 11:22:35', '2026-08-30 11:22:35'),
(2175, 188, 'EVOS.Taato', NULL, '2026-08-30 11:22:35', '2026-08-30 11:22:35'),
(2176, 188, 'AryaaXDhian', NULL, '2026-08-30 11:22:35', '2026-08-30 11:22:35'),
(2177, 183, 'doujingsu', NULL, '2026-08-30 11:23:19', '2026-08-30 11:23:19'),
(2178, 183, 'Re4Youu', NULL, '2026-08-30 11:23:19', '2026-08-30 11:23:19'),
(2179, 183, 'PSSJ.Nizztzy', NULL, '2026-08-30 11:23:19', '2026-08-30 11:23:19'),
(2180, 183, 'ego+ego=rata', NULL, '2026-08-30 11:23:19', '2026-08-30 11:23:19'),
(2181, 183, 'user728641!', NULL, '2026-08-30 11:23:19', '2026-08-30 11:23:19'),
(2194, 184, 'EKSA Bonzz', NULL, '2026-08-30 11:32:18', '2026-08-30 11:32:18'),
(2195, 184, 'XOXO.Zaky', NULL, '2026-08-30 11:32:18', '2026-08-30 11:32:18'),
(2196, 184, 'BgCut | Lgc', NULL, '2026-08-30 11:32:18', '2026-08-30 11:32:18'),
(2197, 184, 'TI00!! ¹8', NULL, '2026-08-30 11:32:18', '2026-08-30 11:32:18'),
(2198, 184, 'BOCILKNTR', NULL, '2026-08-30 11:32:18', '2026-08-30 11:32:18'),
(2199, 184, 'Xioo', NULL, '2026-08-30 11:32:18', '2026-08-30 11:32:18'),
(2204, 218, 'Pati jeky', NULL, '2026-08-30 12:19:12', '2026-08-30 12:19:12'),
(2205, 218, 'Floyd-5', NULL, '2026-08-30 12:19:12', '2026-08-30 12:19:12'),
(2206, 218, 'Pnjihayhuy', NULL, '2026-08-30 12:19:12', '2026-08-30 12:19:12'),
(2207, 218, 'Smk_rullzy', NULL, '2026-08-30 12:19:12', '2026-08-30 12:19:12'),
(2208, 176, 'SMKMxAlice', NULL, '2026-08-30 12:20:30', '2026-08-30 12:20:30'),
(2209, 176, 'SMKMxGOPUD', NULL, '2026-08-30 12:20:30', '2026-08-30 12:20:30'),
(2210, 176, 'SMKN1.Romeny', NULL, '2026-08-30 12:20:30', '2026-08-30 12:20:30'),
(2211, 176, 'tlph_inaab', NULL, '2026-08-30 12:20:30', '2026-08-30 12:20:30'),
(2212, 176, 'Marry Jane', NULL, '2026-08-30 12:20:30', '2026-08-30 12:20:30'),
(2213, 176, 'SMKMxCANIEE', NULL, '2026-08-30 12:20:30', '2026-08-30 12:20:30'),
(2214, 181, '1K4L`', NULL, '2026-08-30 12:20:30', '2026-08-30 12:20:30'),
(2215, 181, 'DLxPIZZ', NULL, '2026-08-30 12:20:30', '2026-08-30 12:20:30'),
(2216, 181, 'RKS DABULL', NULL, '2026-08-30 12:20:30', '2026-08-30 12:20:30'),
(2217, 181, 'ontypawlin', NULL, '2026-08-30 12:20:30', '2026-08-30 12:20:30'),
(2218, 181, 'nabilfrynto_', NULL, '2026-08-30 12:20:30', '2026-08-30 12:20:30'),
(2219, 189, 'CEO WAHYU', NULL, '2026-08-30 12:26:16', '2026-08-30 12:26:16'),
(2220, 189, 'Nk\"kayy', NULL, '2026-08-30 12:26:16', '2026-08-30 12:26:16'),
(2221, 189, '@noeerriz', NULL, '2026-08-30 12:26:16', '2026-08-30 12:26:16'),
(2222, 189, 'rizkybomber!', NULL, '2026-08-30 12:26:16', '2026-08-30 12:26:16'),
(2223, 189, 'DAAPP', NULL, '2026-08-30 12:26:16', '2026-08-30 12:26:16'),
(2224, 182, 'HendyElit', NULL, '2026-08-30 13:28:35', '2026-08-30 13:28:35'),
(2225, 182, 'BsK•CR7√™©®*', NULL, '2026-08-30 13:28:35', '2026-08-30 13:28:35'),
(2226, 182, 'Cha', NULL, '2026-08-30 13:28:35', '2026-08-30 13:28:35'),
(2227, 182, 'RavennnnTzy', NULL, '2026-08-30 13:28:35', '2026-08-30 13:28:35'),
(2228, 182, 'WD | Exxo[', NULL, '2026-08-30 13:28:35', '2026-08-30 13:28:35'),
(2914, 426, 'DLxTOMII', NULL, '2026-09-06 01:48:24', '2026-09-06 01:48:24'),
(2915, 426, 'DLxIkazz', NULL, '2026-09-06 01:48:24', '2026-09-06 01:48:24'),
(2916, 426, 'DLxAscanio05', NULL, '2026-09-06 01:48:24', '2026-09-06 01:48:24'),
(2917, 426, 'DLxAlphaa\'', NULL, '2026-09-06 01:48:24', '2026-09-06 01:48:24'),
(2918, 428, 'saint joshua', NULL, '2026-09-06 01:49:06', '2026-09-06 01:49:06'),
(2919, 428, 'NESCJoekiel', NULL, '2026-09-06 01:49:06', '2026-09-06 01:49:06'),
(2920, 428, 'secaba2027', NULL, '2026-09-06 01:49:06', '2026-09-06 01:49:06'),
(2921, 428, 'A7xPranata', NULL, '2026-09-06 01:49:06', '2026-09-06 01:49:06'),
(2922, 427, 'シャンディ々', NULL, '2026-09-06 01:49:27', '2026-09-06 01:49:27'),
(2923, 427, 'Zeusss’', NULL, '2026-09-06 01:49:27', '2026-09-06 01:49:27'),
(2924, 427, 'อีดเก็บเกี่', NULL, '2026-09-06 01:49:27', '2026-09-06 01:49:27'),
(2925, 427, 'luvv_naa>.<', NULL, '2026-09-06 01:49:27', '2026-09-06 01:49:27'),
(2926, 427, 'チนในฐ ᵇᵏᵖ', NULL, '2026-09-06 01:49:27', '2026-09-06 01:49:27'),
(2927, 429, 'KINGHP PIN', NULL, '2026-09-06 01:49:38', '2026-09-06 01:49:38'),
(2928, 429, 'omji`bayzy', NULL, '2026-09-06 01:49:38', '2026-09-06 01:49:38'),
(2929, 429, '~09?08?24~!', NULL, '2026-09-06 01:49:38', '2026-09-06 01:49:38'),
(2930, 442, 'pincee?doo', NULL, '2026-09-06 01:49:59', '2026-09-06 01:49:59'),
(2931, 442, 'JEXZGTG', NULL, '2026-09-06 01:49:59', '2026-09-06 01:49:59'),
(2932, 442, 'pit.Apid', NULL, '2026-09-06 01:49:59', '2026-09-06 01:49:59'),
(2933, 442, 'khaajahat', NULL, '2026-09-06 01:49:59', '2026-09-06 01:49:59'),
(2934, 442, 'wibu*turu', NULL, '2026-09-06 01:49:59', '2026-09-06 01:49:59'),
(2935, 434, 'bimmmmmmmmm#', NULL, '2026-09-06 01:50:08', '2026-09-06 01:50:08'),
(2936, 434, 'ucok marbol', NULL, '2026-09-06 01:50:08', '2026-09-06 01:50:08'),
(2937, 434, '#UCXNEWERA', NULL, '2026-09-06 01:50:08', '2026-09-06 01:50:08'),
(2938, 434, 'Willlllyyyy.', NULL, '2026-09-06 01:50:08', '2026-09-06 01:50:08'),
(2939, 439, 'user728641!?', NULL, '2026-09-06 01:50:22', '2026-09-06 01:50:22'),
(2940, 439, 'PSSJ.Nizztzy', NULL, '2026-09-06 01:50:22', '2026-09-06 01:50:22'),
(2941, 439, 'ego+ego=rata', NULL, '2026-09-06 01:50:22', '2026-09-06 01:50:22'),
(2942, 439, 'Re4Youu', NULL, '2026-09-06 01:50:22', '2026-09-06 01:50:22'),
(2943, 439, '???\'s`?a?a', NULL, '2026-09-06 01:50:22', '2026-09-06 01:50:22'),
(2944, 449, 'NDAPP++', NULL, '2026-09-06 11:13:57', '2026-09-06 11:13:57'),
(2945, 449, 'KoinzellRORR', NULL, '2026-09-06 11:13:57', '2026-09-06 11:13:57'),
(2946, 449, 'koh elvin', NULL, '2026-09-06 11:13:57', '2026-09-06 11:13:57'),
(2947, 449, 'La boyys', NULL, '2026-09-06 11:13:57', '2026-09-06 11:13:57'),
(2948, 449, '<(WHITE444', NULL, '2026-09-06 11:13:57', '2026-09-06 11:13:57'),
(2949, 479, 'CEO WAHYU', NULL, '2026-09-06 11:21:13', '2026-09-06 11:21:13'),
(2950, 479, '@noeerriz', NULL, '2026-09-06 11:21:13', '2026-09-06 11:21:13'),
(2951, 479, 'Nk\"kayy', NULL, '2026-09-06 11:21:13', '2026-09-06 11:21:13'),
(2952, 479, 'daapp', NULL, '2026-09-06 11:21:13', '2026-09-06 11:21:13'),
(2953, 487, 'DLxTOMII', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(2954, 487, 'DLxIkazz', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(2955, 487, 'DLxAscanio05', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(2956, 487, 'DLxAlphaa\'', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(2957, 488, 'Zeusss', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(2958, 488, 'luvv_naa>.<', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(2959, 489, 'saint joshua', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(2960, 489, 'NESCJoekiel', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(2961, 489, 'secaba2027', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(2962, 489, 'A7xPranata', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(2963, 490, 'KINGHP PIN', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(2964, 490, 'omji`bayzy', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(2965, 490, '~09?08?24~!', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(2966, 430, 'BsKCR7?*', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(2967, 430, 'Hendyelit', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(2968, 430, 'Cha', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(2969, 430, 'WD | Exxo[', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(2970, 431, 'arvegoist', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(2971, 431, 'DLxPIZZ', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(2972, 431, '1K4L`', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(2973, 431, 'Nightss..', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(2974, 432, 'EVOS.4DINN', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(2975, 432, 'MAN1.PRAJA', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(2976, 432, 'MAN1.AMIR', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(2977, 432, 'YupannAjaaa', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(2978, 433, 'RKS\'ndutzxy', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(2979, 433, 'RKSPaculHz', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(2980, 433, 'RKS\'D`Vann', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(2981, 433, 'RKS\'D`Rioo', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(2982, 433, 'SMKMUH3.RAPZ', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(2983, 491, 'bimmmmmmmmm#', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(2984, 491, 'ucok marbol', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(2985, 491, '#UCXNEWERA', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(2986, 491, 'Willlllyyyy.', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(2987, 435, 'Incofsloth.', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(2988, 435, 'Zack_-`???', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(2989, 435, '4S????????', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(2990, 435, 'Fnaftzhr', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(2991, 435, 'n?4?p', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(2992, 436, '@biele___', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(2993, 436, 'GXL XHANZZ', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(2994, 436, 'evosayamrrq', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(2995, 436, 'Rapzzz-777', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(2996, 437, 'stralokhyto', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(2997, 437, 'BERLIN? NOT', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(2998, 437, 'XINX?CLTR??', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(2999, 437, '-Kanin08 NT', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3000, 437, 'Vanzz. 444', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3001, 438, 'user5783345', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3002, 438, 'ST Alganax\'', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3003, 438, 'ell nugxz', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3004, 438, 'your\'MAJESTY', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3005, 438, 'crlsh!ee', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3006, 492, 'user728641!?', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3007, 492, 'PSSJ.Nizztzy', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3008, 492, 'ego+ego=rata', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3009, 492, 'Re4Youu', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3010, 492, '???\'s`?a?a', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3011, 440, '_zeyyx 314395309', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3012, 440, '??f?`?????? 2388267775', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3013, 440, 'wong?asor 1714456576', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3014, 440, 'AnOmaL ki 4858581278', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3015, 440, 'sylphiee. 3096585829', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3016, 441, 'Yuez | LGC', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3017, 441, 'bgchut | LGC', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3018, 441, 'KANIEL | LGC', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3019, 441, 'XOXO. Zaky', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3020, 493, 'pincee?doo', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3021, 493, 'JEXZGTG', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3022, 493, 'pit.Apid', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3023, 493, 'khaajahat', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3024, 493, 'wibu*turu', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3025, 443, 'moc', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3026, 443, 'AB.LESGO321?', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3027, 443, 'hpis karamoy', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3028, 443, 'Devilgodboy', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3029, 444, '?? ODSLAMNZ', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3030, 444, '?MURID|BULY', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3031, 444, 'keenanbot!!', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3032, 445, '#latep', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3033, 445, '#roko', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3034, 445, '#sulhu', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3035, 445, '#jono', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3036, 446, 'who\'s?ray?!! (valdis)', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3037, 446, '??!? (billy)', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3038, 446, 'cuokibozzs (genta)', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3039, 446, 'who\'s nel?!! (lionel)', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3040, 446, 'IQNYADIMANA (silo)', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3041, 447, 'draz', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3042, 447, 'BAHLILGNTG', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3043, 447, '~silviaszz', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3044, 447, '?????A????', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3049, 494, 'NDAPP++', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3050, 494, 'KoinzellRORR', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3051, 494, 'koh elvin', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3052, 494, 'La boyys', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3053, 494, '<(WHITE444', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3054, 450, 'clear abi', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3055, 450, 'udintodebon', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3056, 450, 'kenzt SMK', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3057, 450, 'V 7 F', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3058, 450, 'Adoys', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3059, 451, 'Mirza', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3060, 451, 'uny nijarjit', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3061, 451, 'ag dew', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3062, 451, 'me-unniv17', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3063, 451, 'uny joyboy', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3064, 452, '?who\'s?Fal??', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3065, 452, 'finn del rey', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3066, 452, 'CAPPUNG.', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3067, 452, 'USERNAMEZIZ', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3068, 453, 'MOEHA.JAPRAC', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3069, 453, 'MOEHA.Felix', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3070, 453, 'MOEHA.NATZ', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3071, 453, 'MOEHA.Ramzyy', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3072, 453, 'MOEHA.Xlan', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3073, 454, 'A F 1', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3074, 454, 'ID3\'Dayat-XD', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3075, 454, 'AKUKopassus', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3076, 454, '?T??????_?', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3077, 454, 'AMBATUKAM', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3078, 455, 'Raihan', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3079, 455, 'Davi', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3080, 455, 'Noxx', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3081, 455, 'Kyy', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3082, 456, '??HAMKIH', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3083, 456, '??MUFIZ', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3084, 456, '??ZARR', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3085, 456, '??ompreng', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3086, 456, '??THOMAS', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3087, 457, 'RKS.GIXZY', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3088, 457, 'OOMKALL |KJ', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3089, 457, 'RKS\'Ulfah???', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3090, 457, 'RKS`Torzy', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3091, 458, 'AB.V1NZ!', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3092, 458, 'itsbaraw', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3093, 458, '-prnceLarry', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3094, 458, 'Bel`Notweak', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3095, 458, 'Re4Youu', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3096, 459, 'BANGFAYAD..', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3097, 459, 'K1NGBINNN', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3098, 459, 'NESC Genyaxx', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3099, 459, 'Silvester', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3100, 460, 'Fly\'sE1E1', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3101, 460, 'Demugszz', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3102, 460, 'Aymod sekeng', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3103, 460, 'Rey\'zE1E1', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3104, 461, 'RzkyyXditzy', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3105, 461, '-princerps?', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3106, 461, 'kaFeeinLatte', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3107, 461, 'Aether?????', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3108, 461, '?????|noxa44', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3109, 462, 'JosveJepang', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3110, 462, 'Jeremy', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3111, 462, 'TheoVox JA', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3112, 462, 'Ni Made', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3113, 462, 'Tidak ada', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3114, 463, 'CINASAMTEX1', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3115, 463, 'YAO', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3116, 463, 'Muria K3BI', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3117, 463, 'Day stillhere', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3118, 463, 'ridouyuk', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3119, 464, 'Trolls.??', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3120, 464, 'km gpp ryhn?', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3121, 464, '??||?????s??', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3122, 464, 'Far6E4m7p6p', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3123, 465, 'SMKMxNeylaa', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3124, 465, 'MBR.RIDHO12', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3125, 465, 'SMKMxZARAA', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3126, 465, 'cupexxxxxyq', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3127, 466, 'SE.RUNZ7', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3128, 466, 'RCL.MirzZzXx', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3129, 466, 'nailongbrum\"', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3130, 466, '@dapahheree_', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3131, 466, 'PGL.W4NZ', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26');
INSERT INTO `team_members` (`id`, `team_id`, `player_name`, `player_role`, `created_at`, `updated_at`) VALUES
(3132, 467, '?IPSK?PUTRA', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3133, 467, 'Yanz`PRIME', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3134, 467, 'Aditya', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3135, 467, 'JAWAMOKEEL', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3136, 468, '-xitpredator', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3137, 468, '`ratih?', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3138, 468, 'Ayutthayazz', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3139, 468, 'AlokMewing1.', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3140, 469, '-Mul4Ever?', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3141, 469, 'OntyPawlinnn', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3142, 469, 'xmukzj', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3143, 469, '19Depz', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3144, 469, '-DitrollGhan', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3145, 470, 'Jobzz', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3146, 470, 'BMW.GODK1LS', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3147, 470, 'BMW. GENERAL', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3148, 470, 'Yuzeeprime', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3149, 470, 'Kokgitusih', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3150, 471, '555555+', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3151, 471, 'ahnafeiei', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3152, 471, 'syoo0', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3153, 471, 'JooNathan', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3154, 472, 'SMKN2 STRONG', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3155, 472, 'Raihnn.27', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3156, 472, 'RKSAbassZ', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3157, 472, 'BOCILPSSJ++', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3158, 472, 'Mbeng47', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3159, 473, 'WANZ ?EXILE', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3160, 473, 'salhikari', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3161, 473, 'iBoyy7', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3162, 473, 'rennf?vboy', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3163, 473, '16Axell !!', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3164, 474, 'AERO Acaa', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3165, 474, 'AERO Arcell', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3166, 474, 'PUTRARAAA!!', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3167, 474, 'SMAN5.NDO3XY', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3168, 474, 'random', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3169, 475, 'angkasaraya', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3170, 475, '1stGenkayy', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3171, 475, 'vooraltijd14', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3172, 475, 'PS.RAJOR', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3173, 475, 'Mozarellafml', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3174, 476, 'Pbm YOWAIMOK', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3175, 476, 'PJS ARS29', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3176, 476, 'ABCKLEPONN', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3177, 476, 'Llompat', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3178, 476, 'tidak ada', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3179, 477, '777\"', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3180, 477, '-irsa', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3181, 477, 'Maz?vy6z?.', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3182, 477, '-18ditrzkys', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3183, 478, 'kim junggot', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3184, 478, 'stargoattt', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3185, 478, 'BRU.Ryzo05', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3186, 478, 'BRU.ZAIBUZAI', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3187, 478, 'ZEPHYR??', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3188, 495, 'CEO WAHYU', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3189, 495, '@noeerriz', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3190, 495, 'Nk\"kayy', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3191, 495, 'daapp', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3192, 480, 'Zamx\' TR', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3193, 480, 'Ayam TR', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3194, 480, 'srh dh', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3195, 480, 'nisayang', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3196, 480, 'ego=mencret', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3197, 481, 'Artstoe', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3198, 481, 'kpalamigrain', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3199, 481, 'PSSJ.RaellX7', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3200, 481, 'Nexsos', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3201, 481, 'hii nva', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3202, 482, 'RKS\'HAMZZ!!', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3203, 482, 'TLPH.INAB', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3204, 482, 'G.VILLO', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3205, 482, 'RKS17.Fantzy', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3206, 482, 'RKS\'DABULL', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3207, 483, 'SMKN1.Viann', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3208, 483, 'SMKN2 L4NA!!', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3209, 483, 'UNY NILLO', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3210, 484, 'ZamxGXEN', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3211, 484, 'nabilfreynto_', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3212, 484, 'NAKGOFARxPT', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3213, 484, 'rhasyaungu', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3214, 484, 'JM Russellx^', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3215, 485, '????yunas?', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3216, 485, 'RRQ VALKYRIE', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3217, 485, 'PSSJ.Cavellz', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3218, 485, 'AWAMODEGOD', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3219, 485, 'SCF THANZZZ', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3220, 486, 'knp nyak??', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3221, 486, 'Rindou?', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3222, 486, 'RASuksuiii', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3223, 486, 'Jogjanathan', NULL, '2026-09-06 11:26:26', '2026-09-06 11:26:26'),
(3224, 448, 'cexraoioi', NULL, '2026-09-06 11:33:17', '2026-09-06 11:33:17'),
(3225, 448, 'VLK.Arya7', NULL, '2026-09-06 11:33:17', '2026-09-06 11:33:17'),
(3226, 448, 'VLK.rfkyy999', NULL, '2026-09-06 11:33:17', '2026-09-06 11:33:17'),
(3227, 448, 'VLK.J33K', NULL, '2026-09-06 11:33:17', '2026-09-06 11:33:17');

-- --------------------------------------------------------

--
-- Table structure for table `tournaments`
--

CREATE TABLE `tournaments` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(150) NOT NULL,
  `status` varchar(20) NOT NULL DEFAULT 'belum_mulai',
  `default_game_count` int(11) NOT NULL DEFAULT 5,
  `kill_points` int(11) NOT NULL DEFAULT 1,
  `max_teams_per_pot` int(11) NOT NULL DEFAULT 12,
  `point_system` varchar(50) NOT NULL DEFAULT 'ffws',
  `custom_placement_points` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `tournaments`
--

INSERT INTO `tournaments` (`id`, `name`, `status`, `default_game_count`, `kill_points`, `max_teams_per_pot`, `point_system`, `custom_placement_points`, `created_at`, `updated_at`) VALUES
(2, 'FREE FIRE MOBILE TOURNAMENT SAKOPI BONPOLO', 'selesai', 5, 1, 12, 'ffws', NULL, '2026-04-19 10:21:14', '2026-08-29 12:39:04'),
(4, 'FINAL FF SAKOPI', 'selesai', 5, 1, 12, 'ffws', NULL, '2026-04-26 07:10:52', '2026-08-22 18:48:14'),
(5, 'FREE FIRE ARTOS', 'selesai', 5, 1, 12, 'ffws', NULL, '2026-05-24 02:26:09', '2026-08-22 18:48:08'),
(6, 'test', 'belum_mulai', 5, 1, 12, 'ffws', NULL, '2026-07-04 13:48:54', '2026-08-22 18:54:55'),
(8, 'SAKOPI MERDEKA CUP FF SEMIFINAL', 'selesai', 5, 1, 12, 'ffws', NULL, '2026-08-20 09:01:36', '2026-08-30 17:39:46'),
(12, 'ARTOS SHOPTEMBER ESPORT FREE FIRE CHAMPIONSHIP', 'belum_mulai', 3, 1, 12, 'ffws', '', '2026-09-05 13:24:15', '2026-09-05 13:24:15'),
(13, 'MASEHI FREE FIRE TOURNAMENT', 'belum_mulai', 3, 1, 12, 'ffws', '', '2026-11-03 09:13:54', '2026-11-03 09:13:54');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(10) UNSIGNED NOT NULL,
  `username` varchar(30) DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL,
  `status_message` varchar(255) DEFAULT NULL,
  `active` tinyint(1) NOT NULL DEFAULT 0,
  `last_active` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `status`, `status_message`, `active`, `last_active`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 'adminfey2', NULL, NULL, 1, '2026-11-07 11:57:55', '2026-04-19 09:41:33', '2026-04-19 09:41:34', NULL),
(2, 'adminfey3', NULL, NULL, 1, '2026-08-26 05:44:27', '2026-04-19 09:45:40', '2026-04-19 09:45:41', NULL),
(3, 'public_dummy', NULL, NULL, 1, '2026-04-20 06:52:16', '2026-04-19 17:11:16', '2026-04-19 17:11:16', NULL);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `auth_groups_users`
--
ALTER TABLE `auth_groups_users`
  ADD PRIMARY KEY (`id`),
  ADD KEY `auth_groups_users_user_id_foreign` (`user_id`);

--
-- Indexes for table `auth_identities`
--
ALTER TABLE `auth_identities`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `type_secret` (`type`,`secret`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `auth_logins`
--
ALTER TABLE `auth_logins`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_type_identifier` (`id_type`,`identifier`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `auth_permissions_users`
--
ALTER TABLE `auth_permissions_users`
  ADD PRIMARY KEY (`id`),
  ADD KEY `auth_permissions_users_user_id_foreign` (`user_id`);

--
-- Indexes for table `auth_remember_tokens`
--
ALTER TABLE `auth_remember_tokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `selector` (`selector`),
  ADD KEY `auth_remember_tokens_user_id_foreign` (`user_id`);

--
-- Indexes for table `auth_token_logins`
--
ALTER TABLE `auth_token_logins`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_type_identifier` (`id_type`,`identifier`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `players`
--
ALTER TABLE `players`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_players_user_id` (`user_id`);

--
-- Indexes for table `point_systems`
--
ALTER TABLE `point_systems`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_rank_active` (`rank_no`,`active`);

--
-- Indexes for table `pots`
--
ALTER TABLE `pots`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_pots_tournament_id` (`tournament_id`);

--
-- Indexes for table `scores`
--
ALTER TABLE `scores`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_scores_pot_team_game` (`pot_id`,`team_id`,`game_no`),
  ADD KEY `idx_scores_team_id` (`team_id`),
  ADD KEY `idx_scores_game_no` (`game_no`);

--
-- Indexes for table `settings`
--
ALTER TABLE `settings`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `teams`
--
ALTER TABLE `teams`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_teams_pot_id` (`pot_id`),
  ADD KEY `teams_tournament_id_index` (`tournament_id`);

--
-- Indexes for table `team_members`
--
ALTER TABLE `team_members`
  ADD PRIMARY KEY (`id`),
  ADD KEY `team_id` (`team_id`);

--
-- Indexes for table `tournaments`
--
ALTER TABLE `tournaments`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `audit_logs`
--
ALTER TABLE `audit_logs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `auth_groups_users`
--
ALTER TABLE `auth_groups_users`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `auth_identities`
--
ALTER TABLE `auth_identities`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `auth_logins`
--
ALTER TABLE `auth_logins`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=385;

--
-- AUTO_INCREMENT for table `auth_permissions_users`
--
ALTER TABLE `auth_permissions_users`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `auth_remember_tokens`
--
ALTER TABLE `auth_remember_tokens`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `auth_token_logins`
--
ALTER TABLE `auth_token_logins`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `point_systems`
--
ALTER TABLE `point_systems`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `pots`
--
ALTER TABLE `pots`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=55;

--
-- AUTO_INCREMENT for table `scores`
--
ALTER TABLE `scores`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `settings`
--
ALTER TABLE `settings`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `teams`
--
ALTER TABLE `teams`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=499;

--
-- AUTO_INCREMENT for table `team_members`
--
ALTER TABLE `team_members`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3228;

--
-- AUTO_INCREMENT for table `tournaments`
--
ALTER TABLE `tournaments`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `auth_groups_users`
--
ALTER TABLE `auth_groups_users`
  ADD CONSTRAINT `auth_groups_users_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `auth_identities`
--
ALTER TABLE `auth_identities`
  ADD CONSTRAINT `auth_identities_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `auth_permissions_users`
--
ALTER TABLE `auth_permissions_users`
  ADD CONSTRAINT `auth_permissions_users_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `auth_remember_tokens`
--
ALTER TABLE `auth_remember_tokens`
  ADD CONSTRAINT `auth_remember_tokens_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `players`
--
ALTER TABLE `players`
  ADD CONSTRAINT `fk_players_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `pots`
--
ALTER TABLE `pots`
  ADD CONSTRAINT `fk_pots_tournament_id` FOREIGN KEY (`tournament_id`) REFERENCES `tournaments` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `scores`
--
ALTER TABLE `scores`
  ADD CONSTRAINT `fk_scores_pot_id` FOREIGN KEY (`pot_id`) REFERENCES `pots` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_scores_team_id` FOREIGN KEY (`team_id`) REFERENCES `teams` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `teams`
--
ALTER TABLE `teams`
  ADD CONSTRAINT `fk_teams_pot_id` FOREIGN KEY (`pot_id`) REFERENCES `pots` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `teams_tournament_id_foreign` FOREIGN KEY (`tournament_id`) REFERENCES `tournaments` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `team_members`
--
ALTER TABLE `team_members`
  ADD CONSTRAINT `team_members_team_id_foreign` FOREIGN KEY (`team_id`) REFERENCES `teams` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
