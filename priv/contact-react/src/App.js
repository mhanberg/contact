import React from 'react';
import {Alert} from 'react-bootstrap';
import {isLoggedIn} from './util/session';
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
        <NavigationBar handleAuthClick={this.handleAuthClick}></NavigationBar>
        <div className="container">
          {this.state.alert && this.alert()}
          {this.route()}
        </div>
      </div>
    );
  }
}

export default App;
