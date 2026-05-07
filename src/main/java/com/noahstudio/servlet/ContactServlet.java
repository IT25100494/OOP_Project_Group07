package com.noahstudio.servlet;

import com.noahstudio.util.FileHandler;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;
import java.time.LocalDate;

/**
 * ContactServlet — saves contact form messages to contacts.txt.
 * URL: /contact
 */
public class ContactServlet extends HttpServlet {

    private static final String CONTACT_FILE = "contacts.txt";

    @Override
    public void init() throws ServletException {
        String dataPath = getServletContext().getRealPath("/") + "data";
        FileHandler.init(dataPath);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        String name    = FileHandler.sanitize(req.getParameter("name"));
        String email   = FileHandler.sanitize(req.getParameter("email"));
        String message = FileHandler.sanitize(req.getParameter("message"));

        if (FileHandler.isNullOrEmpty(name) || !FileHandler.isValidEmail(email)
                || FileHandler.isNullOrEmpty(message)) {
            req.setAttribute("error", "Please fill all fields with valid data.");
            req.getRequestDispatcher("/contact.jsp").forward(req, res);
            return;
        }

        // Store: date|name|email|message
        String record = LocalDate.now() + "|" + name + "|" + email + "|" + message;
        FileHandler.appendLine(CONTACT_FILE, record);

        req.setAttribute("success", "Message sent! We'll get back to you within 24 hours.");
        req.getRequestDispatcher("/contact.jsp").forward(req, res);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        req.getRequestDispatcher("/contact.jsp").forward(req, res);
    }
}
