import React from 'react';
import request from 'superagent';
import {
  FormGroup,
  FormControl,
  ControlLabel,
  Row,
  Col,
  Panel,
  PageHeader,
  Button
} from 'react-bootstrap';

class Login extends React.Component {
  constructor(props) {
    super(props)

    this.state = {
      email: '',
      username: '',
      firstName: '',
      lastName: '',
      password: '',
      passwordConfirmation: ''
    }
  }

  handleChange = key => {
    return  event => {
      this.setState({[key]: event.target.value});
    }
  }

  signUp = () => {
    this.setState({isLoading: true});
    const{
      email,
      username,
      firstName,
      lastName,
      password,
      passwordConfirmation
    } = this.state;

    request
      .post('/api/v1/users')
      .set('accept', 'application/vnd.api+json')
      .set('content-type', 'application/vnd.api+json')
      .send({
        data: {
          type: "users",
          attributes: {
            email,
            username,
            first_name: firstName,
            last_name: lastName,
            password,
            password_confirmation: passwordConfirmation
          }
        }
      })
      .then(resp => {
        alert('success!');
        console.log(resp);
        this.setState({isLoading: false});
      })
      .catch(err => {
        alert('fail!');
        console.log(err.response);
        this.setState({isLoading: false});
      });
  }

  render() {
    return(
      <Row>
        <PageHeader>Welcome to Contact! <small>Sign Up</small></PageHeader>
        <Col xs={6}xsOffset={3}>
          <Panel>
            <Panel.Heading>Sign Up</Panel.Heading>
            <Panel.Body>
              <FormGroup>
                <ControlLabel>Email</ControlLabel>
                <FormControl value={this.state.email} type='email' placeholder="Email" onChange={this.handleChange('email')}/> 

                <ControlLabel>Username</ControlLabel>
                <FormControl value={this.state.username} placeholder="Username" onChange={this.handleChange('username')}/> 

                <ControlLabel>First Name</ControlLabel>
                <FormControl value={this.state.firstName} placeholder="First Name" onChange={this.handleChange('firstName')}/> 

                <ControlLabel>Last Name</ControlLabel>
                <FormControl value={this.state.lastName} placeholder="Last Name" onChange={this.handleChange('lastName')}/> 

                <ControlLabel>Password</ControlLabel>
                <FormControl value={this.state.password} type='password' placeholder="Password" onChange={this.handleChange('password')}/> 

                <ControlLabel>Password Confirmation</ControlLabel>
                <FormControl value={this.state.passwordConfirmation} type='password' placeholder="Password Confirmation" onChange={this.handleChange('passwordConfirmation')}/> 

                <Button 
                  onClick={this.state.isLoading ? null : this.signUp}
                  disabled={this.state.isLoading}>
                  {this.state.isLoading ? 'Loading...' : 'Sign up!'}
                </Button>
              </FormGroup>
            </Panel.Body>
      </Panel>
    </Col>
  </Row>
    );
  }
}  
export default Login;
