function search(params, cb) {
  const path = `items?q=${params.query}&page=${params.page}&per_page=${params.per_page}`;
  return fetch(path, {
    accept: 'application/json',
  }).then(checkStatus)
    .then(parseJSON)
    .then(cb);
}

function checkStatus(response) {
  if (response.status >= 200 && response.status < 300) {
    return response;
  }
  const error = new Error(`HTTP Error ${response.statusText}`);
  error.status = response.statusText;
  error.response = response;
  console.log(error);
  throw error;
}

function parseJSON(response) {
  return response.json();
}

const Client = { search };
export default Client;
