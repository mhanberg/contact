import React from 'react';
import {Alert} from 'react-bootstrap';
import request from 'superagent';
import {isLoggedIn, getSession} from './util/session';
import SignUp from './components/SignUp';
import Login from './components/Login';
import NavigationBar from './components/NavigationBar';
import './App.css';

class App extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      route: 'login',
      loggedIn: isLoggedIn(),
      alert: false
    }
  }

  componentDidMount() {
    if (this.state.loggedIn) {
      request
        .get('/api/v1/users/self')
        .accept('application/vnd.api+json')
        .type('application/vnd.api+json')
        .set('authorization', `Bearer ${getSession()}`)
        .then(resp => {
          this.setState({
            user: {...resp.body.data.attributes},
            teams: resp.body.included.map(team => {
              return {...team.attributes};
            })
          });
        })
        .catch(err => console.log(err));
    }
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

  handleAuthClick = (route) => {
    return () => {
      this.setState({route, loggedIn: isLoggedIn()});
    }
  }

  route = () => {
    const noAuthRoute = this.state.route === 'login'
      ? <Login handleAuthClick={this.handleAuthClick('home')}/>
      : <SignUp setAlert={this.setAlert} handleAuthClick={this.handleAuthClick('login')}/>;
    return isLoggedIn()
      ? <div>You'e logged in!</div> 
      : noAuthRoute;
  }

  render() {
    return (
      <div>
        <NavigationBar teams={this.state.teams} handleAuthClick={this.handleAuthClick}></NavigationBar>
        <div className="container">
          {this.state.alert && this.alert()}
          {this.route()}
        </div>
      </div>
    );
  }
}

export default App;
