# Digital Voting Management System

A beginner-friendly student election portal built with HTML, CSS, vanilla JavaScript, Express and MySQL. It uses the existing `VotingDB` database and the table/column names in the project requirements. The original prototype files remain in the project root; the running website is served from `public/`.

## Existing project inspection

The uploaded workspace originally contained eight static prototype files: `index.html`, `student.html`, `election.html`, `candidate.html`, `voting.html`, `result.html`, `script.js` and `style.css`. The pages had demo-only content and a hardcoded frontend login. No SQL schema, sample-data script, Node backend, package manifest, or environment file was present. The existing pages have been kept; the working site is implemented in `public/` and is served by Express.

Since the exact SQL DDL was not uploaded, this application uses the names and relationships listed in the request. No schema change is required for the core flows. `Election_Result` is expected to have a unique key covering `(Election_ID, Position_ID, Candidate_ID)` for result upserts; if that key is absent, add it only after checking/removing any duplicate rows. The provided `Vote` unique key `(Student_ID, Election_ID)` remains the final duplicate-vote safeguard.

## Technologies

- Frontend: HTML, CSS, vanilla JavaScript
- Backend: Node.js and Express
- Database: MySQL with `mysql2`
- Sessions: `express-session`; session cookies are HTTP-only
- Student and admin passwords: login accepts existing plain text values for compatibility with a college schema and bcrypt hashes for newly created admin-managed student accounts. For a real deployment, migrate all stored passwords to hashes and use HTTPS plus a persistent session store.

## Database structure used

The application expects `VotingDB` and the tables described in the request:

- `Student(Student_ID, Name, Email, Branch, Year, Phone, Password)`
- `Election(Election_ID, Election_Name, Start_Date, End_Date, Status)`
- `Election_Position(Position_ID, Position_Name, Max_Winners)`
- `Candidate(Candidate_ID, Student_ID, Election_ID, Position_ID, Manifesto)`
- `Vote(Vote_ID, Student_ID, Candidate_ID, Election_ID, Vote_Time)` with `UNIQUE(Student_ID, Election_ID)`
- `Admin(Admin_ID, Name, Email, Password)`
- `Voter_Verification(Verification_ID, Student_ID, Election_ID, Verification_Status, Verified_At)` with `UNIQUE(Student_ID, Election_ID)`
- `Election_Result(Result_ID, Election_ID, Position_ID, Candidate_ID, Vote_Count)`
- `Complaint(Complaint_ID, Student_ID, Election_ID, Description, Status, Created_At)`

Expected relationships follow the SQL design: candidates link students, elections and positions; votes link students, candidates and elections; verification links students and elections; results link elections, positions and candidates; complaints link students and elections. Use the existing SQL foreign keys exactly as defined in your schema. Position rows are shared across elections; candidate records associate a position with an election.

## Setup

1. Start your local MySQL server using MySQL Workbench, the MySQL Windows service, XAMPP, or your existing setup.
2. In MySQL Workbench or the MySQL client, run your original database schema SQL file first. It should create `VotingDB` and its tables. **No schema SQL was in the uploaded folder**, so this project intentionally does not replace it with guessed DDL.
3. Optionally run `seed.sql` after the schema to insert demonstration accounts, election and candidate data. Run it once on a clean database because it uses fixed demo student IDs and inserts fresh election and position rows.
4. Copy `.env.example` to `.env`, then set your local `DB_HOST`, `DB_USER`, `DB_PASSWORD`, `DB_NAME=VotingDB`, `PORT=5000`, and a private `SESSION_SECRET`. `.env` is ignored by Git.
5. In PowerShell, from this project folder, install dependencies and start the backend:

   ```powershell
   npm install
   npm start
   ```

6. Open [http://localhost:5000](http://localhost:5000). Do not open the HTML with `file://`; the pages need the Express API.

## Demo accounts

These accounts are inserted by the optional seed file and are for local classroom demonstrations only:

- Student: `1001` / `student123` (verified in the sample election)
- Student: `1002` / `student123` (verified in the sample election)
- Student: `1003` / `student123` (unverified in the sample election)
- Admin: `admin@example.edu` / `admin123`

Change or remove these values before sharing the application beyond a local demo. No credentials are hardcoded in frontend JavaScript.

## How the application works

1. Admin signs in from the Admin Login page.
2. Admin creates an election and adds shared election positions.
3. Student rows already exist or are created by the admin.
4. Admin registers candidates by choosing a student, election and position.
5. Admin verifies each eligible voter for an election.
6. The election status is set to `Active` for the voting window.
7. A verified student selects a candidate. The backend checks login, election dates/status, verification and candidate membership.
8. The backend inserts one vote. The existing unique `(Student_ID, Election_ID)` constraint prevents another vote even if requests race.
9. Admin ends the election and generates result snapshots. Results are counted with a `LEFT JOIN` and `COUNT(Vote_ID)` and saved to `Election_Result`.
10. Results appear after the election has ended. Students can submit complaints, and admins can mark them pending or resolved.

The current schema stores one vote per student per election, so the vote form displays candidates from all positions in that election in a single list. To support one vote per position, the unique key and vote workflow would need a schema change; this project preserves the specified constraint.

## Pages

- Landing and separate student/admin sign-in
- Student dashboard, elections, candidate list, vote, results, complaints and profile
- Admin dashboard, student/election/position CRUD, candidate registration, voter verification, read-only vote records, results generation and complaint status management
- Responsive layout with a collapsible mobile navigation

## API overview

Public/authenticated student endpoints:

- `POST /api/student/login`, `POST /api/admin/login`, `POST /api/logout`, `GET /api/me`
- `GET /api/elections`, `GET /api/elections/:id`, `GET /api/elections/:id/candidates`
- `GET /api/students/:id`, `PUT /api/student/profile`, `GET /api/verification-status/:electionId`
- `POST /api/votes`, `GET /api/results/:electionId`
- `POST /api/complaints`, `GET /api/complaints/student/:studentId`

Admin endpoints:

- `GET /api/admin/summary`
- `GET/POST/PUT/DELETE /api/admin/students[/:id]`
- `GET/POST/PUT/DELETE /api/admin/elections[/:id]`
- `GET/POST/PUT/DELETE /api/admin/positions[/:id]`
- `GET/POST/PUT/DELETE /api/admin/candidates[/:id]`
- `GET/POST /api/admin/verification`, `PUT /api/admin/verification/:id`
- `GET /api/admin/votes` (read-only)
- `POST /api/admin/results/:electionId/generate`
- `GET /api/admin/complaints`, `PUT /api/admin/complaints/:id`

Every SQL statement uses placeholders for user-supplied values. Login and protected endpoints use server sessions. Voting decisions are enforced by the backend.

## Testing locally

After the schema, `.env`, and seed data are ready, log in as `1001` and use the sample active election. Pick a candidate and confirm the vote. The second submission for that election should show “You have already voted in this election.” `1003` should see the unverified message and be unable to submit a vote. To test admin results, set the election status to an ended status such as `Completed` (or set the end date in the past), log in as admin, open Results and generate the results. A student complaint can be created from Complaints and marked resolved in the admin Complaints screen.

The existing unique constraint must be present in the original schema for duplicate-vote behavior. This environment did not include a schema file, a configured `.env`, or database credentials, so a live MySQL workflow could not be run during implementation.
