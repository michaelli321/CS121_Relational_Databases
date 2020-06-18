INSERT INTO players VALUES (1, 'colon', 'colon@example.com', '2015-11-08 22:53:27', 'A');
INSERT INTO players VALUES (2, 'sands', 'sands@example.com', '2015-03-14 16:28:12', 'A');
INSERT INTO players VALUES (3, 'bowen', 'bowen@example.com', '2016-03-03 18:58:17', 'A');
INSERT INTO players VALUES (4, 'dent', 'dent@example.com', '2015-04-16 08:38:05', 'A');
INSERT INTO players VALUES (5, 'gaines', 'gaines@example.com', '2016-06-04 02:58:16', 'A');
INSERT INTO players VALUES (6, 'brookshire', 'brookshire@example.com', '2015-09-24 20:21:43', 'A');
INSERT INTO players VALUES (7, 'esquivel', 'esquivel@example.com', '2015-04-21 15:04:42', 'A');
INSERT INTO players VALUES (8, 'folse', 'folse@example.com', '2015-09-03 23:41:19', 'A');
INSERT INTO players VALUES (9, 'mccann', 'mccann@example.com', '2015-05-01 09:58:47', 'A');
INSERT INTO players VALUES (10, 'applegate', 'applegate@example.com', '2015-10-01 05:37:54', 'A');
INSERT INTO players VALUES (11, 'cardenas', 'cardenas@example.com', '2015-04-06 08:56:13', 'A');
INSERT INTO players VALUES (12, 'rausch', 'rausch@example.com', '2015-06-18 03:17:55', 'A');
INSERT INTO players VALUES (13, 'comeaux', 'comeaux@example.com', '2016-07-07 13:54:50', 'A');
INSERT INTO players VALUES (14, 'boatwright', 'boatwright@example.com', '2015-01-14 08:29:54', 'A');
INSERT INTO players VALUES (15, 'peel', 'peel@example.com', '2015-07-31 07:52:59', 'A');
INSERT INTO players VALUES (16, 'blocker', 'blocker@example.com', '2015-12-11 02:59:03', 'A');
INSERT INTO players VALUES (17, 'spinks', 'spinks@example.com', '2016-01-25 15:29:29', 'A');
INSERT INTO players VALUES (18, 'driscoll', 'driscoll@example.com', '2015-06-17 09:17:49', 'A');
INSERT INTO players VALUES (19, 'lim', 'lim@example.com', '2015-05-27 19:08:30', 'A');
INSERT INTO players VALUES (20, 'dockery', 'dockery@example.com', '2015-06-09 10:44:02', 'A');
INSERT INTO players VALUES (21, 'childs', 'childs@example.com', '2015-11-24 06:48:51', 'A');
INSERT INTO players VALUES (22, 'pepper', 'pepper@example.com', '2016-07-11 03:54:46', 'A');
INSERT INTO players VALUES (23, 'ivory', 'ivory@example.com', '2016-01-30 18:45:27', 'A');
INSERT INTO players VALUES (24, 'cavazos', 'cavazos@example.com', '2015-07-01 04:43:34', 'A');
INSERT INTO players VALUES (25, 'seitz', 'seitz@example.com', '2016-02-14 08:01:39', 'A');
INSERT INTO players VALUES (26, 'roussel', 'roussel@example.com', '2015-06-16 12:11:40', 'A');
INSERT INTO players VALUES (27, 'phipps', 'phipps@example.com', '2015-09-04 20:25:50', 'A');
INSERT INTO players VALUES (28, 'kinney', 'kinney@example.com', '2016-06-20 14:09:15', 'A');
INSERT INTO players VALUES (29, 'riggs', 'riggs@example.com', '2015-06-16 01:25:19', 'A');
INSERT INTO players VALUES (30, 'doran', 'doran@example.com', '2015-08-04 11:07:07', 'A');
INSERT INTO players VALUES (31, 'smith', 'smith@example.com', '2016-01-13 07:10:09', 'A');
INSERT INTO players VALUES (32, 'ted_codd', 'ted_codd@example.com', '2015-09-24 02:30:00', 'A');

