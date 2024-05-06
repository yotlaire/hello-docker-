// index.ts

// Import necessary modules
import http from 'http';
import fs from 'fs';
import path from 'path';

// Define the port number
const port = 3000;

// Create a server
const server = http.createServer((req, res) => {
    // Read the HTML file
    const filePath = path.join(__dirname, 'index.html');
    fs.readFile(filePath, (err, data) => {
        if (err) {
            res.writeHead(500);
            res.end(err.message);
            return;
        }

        // Set the content type to HTML
        res.writeHead(200, {'Content-Type': 'text/html'});
        // Send the HTML content
        res.end(data);
    });
});

// Start the server
server.listen(port, () => {
    console.log(`Server is running on http://localhost:${port}`);
    console.log("Open http://localhost:3000 to view it in the browser.");
});
