const axios = require('axios');

void (async () => {
  const response = await axios({
    method: "get",
    url: "https://api.sampleapis.com/beers/ale",
  });
  console.log(response.data[0]);
})();
