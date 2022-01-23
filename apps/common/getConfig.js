const fs = require('fs');
const childProcess = require('child_process');
const axios = require('axios');
const apiParams = require('./api_params');

const baseUrl = 'http://meshmash.vikaa.fi:49335';
const { deviceId, overlayId, token: initialToken } = apiParams;

const setToken = (token) => {
  axios.defaults.headers.common['Authorization'] = `Bearer ${token}`;
};

setToken(initialToken);

const run = async (firstTime) => {
  let res;
  try {
    if(!firstTime) {
      // Renew token
      res = await axios.get(`${baseUrl}/devices/${deviceId}/token`);
      console.log(res.data);
      setToken(res.data.token);
    }

    // Get config
    res = await axios.get(`${baseUrl}/overlays/${overlayId}/devices/${deviceId}/wgconfig`);
    let config = res.data;
    config = config.replace(/\[Peer \d*]/g, '[Peer]');
    console.log(config);

    // Copy base file
    fs.copyFileSync('/etc/wireguard/wg0-base.conf', '/etc/wireguard/wg0.conf');

    // Append config
    fs.appendFileSync('/etc/wireguard/wg0.conf', config);

    if(!firstTime) {
      // Reload wireguard
      childProcess.execSync('wg-quick down wg0');
    }
    childProcess.execSync('wg-quick up /etc/wireguard/wg0.conf');
  } catch (e) {
    console.log(e);
  }
};

run(true);

/* const halfHour = 30 * 60 * 1000;
setInterval(() => {
  run(false);
}, halfHour); */
