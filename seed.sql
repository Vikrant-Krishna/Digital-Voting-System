-- Optional demonstration rows for the supplied VotingDB schema.
-- Run only after the existing schema has been created. Passwords here are
-- plain text solely for local demo use; the application also accepts bcrypt hashes.
USE VotingDB;
INSERT INTO Student (
        Student_ID,
        Name,
        Email,
        Branch,
        `Year`,
        Phone,
        Password
    )
VALUES (
        1001,
        'Aarav Mehta',
        'aarav.mehta@example.edu',
        'Computer Science',
        3,
        '9000000101',
        'student123'
    ),
    (
        1002,
        'Vikrant Krishna',
        'diya.shah@example.edu',
        'Electronics',
        2,
        '9000000102',
        'student123'
    ),
    (
        1003,
        'Kabir Rao',
        'kabir.rao@example.edu',
        'Mechanical',
        3,
        '9000000103',
        'student123'
    ),
    (
        1004,
        'Virat Krishna',
        'virat@8gmail.com',
        'CSE',
        4,
        '7007809564',
        '123456'
    );
INSERT INTO Admin (Admin_ID, Name, Email, Password)
VALUES (
        1,
        'Demo Administrator',
        'admin@example.edu',
        'admin123'
    );
INSERT INTO Election (
        Election_ID,
        Election_Name,
        Start_Date,
        End_Date,
        Status
    )
VALUES (
        1,
        'Student Council Election 2026',
        '2026-09-20',
        '2026-09-30',
        'Active'
    );
SET @demo_election = 1;
INSERT INTO Election_Position (Position_ID, Position_Name, Max_Winners)
VALUES (1, 'President', 1),
    (2, 'Secretary', 1),
    (3, 'Treasurer', 1);
SET @president = 1;
SET @secretary = 2;
-- Candidates are created for the first election inserted above and three positions above.
INSERT INTO Candidate (
        Candidate_ID,
        Student_ID,
        Election_ID,
        Position_ID,
        Manifesto
    )
VALUES (
        1,
        1001,
        @demo_election,
        @president,
        'More inclusive campus events and clear student updates.'
    ),
    (
        2,
        1002,
        @demo_election,
        @president,
        'A stronger student voice and practical campus improvements.'
    ),
    (
        3,
        1003,
        @demo_election,
        @secretary,
        'Reliable communication between clubs and students.'
    );
INSERT INTO Voter_Verification (
        Verification_ID,
        Student_ID,
        Election_ID,
        Verification_Status,
        Verified_At
    )
VALUES (1, 1001, @demo_election, 'Verified', NOW()),
    (2, 1002, @demo_election, 'Verified', NOW()),
    (3, 1003, @demo_election, 'Unverified', NULL);
