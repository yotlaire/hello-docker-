"use strict";
// index.ts
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
// Import necessary modules
const http_1 = __importDefault(require("http"));
const fs_1 = __importDefault(require("fs"));
const path_1 = __importDefault(require("path"));
// Define the port number
const port = 3000;
// Create a server
const server = http_1.default.createServer((req, res) => {
    // Read the HTML file
    const filePath = path_1.default.join(__dirname, 'index.html');
    fs_1.default.readFile(filePath, (err, data) => {
        if (err) {
            res.writeHead(500);
            res.end(err.message);
            return;
        }
        // Set the content type to HTML
        res.writeHead(200, { 'Content-Type': 'text/html' });
        // Send the HTML content
        res.end(data);
    });
});
// Start the server
server.listen(port, () => {
    console.log(`Server is running on http://localhost:${port}`);
    console.log("Open http://localhost:3000 to view it in the browser.");
});
