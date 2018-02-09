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

const logOut = (callback, resetState)  => {
  return () => {
    destroySession();
    resetState();
    callback();
  }
}
const NavOptions = (handleClick, teams, currentTeam, setCurrentTeam, openCreateTeamModal, resetState) => {
  return isLoggedIn()
    ? loggedInOptions(handleClick, teams, currentTeam, setCurrentTeam, openCreateTeamModal, resetState)
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

const renderDivider = (show) => show ? <MenuItem key='divider' divider /> : null;

const loggedInOptions = (handleAuthClick, teams, currentTeam, setCurrentTeam, openCreateTeamModal, resetState) => {
  return (
    <Nav pullRight>
      <NavDropdown id="teamDropDown" eventKey={2} title={(currentTeam && currentTeam.name) || 'Create new team'}>
        {renderTeams(teams, currentTeam, setCurrentTeam)}
        {renderDivider(teams.length > 1)}
        <MenuItem onClick={openCreateTeamModal} key='openTeamModal'>Create new team</MenuItem>
      </NavDropdown>
      <NavItem eventKey={1} onClick={logOut(handleAuthClick('login'), resetState)}>Log out</NavItem>
    </Nav>
  );
}
const NavigationBar = (props) => {
  const {
    handleAuthClick, 
    teams,
    currentTeam,
    setCurrentTeam,
    resetState,
    currentUser,
    openCreateTeamModal
  } = props;

  return(
    <Navbar inverse collapseOnSelect>
      <Navbar.Header>
        <Navbar.Text>Contact</Navbar.Text>
        <Navbar.Toggle />
      </Navbar.Header>
      <Navbar.Collapse>
        <Navbar.Text>{currentUser}</Navbar.Text>
        {NavOptions(handleAuthClick, teams, currentTeam, setCurrentTeam, openCreateTeamModal, resetState)}
      </Navbar.Collapse>
    </Navbar>
  );
}

export default NavigationBar;
