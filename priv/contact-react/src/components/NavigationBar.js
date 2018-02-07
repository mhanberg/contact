import React from 'react';
import _ from 'lodash';
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
const NavOptions = (handleClick, teams, currentTeam, setCurrentTeam, openCreateTeamModal) => {
  return isLoggedIn()
    ? loggedInOptions(handleClick, teams, currentTeam, setCurrentTeam, openCreateTeamModal)
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

const renderTeams = (teams, currentTeam, setCurrentTeam) => {
  const dropDownItems = teams.map(team => {
    return  team.id !== currentTeam.id
      ? <MenuItem onClick={setCurrentTeam(team)} key={team.name}>{team.name}</MenuItem>
      : null;
  }); 

  return _.compact(dropDownItems);
}

const loggedInOptions = (handleAuthClick, teams, currentTeam, setCurrentTeam, openCreateTeamModal) => {
  console.log(openCreateTeamModal);
  return (
    <Nav pullRight>
      <NavDropdown id="teamDropDown" eventKey={2} title={currentTeam.name}>
        {renderTeams(teams, currentTeam, setCurrentTeam)}
        <MenuItem onClick={openCreateTeamModal} key='openTeamModal'>Create new team</MenuItem>
      </NavDropdown>
      <NavItem eventKey={1} onClick={logOut(handleAuthClick('login'))}>Log out</NavItem>
    </Nav>
  );
}
const NavigationBar = (props) => {
  const {
    handleAuthClick, 
    teams,
    currentTeam,
    setCurrentTeam,
    openCreateTeamModal
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
        {NavOptions(handleAuthClick, teams, currentTeam, setCurrentTeam, openCreateTeamModal)}
      </Navbar.Collapse>
    </Navbar>
  );
}

export default NavigationBar;
