<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    HttpSession userSession = request.getSession(false);
    String loggedRole = (userSession != null) ? (String)userSession.getAttribute("role") : null;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Contact — Noah Studio</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<body>
<nav class="navbar scrolled">
    <a class="navbar-brand" href="index.jsp">Noah<span>Studio</span></a>
    <ul class="nav-links">
        <li><a href="index.jsp#home">Home</a></li>
        <li><a href="index.jsp#about">About</a></li>
        <li><a href="portfolio?action=list">Portfolio</a></li>
        <li><a href="index.jsp#packages">Packages</a></li>
        <li><a href="index.jsp#testimonials">Review</a></li>
        <li><a href="index.jsp#contact" class="active">Contact</a></li>
        <% if (loggedRole != null) { %>
            <li><a href="booking?action=list">My Bookings</a></li>
            <% if ("admin".equals(loggedRole)) { %><li><a href="admin-dashboard.jsp">Dashboard</a></li><% } %>
            <% if ("photographer".equals(loggedRole)) { %><li><a href="photographer-dashboard.jsp">Dashboard</a></li><% } %>
            <% if ("videographer".equals(loggedRole)) { %><li><a href="videographer-dashboard.jsp">Dashboard</a></li><% } %>
            <li><a href="user?action=logout" class="btn-nav">Logout</a></li>
        <% } else { %>
            <li><a href="login.jsp" class="btn-nav">Login</a></li>
        <% } %>
    </ul>
</nav>

<section class="hero" style="height: 100vh; grid-template-columns: 0.8fr 1.2fr; gap: 0;">
    <div class="hero-image-container" style="height: 100%; border-right: 1px solid rgba(255,255,255,0.05);">
        <img src="https://images.unsplash.com/photo-1540575467063-178a50c2df87?w=1000" style="clip-path: none; filter: brightness(0.4) grayscale(1);" alt="Studio Setup">
        <div style="position:absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); text-align: center; width: 80%;">
            <span class="section-tag">Reach Out</span>
            <h1 style="font-size: 3rem;">Let's Talk <br><span style="color:var(--accent)">Business</span></h1>
            <p style="color:var(--text-muted); margin-top: 2rem;">Kuala Lumpur, Malaysia<br>+60 12-345 6789<br>hello@noahstudio.com</p>
        </div>
    </div>
    <div class="hero-content" style="padding: 0 10%;">
        <div class="card" style="border:none;">
            <h2 style="margin-bottom: 2rem;">Send <span style="color:var(--accent)">Message</span></h2>
            <form action="contact" method="post">
                <div class="form-group"><label>Full Name</label><input type="text" name="name" class="form-control" placeholder="Your Name" required></div>
                <div class="form-group"><label>Email</label><input type="email" name="email" class="form-control" placeholder="email@address.com" required></div>
                <div class="form-group"><label>Message</label><textarea name="message" class="form-control" rows="5" placeholder="Tell us about your project..."></textarea></div>
                <button type="submit" class="btn-primary" style="width: 100%;">Send Inquiry</button>
            </form>
        </div>
    </div>
</section>
</body>
</html>
