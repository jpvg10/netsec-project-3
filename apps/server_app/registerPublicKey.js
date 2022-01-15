const axios = require('axios');
const apiParams = require('./api_params');

const baseUrl = 'http://meshmash.vikaa.fi:49335';
const { deviceId, publicKey, token } = apiParams;
axios.defaults.headers.common['Authorization'] = `Bearer ${token}`;

const run = async () => {
  try {
    let res = await axios.put(`${baseUrl}/devices/${deviceId}`, { "public_key": publicKey });
    console.log(res.data);
  } catch (e) {
    console.log(e);
  }
};

run();
