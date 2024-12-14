

const QRCode = require('qrcode');

// Function to generate QR code with embedded JSON data
async function generateQRWithData(data) {
    // Create the JSON object with your MySQL insert data
    const jsonData = JSON.stringify(data);

    try {
        // Generate QR code as data URL
        const qrDataUrl = await QRCode.toDataURL(jsonData);
        return qrDataUrl;
    } catch (err) {
        console.error('Error generating QR code:', err);
        throw err;
    }
}

// Function to read QR code and insert into MySQL
function insertDataFromQR(jsonData) {
    const connection = mysql.createConnection({
        host: 'localhost',
        user: 'your_username',
        password: 'your_password',
        database: 'your_database'
    });

    const data = JSON.parse(jsonData);

    // Customize this query based on your table structure
    const query = 'INSERT INTO your_table SET ?';

    connection.query(query, data, (error, results) => {
        if (error) throw error;
        console.log('Data inserted:', results);
    });

    connection.end();
}

// Example usage:
const sampleData = {
    name: 'John Doe',
    email: 'john@example.com',
    timestamp: new Date().toISOString()
};

// Generate QR code
generateQRWithData(sampleData)
    .then(qrDataUrl => {
        console.log('QR Code generated:', qrDataUrl);
        // You can now use this data URL to display or save the QR code
    })
    .catch(err => console.error(err));