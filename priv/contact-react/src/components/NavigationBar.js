import React from 'react';
import {
  Navbar,
  Nav,
  NavDropdown,
  MenuItem,
  NavItem
} from 'react-bootstrap';

import {
  isLoggedIn,
  destroySession
} from '../util/session'

const logOut = callback => {
  return () => {
    destroySession();
    callback();
  }
}
const NavOptions = (handleClick, teams, currentTeam) => {
  return isLoggedIn()
    ? loggedInOptions(handleClick, teams, currentTeam)
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

const renderTeams = (teams) => {
  return teams &&
    teams.map(team => <MenuItem key={team.name}>{team.name}</MenuItem>);
}

const loggedInOptions = (handleAuthClick, teams, currentTeam) => {
  return (
    <Nav pullRight>
      <NavDropdown id="teamDropDown" eventKey={2} title={currentTeam.name}>
        {renderTeams(teams)}
      </NavDropdown>
      <NavItem eventKey={1} onClick={logOut(handleAuthClick('login'))}>Log out</NavItem>
    </Nav>
  );
}
const NavigationBar = (props) => {
  const {
    handleAuthClick, 
    teams,
    currentTeam
  } = props;

  return(
    <Navbar inverse collapseOnSelect>
      <Navbar.Header>
        <Navbar.Brand>
          <a href="#brand">Contact</a>
        </Navbar.Brand>
        <Navbar.Toggle />
      </Navbar.Header>
      <Navbar.Collapse>
        {NavOptions(handleAuthClick, teams, currentTeam)}
      </Navbar.Collapse>
    </Navbar>
  );
}

export default NavigationBar;
