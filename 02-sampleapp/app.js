'use strict';

const express = require('express');

// Constants
const PORT = 11130;
const HOST = '0.0.0.0';

// App
const app = express();
app.get('/', (req, res) => {
  res.send('Hello Koçsistem');
});

app.listen(PORT, HOST);
console.log(`Running on http://${HOST}:${PORT}`);
