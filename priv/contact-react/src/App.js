import React from 'react';
import {Alert} from 'react-bootstrap';
import request from 'superagent';
import {isLoggedIn, getSession} from './util/session';
import SignUp from './components/SignUp';
import Login from './components/Login';
import NavigationBar from './components/NavigationBar';
import Home from './components/Home';
import CreateTeamModal from './components/CreateTeamModal';
import './App.css';

class App extends React.Component {
  constructor(props) {
    super(props);

    this.initialState = {
      route: 'login',
      loggedIn: isLoggedIn(),
      currentTeam: null, 
      teams: [],
      alert: false,
      showCreateTeamModal: false,
      reload: false,
      user: null
    };

    this.state = {...this.initialState};
  }

  componentDidMount() {
    if (this.state.loggedIn) {
      this.getUserAndTeams();
    }
  }

  componentDidUpdate(prevProps, prevState) {
    if (this.state.reload || (!prevState.loggedIn && prevState.loggedIn !== this.state.loggedIn)) {
      this.getUserAndTeams();
      this.setState({reload: false});
    }
  }

  resetState = () => {
    this.setState(this.initialState);
  }

  getUserAndTeams = () => {
    request
      .get('/api/v1/users/self')
      .accept('application/vnd.api+json')
      .type('application/vnd.api+json')
      .set('authorization', `Bearer ${getSession()}`)
      .then(resp => {
        const teams = resp.body.included.map(team => {
          return {...team.attributes, id: team.id};
        });
        const user = {...resp.body.data.attributes, id: resp.body.data.id};
        const currentTeam = teams[0];

        this.setState({
          user,
          teams,
          currentTeam
        });
      })
      .catch(err => console.log(err));
  }

  alert = () => {
    return (
      <Alert bsStyle={this.state.alert.style}>
        {this.state.alert.message}
      </Alert>
    );
  }

  setAlert = ({style, message}) => {
    this.setState({alert: {style, message}});
    setTimeout(() => this.setState({alert: false}), 10000);
  }

  handleAuthClick = route => {
    return () => {
      this.setState({route, loggedIn: isLoggedIn()});
    }
  }

  setCurrentTeam = currentTeam => {
    return () => { 
      this.setState({currentTeam});
    }
  }

  openCreateTeamModal = () => {
    this.setState({showCreateTeamModal: true});
  } 

  route = () => {
    const noAuthRoute = this.state.route === 'login'
      ? <Login handleAuthClick={this.handleAuthClick('home')}/>
      : <SignUp setAlert={this.setAlert} handleAuthClick={this.handleAuthClick('login')}/>;
    const {user, currentTeam} = this.state;
    return isLoggedIn()
      ? <Home userId={user && user.id} teamId={currentTeam && currentTeam.id} setAlert={this.setAlert} /> 
      : noAuthRoute;
  }

  render() {
    return (
      <div>
        <CreateTeamModal currentUser={this.state.user} setAlert={this.setAlert} close={(shouldReload) => this.setState({showCreateTeamModal: false, reload: shouldReload})} show={this.state.showCreateTeamModal}/>
        <NavigationBar
          currentTeam={this.state.currentTeam}
          setCurrentTeam={this.setCurrentTeam}
          teams={this.state.teams}
          handleAuthClick={this.handleAuthClick}
          openCreateTeamModal={this.openCreateTeamModal}
          resetState={this.resetState}/>
        <div className="container">
          {this.state.alert && this.alert()}
          {this.route()}
        </div>
      </div>
    );
  }
}

export default App;
