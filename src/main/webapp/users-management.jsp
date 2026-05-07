<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.noahstudio.model.*, com.noahstudio.util.FileHandler, java.util.*" %>
<%
    try {
        // 1. Session & Auth Check
        HttpSession sess = request.getSession(false);
        if (sess == null || !"admin".equals(sess.getAttribute("role"))) { 
            response.sendRedirect("login.jsp"); 
            return; 
        }
        
        // 2. Initialize Data
        FileHandler.init(application.getRealPath("/") + "data");
        List<User> usersList = new ArrayList<>();
        List<String> rawLines = FileHandler.readLines("users.txt");
        for (String line : rawLines) {
            User u = User.fromFileString(line);
            if (u != null) usersList.add(u);
        }

        // 3. Request Parameters
        String query = request.getParameter("q");
        String roleFilter = request.getParameter("roleFilter");
        String showAdd = request.getParameter("showAdd");
        String editId = request.getParameter("editId");
        
        // 4. Handle Edit Target
        User targetUser = null;
        if (editId != null && !editId.trim().isEmpty()) {
            String targetLine = FileHandler.findById("users.txt", editId);
            if (targetLine != null) targetUser = User.fromFileString(targetLine);
        }

        // 5. Search Logic Prep
        String searchQ = (query != null) ? query.toLowerCase().trim() : "";
        String filterR = (roleFilter != null) ? roleFilter.toLowerCase().trim() : "";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Command — Noah Studio</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;800&family=Outfit:wght@400;800&display=swap" rel="stylesheet">
</head>
<body class="dashboard-body" style="background: var(--bg-primary);">

<div class="dashboard-layout">
    <!-- Sidebar Navigation -->
    <jsp:include page="admin-sidebar.jsp" />

    <!-- Main Content Area -->
    <main class="main-content">
        <header class="content-header">
            <div class="header-title">
                <span class="section-tag">System Registry</span>
                <h1>User <span class="text-accent">Management</span></h1>
            </div>
            <div class="header-meta">
                <span class="status-indicator online"></span>
                Administrator Access • <%= new java.text.SimpleDateFormat("MMM dd, yyyy").format(new java.util.Date()) %>
            </div>
        </header>

        <!-- Modal: Add New User -->
        <% if ("true".equals(showAdd)) { %>
        <div class="modal-overlay">
            <div class="modal-container">
                <a href="users-management.jsp" class="modal-close-btn"><i class="fa fa-times"></i></a>
                <div class="card card-featured" style="margin:0; border:none; box-shadow:none;">
                    <div class="card-header">
                        <h3>Register New Member</h3>
                        <p>Enter the credentials and profile details for the new studio account.</p>
                    </div>
                    <form action="user" method="post" class="ns-form">
                        <input type="hidden" name="action" value="register">
                        <input type="hidden" name="isAdminSource" value="true">
                        <input type="hidden" name="redirect" value="users-management.jsp">
                        
                        <div class="form-grid-3">
                            <div class="form-group"><label>Username</label><input type="text" name="username" class="form-control" required placeholder="e.g. jdoe_pro"></div>
                            <div class="form-group"><label>Password</label><input type="password" name="password" class="form-control" required placeholder="••••••••"></div>
                            <div class="form-group">
                                <label>Assigned Role</label>
                                <select name="role" class="form-control">
                                    <option value="client">Client</option>
                                    <option value="photographer">Photographer</option>
                                    <option value="videographer">Videographer</option>
                                    <option value="admin">Administrator</option>
                                </select>
                            </div>
                        </div>
                    <div class="form-grid-3 mt-1">
                        <div class="form-group"><label>Full Name</label><input type="text" name="fullName" class="form-control" required placeholder="e.g. John Doe"></div>
                        <div class="form-group"><label>Email Address</label><input type="email" name="email" class="form-control" required placeholder="name@noahstudio.com"></div>
                        <div class="form-group"><label>Phone Number</label><input type="text" name="phone" class="form-control" placeholder="+94 7X XXX XXXX"></div>
                    </div>
                    <div class="form-grid-3 mt-1">
                        <div class="form-group">
                            <label>Duty Status</label>
                            <select name="availability" class="form-control">
                                <option value="Available">Available</option>
                                <option value="Unavailable">Unavailable</option>
                                <option value="On Leave">On Leave</option>
                            </select>
                        </div>
                    </div>
                        <div class="form-actions mt-2">
                            <button type="submit" class="btn-primary">Create Account</button>
                            <a href="users-management.jsp" class="btn-outline">Dismiss</a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
        <% } %>

        <!-- Modal: Edit Existing User -->
        <% if (targetUser != null) { %>
        <div class="modal-overlay">
            <div class="modal-container">
                <a href="users-management.jsp" class="modal-close-btn"><i class="fa fa-times"></i></a>
                <div class="card card-featured" style="margin:0; border:none; box-shadow:none;">
                    <div class="card-header">
                        <h3>Edit Member: <span class="text-accent"><%= targetUser.getFullName() %></span></h3>
                        <p>Modifying profile data for UID: <%= targetUser.getId() %></p>
                    </div>
                    <form action="user" method="post" class="ns-form">
                        <input type="hidden" name="action" value="adminUpdateUser">
                        <input type="hidden" name="id" value="<%= targetUser.getId() %>">
                        <input type="hidden" name="redirect" value="users-management.jsp">
                        
                        <div class="form-grid-3">
                            <div class="form-group"><label>Full Name</label><input type="text" name="fullName" class="form-control" value="<%= targetUser.getFullName() %>" required></div>
                            <div class="form-group">
                                <label>Role</label>
                                <select name="role" class="form-control">
                                    <option value="client" <%= "client".equals(targetUser.getRole()) ? "selected" : "" %>>Client</option>
                                    <option value="photographer" <%= "photographer".equals(targetUser.getRole()) ? "selected" : "" %>>Photographer</option>
                                    <option value="videographer" <%= "videographer".equals(targetUser.getRole()) ? "selected" : "" %>>Videographer</option>
                                    <option value="admin" <%= "admin".equals(targetUser.getRole()) ? "selected" : "" %>>Administrator</option>
                                </select>
                            </div>
                            <div class="form-group"><label>Reset Password (Optional)</label><input type="password" name="password" class="form-control" placeholder="Leave blank to keep current"></div>
                        </div>
                        <div class="form-grid-3 mt-1">
                            <div class="form-group"><label>Email Address</label><input type="email" name="email" class="form-control" value="<%= targetUser.getEmail() %>" required></div>
                            <div class="form-group"><label>Phone Number</label><input type="text" name="phone" class="form-control" value="<%= targetUser.getPhone() %>"></div>
                        </div>
                        <div class="form-grid-3 mt-1">
                            <div class="form-group">
                                <label>Duty Status</label>
                                <select name="availability" class="form-control">
                                    <option value="Available" <%= "Available".equals(targetUser.getAvailability()) ? "selected" : "" %>>Available</option>
                                    <option value="Unavailable" <%= "Unavailable".equals(targetUser.getAvailability()) ? "selected" : "" %>>Unavailable</option>
                                    <option value="On Leave" <%= "On Leave".equals(targetUser.getAvailability()) ? "selected" : "" %>>On Leave</option>
                                </select>
                            </div>
                        </div>
                        <div class="form-actions mt-2">
                            <button type="submit" class="btn-primary">Save Changes</button>
                            <a href="users-management.jsp" class="btn-outline">Cancel</a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
        <% } %>

        <!-- Registry Header & Search -->
        <div class="registry-controls mb-2">
            <div class="control-header">
                <h2>Member Registry</h2>
                <a href="users-management.jsp?showAdd=true" class="btn-primary-sm"><i class="fa fa-plus"></i> Register User</a>
            </div>
            
            <form action="users-management.jsp" method="get" class="search-bar">
                <div class="input-group">
                    <i class="fa fa-search"></i>
                    <input type="text" name="q" placeholder="Search by name, ID or email..." value="<%= (query != null) ? query : "" %>">
                </div>
                <select name="roleFilter" class="filter-select">
                    <option value="">All Roles</option>
                    <option value="admin" <%= "admin".equals(roleFilter) ? "selected" : "" %>>Admins</option>
                    <option value="client" <%= "client".equals(roleFilter) ? "selected" : "" %>>Clients</option>
                    <option value="photographer" <%= "photographer".equals(roleFilter) ? "selected" : "" %>>Photographers</option>
                    <option value="videographer" <%= "videographer".equals(roleFilter) ? "selected" : "" %>>Videographers</option>
                </select>
                <button type="submit" class="btn-secondary">Apply Filters</button>
            </form>
        </div>

        <!-- Registry Table -->
        <div class="card card-table">
            <table class="ns-table">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Full Name</th>
                        <th>Role</th>
                        <th>Status</th>
                        <th>Email</th>
                        <th class="text-right">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% 
                        int matchCount = 0;
                        for(User u : usersList) { 
                            boolean matchesQ = searchQ.isEmpty() || 
                                               (u.getFullName() != null && u.getFullName().toLowerCase().contains(searchQ)) || 
                                               (u.getId() != null && u.getId().toLowerCase().contains(searchQ)) ||
                                               (u.getEmail() != null && u.getEmail().toLowerCase().contains(searchQ));
                            boolean matchesR = filterR.isEmpty() || 
                                               (u.getRole() != null && u.getRole().equalsIgnoreCase(filterR));
                            
                            if (matchesQ && matchesR) {
                                matchCount++;
                    %>
                    <tr>
                        <td class="text-muted"><%= u.getId() %></td>
                        <td class="font-bold"><%= u.getFullName() %></td>
                        <td><span class="role-badge badge-<%= u.getRole() %>"><%= u.getRole().toUpperCase() %></span></td>
                        <td>
                            <span class="status-badge <%= "Available".equals(u.getAvailability()) ? "status-online" : "status-offline" %>">
                                <i class="fa <%= "Available".equals(u.getAvailability()) ? "fa-check-circle" : "fa-times-circle" %>"></i>
                                <%= u.getAvailability() %>
                            </span>
                        </td>
                        <td class="text-sm"><%= u.getEmail() %></td>
                        <td class="text-right">
                            <div class="action-group">
                                <a href="users-management.jsp?editId=<%= u.getId() %>" class="btn-icon" title="Edit Profile"><i class="fa fa-pen-to-square"></i></a>
                                <form action="user" method="post" onsubmit="return confirm('Archive this user account permanently?');" style="display:inline;">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="id" value="<%= u.getId() %>">
                                    <input type="hidden" name="redirect" value="users-management.jsp">
                                    <button type="submit" class="btn-icon btn-delete" title="Remove User"><i class="fa fa-trash-can"></i></button>
                                </form>
                            </div>
                        </td>
                    </tr>
                    <%      }
                        } 
                        if(matchCount == 0) {
                    %>
                    <tr><td colspan="7" class="text-center py-5 text-muted">No members found matching your criteria.</td></tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </main>
</div>

<%
    } catch (Exception e) {
        out.println("<div class='debug-panel'>");
        out.println("<h3>Critical Engine Error</h3><pre>");
        e.printStackTrace(new java.io.PrintWriter(out));
        out.println("</pre></div>");
    }
%>

</body>
</html>   
 