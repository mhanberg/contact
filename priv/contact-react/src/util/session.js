const sessionKey = 'contact-react-session';

function putSession(token) {
  console.log('in putSession');
  localStorage.setItem(sessionKey, token);
}

function getSession() {
  console.log('in getSession');
  localStorage.getItem(sessionKey);
}

export {
  putSession,
  getSession
}
