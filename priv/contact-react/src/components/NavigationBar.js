import React from 'react';
import {
  Navbar,
  Nav,
  NavItem
} from 'react-bootstrap';

import {
  isLoggedIn,
  destroySession
} from '../util/session'

const logOut = callback => {
  destroySession();
  return callback;
}
const NavOptions = (handleClick) => {
  return isLoggedIn()
    ? loggedInOptions(handleClick)
    : loggedOutOptions(handleClick); 
}
const loggedOutOptions = (handleAuthClick) => {
  return(
    <Nav pullRight>
      <NavItem eventKey={1} onClick={handleAuthClick('login')}>
        Login
      </NavItem>
      <NavItem eventKey={2} onClick={handleAuthClick('signUp')}>
        Sign Up
      </NavItem>
    </Nav>
  );
}
const loggedInOptions = (handleAuthClick) => {
  return <Nav pullRight><NavItem eventKey={1} onClick={logOut(handleAuthClick('login'))}>Log out</NavItem></Nav>;
}
const NavigationBar = (props) => {
  const {handleAuthClick} = props;

  return(
    <Navbar inverse collapseOnSelect>
      <Navbar.Header>
        <Navbar.Brand>
          <a href="#brand">Contact</a>
        </Navbar.Brand>
        <Navbar.Toggle />
      </Navbar.Header>
      <Navbar.Collapse>
        {NavOptions(handleAuthClick)}
      </Navbar.Collapse>
    </Navbar>
  );
}

export default NavigationBar;