INSERT INTO card_types VALUES (1, 'Single-table SELECT', 'Select some rows, whee.', 5, NULL);
INSERT INTO card_types VALUES (2, 'INSERT one row', 'Congratulations, you added a row to a table', 5.5, NULL);
INSERT INTO card_types VALUES (3, 'Single-table UPDATE', 'Update some rows, wooo.', 5.8, NULL);
INSERT INTO card_types VALUES (4, 'Single-table DELETE', 'Delete some rows, yay.', 5.9, NULL);
INSERT INTO card_types VALUES (5, 'Multi-table UPDATE', 'Update multiple tables at once', 8.4, NULL);
INSERT INTO card_types VALUES (6, 'Multi-table DELETE', 'Delete rows from multiple tables at once', 8.9, NULL);
INSERT INTO card_types VALUES (7, 'Improperly constrained UPDATE', 'Predicate isn\'t correct; now you have to roll back', 15.1, NULL);
INSERT INTO card_types VALUES (8, 'Improperly constrained DELETE', 'Predicate isn\'t correct; now you have to roll back', 15.8, NULL);
INSERT INTO card_types VALUES (9, 'Correlated subquery', 'Slows query execution for one turn', 49.1, 1000);
INSERT INTO card_types VALUES (10, 'Three-table cross join', 'Slows query execution for two turns', 57.7, 200);
INSERT INTO card_types VALUES (11, 'Runaway query', 'Database grids to a halt, oops!', 65.9, 400);
INSERT INTO card_types VALUES (12, 'Planner/optimizer upgrade', 'Counters slow-query attacks', 89.3, 25);
INSERT INTO card_types VALUES (13, 'Restart database server', 'Counters most attacks, but still incurs one turn of penalty', 320.1, 15);
INSERT INTO card_types VALUES (14, 'Disk Failure', 'Causes a loss for two turns, unless countered', 371.6, 10);
INSERT INTO card_types VALUES (15, 'Power Failure', 'Causes a loss for two turns, unless countered', 420.0, 15);
INSERT INTO card_types VALUES (16, 'Motherboard Failure', 'Causes a loss for three turns, unless countered', 491.4, 3);
INSERT INTO card_types VALUES (17, 'Redundant Hardware', 'Reduces penalty of hardware failure by 1 turn', 450.0, 20);
INSERT INTO card_types VALUES (18, 'RAID-5 Array', 'Counters storage failures for 1 turn due to increased redundancy', 371.8, 15);
INSERT INTO card_types VALUES (19, 'RAID-6 Array', 'Counters storage failures for 2 turns due to increased redundancy', 488.5, 10);
INSERT INTO card_types VALUES (20, 'Truncate Tables', 'Truncates all of opponent\'s tables, making their database useless', 791.0, 3);

