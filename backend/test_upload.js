const http = require('http');
const fs = require('fs');
const path = require('path');

const token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY5Nzc0Y2FmMWE0YTRiNGFhNDJhMmIzMyIsImlhdCI6MTc2OTg4NTM3MCwiZXhwIjoxNzcyNDc3MzcwfQ.fvqcre9H3wkDDC9OZi6lEvOK61oxblwoO_MjZoq7ltg';

const testUpload = () => {
    const boundary = '----WebKitFormBoundary7MA4YWxkTrZu0gW';
    const filename = 'test.png';
    const filePath = path.join(__dirname, 'dump_events.js'); // just use an existing file
    const fileContent = fs.readFileSync(filePath);

    const postData = Buffer.concat([
        Buffer.from(`--${boundary}\r\n`),
        Buffer.from(`Content-Disposition: form-data; name="image"; filename="${filename}"\r\n`),
        Buffer.from('Content-Type: image/png\r\n\r\n'),
        fileContent,
        Buffer.from(`\r\n--${boundary}--\r\n`)
    ]);

    const options = {
        hostname: 'localhost',
        port: 5000,
        path: '/api/events/upload',
        method: 'POST',
        headers: {
            'Authorization': `Bearer ${token}`,
            'Content-Type': `multipart/form-data; boundary=${boundary}`,
            'Content-Length': postData.length
        }
    };

    const req = http.request(options, (res) => {
        let data = '';
        res.on('data', (chunk) => data += chunk);
        res.on('end', () => {
            console.log('Status:', res.statusCode);
            console.log('Response:', data);
        });
    });

    req.on('error', (e) => console.error(e));
    req.write(postData);
    req.end();
};

testUpload();
