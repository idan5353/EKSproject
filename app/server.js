const express = require('express');
const app = express();
const port = process.env.PORT || 3000;


app.get('/', (req, res) => {
res.json({
message: 'Hello from EKS! 🚀',
time: new Date().toISOString(),
version: process.env.APP_VERSION || 'dev',
node: process.version
});
});


app.listen(port, () => console.log(`Server listening on ${port}`));