INSERT INTO player_cards VALUES (1, 19, 13);
INSERT INTO player_cards VALUES (2, 7, 30);
INSERT INTO player_cards VALUES (3, 10, 2);
INSERT INTO player_cards VALUES (4, 2, 27);
INSERT INTO player_cards VALUES (5, 1, 32);
INSERT INTO player_cards VALUES (6, 19, 11);
INSERT INTO player_cards VALUES (7, 10, 19);
INSERT INTO player_cards VALUES (8, 5, 20);
INSERT INTO player_cards VALUES (9, 20, 11);
INSERT INTO player_cards VALUES (10, 17, 1);
INSERT INTO player_cards VALUES (11, 4, 27);
INSERT INTO player_cards VALUES (12, 18, 11);
INSERT INTO player_cards VALUES (13, 11, 20);
INSERT INTO player_cards VALUES (14, 9, 1);
INSERT INTO player_cards VALUES (15, 12, 11);
INSERT INTO player_cards VALUES (16, 18, 31);
INSERT INTO player_cards VALUES (17, 20, 32);
INSERT INTO player_cards VALUES (18, 11, 2);
INSERT INTO player_cards VALUES (19, 19, 19);
INSERT INTO player_cards VALUES (20, 14, 14);
INSERT INTO player_cards VALUES (21, 4, 1);
INSERT INTO player_cards VALUES (22, 9, 2);
INSERT INTO player_cards VALUES (23, 4, 13);
INSERT INTO player_cards VALUES (24, 7, 21);
INSERT INTO player_cards VALUES (25, 10, 6);
INSERT INTO player_cards VALUES (26, 19, 21);
INSERT INTO player_cards VALUES (27, 14, 1);
INSERT INTO player_cards VALUES (28, 18, 10);
INSERT INTO player_cards VALUES (29, 15, 32);
INSERT INTO player_cards VALUES (30, 18, 6);
INSERT INTO player_cards VALUES (31, 11, 17);
INSERT INTO player_cards VALUES (32, 18, 11);
INSERT INTO player_cards VALUES (33, 16, 27);
INSERT INTO player_cards VALUES (34, 5, 32);
INSERT INTO player_cards VALUES (35, 5, 2);
INSERT INTO player_cards VALUES (36, 9, 13);
INSERT INTO player_cards VALUES (37, 9, 27);
INSERT INTO player_cards VALUES (38, 7, 19);
INSERT INTO player_cards VALUES (39, 5, 21);
INSERT INTO player_cards VALUES (40, 9, 31);
INSERT INTO player_cards VALUES (41, 10, 6);
INSERT INTO player_cards VALUES (42, 10, 30);
INSERT INTO player_cards VALUES (43, 12, 21);
INSERT INTO player_cards VALUES (44, 17, 17);
INSERT INTO player_cards VALUES (45, 8, 27);
INSERT INTO player_cards VALUES (46, 14, 13);
INSERT INTO player_cards VALUES (47, 18, 10);
INSERT INTO player_cards VALUES (48, 3, 14);
INSERT INTO player_cards VALUES (49, 2, 19);
INSERT INTO player_cards VALUES (50, 15, 6);
INSERT INTO player_cards VALUES (51, 2, 27);
INSERT INTO player_cards VALUES (52, 5, 10);
INSERT INTO player_cards VALUES (53, 9, 2);
INSERT INTO player_cards VALUES (54, 11, 10);
INSERT INTO player_cards VALUES (55, 11, 2);
INSERT INTO player_cards VALUES (56, 15, 11);
INSERT INTO player_cards VALUES (57, 3, 17);
INSERT INTO player_cards VALUES (58, 19, 14);
INSERT INTO player_cards VALUES (59, 6, 21);
INSERT INTO player_cards VALUES (60, 7, 32);
INSERT INTO player_cards VALUES (61, 19, 30);
INSERT INTO player_cards VALUES (62, 16, 20);
INSERT INTO player_cards VALUES (63, 18, 13);
INSERT INTO player_cards VALUES (64, 8, 20);
INSERT INTO player_cards VALUES (65, 4, 21);
INSERT INTO player_cards VALUES (66, 2, 6);
INSERT INTO player_cards VALUES (67, 3, 14);
INSERT INTO player_cards VALUES (68, 19, 14);
INSERT INTO player_cards VALUES (69, 17, 11);
INSERT INTO player_cards VALUES (70, 12, 31);
INSERT INTO player_cards VALUES (71, 16, 10);
INSERT INTO player_cards VALUES (72, 14, 20);
INSERT INTO player_cards VALUES (73, 13, 13);
INSERT INTO player_cards VALUES (74, 10, 14);
INSERT INTO player_cards VALUES (75, 3, 14);
INSERT INTO player_cards VALUES (76, 17, 31);
INSERT INTO player_cards VALUES (77, 15, 17);
INSERT INTO player_cards VALUES (78, 12, 11);
INSERT INTO player_cards VALUES (79, 17, 31);
INSERT INTO player_cards VALUES (80, 11, 20);
INSERT INTO player_cards VALUES (81, 16, 10);
INSERT INTO player_cards VALUES (82, 5, 21);
INSERT INTO player_cards VALUES (83, 19, 32);
INSERT INTO player_cards VALUES (84, 1, 32);
INSERT INTO player_cards VALUES (85, 3, 10);
INSERT INTO player_cards VALUES (86, 14, 31);
INSERT INTO player_cards VALUES (87, 5, 6);
INSERT INTO player_cards VALUES (88, 13, 10);
INSERT INTO player_cards VALUES (89, 18, 2);
INSERT INTO player_cards VALUES (90, 1, 1);
INSERT INTO player_cards VALUES (91, 3, 32);
INSERT INTO player_cards VALUES (92, 3, 31);
INSERT INTO player_cards VALUES (93, 9, 19);
INSERT INTO player_cards VALUES (94, 12, 6);
INSERT INTO player_cards VALUES (95, 18, 20);
INSERT INTO player_cards VALUES (96, 3, 11);
INSERT INTO player_cards VALUES (97, 16, 19);
INSERT INTO player_cards VALUES (98, 13, 10);
INSERT INTO player_cards VALUES (99, 20, 19);
INSERT INTO player_cards VALUES (100, 11, 20);

