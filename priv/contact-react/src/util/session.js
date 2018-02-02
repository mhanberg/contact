const sessionKey = 'contact-react-session';

function putSession(token) {
  localStorage.setItem(sessionKey, token);
}

function getSession() {
  return localStorage.getItem(sessionKey);
}

function destroySession() {
  localStorage.removeItem(sessionKey);
}

function isLoggedIn() {
  return !!getSession();
}

export {
  putSession,
  getSession,
  destroySession,
  isLoggedIn
}
