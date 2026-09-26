function login() {

    let studentId = document.getElementById("studentId").value;
    let password = document.getElementById("password").value;

    if (studentId === "" || password === "") {

        document.getElementById("message").innerText =
            "Please enter Student ID and Password";

        return;
    }

    // Temporary login for frontend demonstration
    if (studentId === "student1" && password === "1234") {

        alert("Login Successful!");

        window.location.href = "student.html";

    } else {

        document.getElementById("message").innerText =
            "Invalid Student ID or Password";
    }
}