INSERT INTO player_cards VALUES (101, 14, 11);
INSERT INTO player_cards VALUES (102, 16, 11);

INSERT INTO player_cards VALUES (103, 14, 19);
INSERT INTO player_cards VALUES (104, 19, 19);


INSERT INTO cards_for_sale VALUES (20, 100, '2015-08-11 13:31:02', 57.50);
INSERT INTO cards_for_sale VALUES (17, 77, '2015-08-12 16:59:54', 403.20);
INSERT INTO cards_for_sale VALUES (19, 49, '2016-04-15 12:21:42', 25.50);
INSERT INTO cards_for_sale VALUES (13, 73, '2015-09-20 18:04:04', 397.20);
INSERT INTO cards_for_sale VALUES (2, 89, '2015-08-30 02:29:31', 311.70);
INSERT INTO cards_for_sale VALUES (19, 93, '2015-09-28 01:26:12', 24.10);
INSERT INTO cards_for_sale VALUES (20, 62, '2015-06-01 12:18:01', 412.70);
INSERT INTO cards_for_sale VALUES (1, 21, '2015-10-15 08:28:37', 40.80);
INSERT INTO cards_for_sale VALUES (31, 76, '2015-09-30 01:59:14', 501.90);
INSERT INTO cards_for_sale VALUES (1, 27, '2016-07-30 23:33:13', 451.20);
INSERT INTO cards_for_sale VALUES (14, 48, '2016-04-26 02:55:22', 60.30);
INSERT INTO cards_for_sale VALUES (32, 5, '2015-09-04 15:15:07', 6.40);
INSERT INTO cards_for_sale VALUES (21, 65, '2016-07-03 21:15:15', 33.80);
INSERT INTO cards_for_sale VALUES (10, 52, '2016-01-29 20:34:27', 38.50);
INSERT INTO cards_for_sale VALUES (11, 12, '2015-06-24 09:05:33', 373.30);
INSERT INTO cards_for_sale VALUES (2, 53, '2016-07-05 23:46:04', 74.70);
INSERT INTO cards_for_sale VALUES (31, 86, '2016-02-04 08:05:37', 430.00);
INSERT INTO cards_for_sale VALUES (31, 92, '2015-07-26 08:03:46', 82.60);
INSERT INTO cards_for_sale VALUES (1, 14, '2015-09-18 03:14:05', 28.00);
INSERT INTO cards_for_sale VALUES (21, 82, '2015-06-07 06:08:50', 60.50);
INSERT INTO cards_for_sale VALUES (17, 44, '2015-10-31 02:45:50', 418.90);
INSERT INTO cards_for_sale VALUES (10, 28, '2015-02-02 17:51:35', 409.20);
INSERT INTO cards_for_sale VALUES (17, 31, '2016-03-13 01:28:26', 151.20);

